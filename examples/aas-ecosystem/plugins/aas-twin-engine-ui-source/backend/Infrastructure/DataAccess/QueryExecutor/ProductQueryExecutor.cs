using System.Data.Common;
using AAS.TwinEngine.UI.Backend.ApplicationLogic.Exceptions.Base;
using Npgsql;

namespace AAS.TwinEngine.UI.Backend.Infrastructure.DataAccess.QueryExecutor;

public sealed class ProductQueryExecutor(NpgsqlDataSource dataSource) : IQueryExecutor
{
    public async Task<string?> ExecuteInTransactionAsync(
        string query, IEnumerable<DbParameter> parameters, string advisoryLockName,
        CancellationToken cancellationToken)
    {
        await using var connection = await dataSource.OpenConnectionAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);
        try
        {
            await AcquireAdvisoryLockAsync(connection, transaction, advisoryLockName, cancellationToken);

            await using var command = new NpgsqlCommand(query, connection, transaction);
            foreach (var parameter in parameters)
            {
                command.Parameters.Add(parameter);
            }

            var result = await command.ExecuteScalarAsync(cancellationToken);
            await transaction.CommitAsync(cancellationToken);
            return result is null or DBNull ? null : (string)result;
        }
        catch (PostgresException exception) when (exception.SqlState == PostgresErrorCodes.UniqueViolation)
        {
            throw new ConflictException("Resource already exists.", exception);
        }
    }

    public async Task ExecuteNonQueryInTransactionAsync(
        string query, string advisoryLockName, CancellationToken cancellationToken)
    {
        await using var connection = await dataSource.OpenConnectionAsync(cancellationToken);
        await using var transaction = await connection.BeginTransactionAsync(cancellationToken);

        await AcquireAdvisoryLockAsync(connection, transaction, advisoryLockName, cancellationToken);

        await using var command = new NpgsqlCommand(query, connection, transaction);
        await command.ExecuteNonQueryAsync(cancellationToken);
        await transaction.CommitAsync(cancellationToken);
    }

    // Share DPP's lock so both services can safely allocate MAX-based identifiers.
    private static async Task AcquireAdvisoryLockAsync(
        NpgsqlConnection connection, NpgsqlTransaction transaction, string advisoryLockName,
        CancellationToken cancellationToken)
    {
        await using var lockCommand = new NpgsqlCommand(
            "SELECT pg_advisory_xact_lock(hashtext(@LockName))", connection, transaction);
        lockCommand.Parameters.AddWithValue("LockName", advisoryLockName);
        await lockCommand.ExecuteNonQueryAsync(cancellationToken);
    }
}

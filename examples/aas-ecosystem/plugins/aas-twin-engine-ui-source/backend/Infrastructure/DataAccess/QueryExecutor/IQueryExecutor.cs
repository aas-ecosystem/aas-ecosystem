using System.Data.Common;

namespace AAS.TwinEngine.UI.Backend.Infrastructure.DataAccess.QueryExecutor;

public interface IQueryExecutor
{
    Task<string?> ExecuteInTransactionAsync(
        string query, IEnumerable<DbParameter> parameters, string advisoryLockName,
        CancellationToken cancellationToken);

    Task ExecuteNonQueryInTransactionAsync(
        string query, string advisoryLockName, CancellationToken cancellationToken);
}

using AasSuitePluginAbstractions;
using AAS.TwinEngine.UI.Backend.Api.SubmodelData.Handler;
using AAS.TwinEngine.UI.Backend.Api.SubmodelData.Requests;
using AAS.TwinEngine.UI.Backend.ApplicationLogic.Services.SubmodelData;
using AAS.TwinEngine.UI.Backend.ApplicationLogic.Services.SubmodelData.Providers;
using AAS.TwinEngine.UI.Backend.Infrastructure.DataAccess;
using AAS.TwinEngine.UI.Backend.Infrastructure.DataAccess.QueryExecutor;
using AAS.TwinEngine.UI.Backend.Infrastructure.Providers.SubmodelData;
using AAS.TwinEngine.UI.Backend.Middleware;
using Npgsql;
using IQueryProvider = AAS.TwinEngine.UI.Backend.ApplicationLogic.Services.Shared.IQueryProvider;

namespace AAS.TwinEngine.UI.Backend;

public sealed class TwinEngineBackendPlugin : IAasSuiteBackendPlugin
{
    public const string RoutePrefix = "/plugin-api/aas-twin-engine-ui";

    public void ConfigureServices(IServiceCollection services)
    {
        services.AddSingleton(provider =>
        {
            var configuration = provider.GetRequiredService<IConfiguration>();
            var connectionString = configuration["RelationalDatabaseConfiguration:ConnectionString"];
            if (string.IsNullOrWhiteSpace(connectionString))
            {
                throw new InvalidOperationException(
                    "Set RelationalDatabaseConfiguration__ConnectionString on the AAS Suite backend to the DPP database connection string.");
            }

            return NpgsqlDataSource.Create(connectionString);
        });
        services.AddSingleton<IQueryProvider, ProductQueryProvider>();
        services.AddScoped<IQueryExecutor, ProductQueryExecutor>();
        services.AddScoped<IProductProvider, ProductProvider>();
        services.AddScoped<IProductService, ProductService>();
        services.AddScoped<IProductHandler, ProductHandler>();
        services.AddScoped<ApiExceptionHandler>();
    }

    public void MapEndpoints(IEndpointRouteBuilder endpoints)
    {
        var group = endpoints.MapGroup(RoutePrefix);
        group.AddEndpointFilter(async (context, next) =>
        {
            try
            {
                return await next(context);
            }
            catch (Exception exception) when (exception is not OperationCanceledException)
            {
                var handler = context.HttpContext.RequestServices.GetRequiredService<ApiExceptionHandler>();
                await handler.TryHandleAsync(context.HttpContext, exception, context.HttpContext.RequestAborted);
                return Results.Empty;
            }
        });

        group.MapGet("/healthz", () => Results.Ok(new { status = "ok" }));
        group.MapPost("/submodel-data/products", async (
            CreateProductRequest request, IProductHandler handler, CancellationToken cancellationToken) =>
        {
            var response = await handler.CreateProductAsync(request, cancellationToken);
            return Results.Created(
                $"{RoutePrefix}/submodel-data/products/{Uri.EscapeDataString(response.ProductId)}", response);
        });
        group.MapPut("/submodel-data/products/{productId}", async (
            string productId, UpdateProductRequest request, IProductHandler handler, CancellationToken cancellationToken) =>
            Results.Ok(await handler.UpdateProductAsync(productId, request, cancellationToken)));
        group.MapDelete("/submodel-data/products/{productId}", async (
            string productId, IProductHandler handler, CancellationToken cancellationToken) =>
        {
            await handler.DeleteProductAsync(productId, cancellationToken);
            return Results.NoContent();
        });
        group.MapPost("/submodel-data/reset", async (IProductHandler handler, CancellationToken cancellationToken) =>
        {
            await handler.ResetDataAsync(cancellationToken);
            return Results.NoContent();
        });
    }
}

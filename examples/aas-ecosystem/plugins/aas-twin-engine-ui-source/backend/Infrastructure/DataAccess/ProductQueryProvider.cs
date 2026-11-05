using IQueryProvider = AAS.TwinEngine.UI.Backend.ApplicationLogic.Services.Shared.IQueryProvider;

namespace AAS.TwinEngine.UI.Backend.Infrastructure.DataAccess;

public sealed class ProductQueryProvider : IQueryProvider
{
    private readonly Dictionary<string, string> queries = new(StringComparer.Ordinal);

    public ProductQueryProvider()
    {
        var assembly = typeof(ProductQueryProvider).Assembly;
        foreach (var name in new[] { "CreateProduct", "UpdateProduct", "DeleteProduct", "ResetData" })
        {
            var resource = $"{assembly.GetName().Name}.Infrastructure.DataAccess.Queries.{name}.sql";
            using var stream = assembly.GetManifestResourceStream(resource)
                ?? throw new InvalidOperationException($"Required product query '{name}' is missing.");
            using var reader = new StreamReader(stream);
            queries.Add(name, reader.ReadToEnd());
        }
    }

    public string? GetQuery(string serviceName) => queries.GetValueOrDefault(serviceName);
}

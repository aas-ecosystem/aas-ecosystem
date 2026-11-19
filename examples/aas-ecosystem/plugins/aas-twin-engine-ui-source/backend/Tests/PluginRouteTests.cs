using System.Net;
using System.Net.Http.Json;
using AAS.TwinEngine.UI.Backend.ApplicationLogic.Services.SubmodelData.Providers;
using AAS.TwinEngine.UI.Backend.DomainModel.SubmodelData;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace AAS.TwinEngine.UI.Backend.Tests;

public sealed class PluginRouteTests
{
    private const string BaseRoute = "/plugin-api/aas-twin-engine-ui";

    [Fact]
    public async Task PluginHealth_WhenMapped_Returns200()
    {
        await using var factory = new Factory();
        using var client = factory.CreateClient();
        using var response = await client.GetAsync($"{BaseRoute}/healthz");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task Create_WhenValid_Returns201WithPluginLocation()
    {
        await using var factory = new Factory();
        using var client = factory.CreateClient();
        using var response = await client.PostAsJsonAsync($"{BaseRoute}/submodel-data/products", new
        {
            name = "TestProduct",
            dateOfManufacture = "2026-01-01",
            manufacturerName = "Manufacturer",
            manufacturerArticleNumber = "ARTICLE-1",
            pcfCO2eq = 12.5,
            referenceImpactUnitForCalculation = "piece"
        });
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        Assert.Equal($"{BaseRoute}/submodel-data/products/000-001", response.Headers.Location?.OriginalString);
        Assert.Equal("TestProduct", factory.Provider.Created?.IdShort);
    }

    [Fact]
    public async Task Update_WhenNumbersAreStrings_Returns200()
    {
        await using var factory = new Factory();
        using var client = factory.CreateClient();
        using var response = await client.PutAsJsonAsync($"{BaseRoute}/submodel-data/products/000-001", new
        {
            id = "000-001",
            dateOfManufacture = "2026-01-01",
            addressInformation = new { street = "Street", zipcode = "10115", cityTown = "Berlin", nationalCode = "DE" },
            serialNumber = "SERIAL",
            manufacturerProductType = "Type",
            manufacturerName = "Manufacturer",
            manufacturerArticleNumber = "ARTICLE",
            pcfCO2eq = 12.5,
            referenceImpactUnitForCalculation = "piece",
            quantityOfMeasureForCalculation = "1",
            publicationDate = "2026-01-01",
            expirationDate = "2027-01-01",
            length = "10",
            width = "20",
            height = "30"
        });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        Assert.Equal(30m, factory.Provider.Updated?.Height);
    }

    [Theory]
    [InlineData(true, HttpStatusCode.NoContent)]
    [InlineData(false, HttpStatusCode.NotFound)]
    public async Task Delete_WhenCalled_ReturnsExpectedStatus(bool exists, HttpStatusCode expected)
    {
        await using var factory = new Factory();
        factory.Provider.Exists = exists;
        using var client = factory.CreateClient();
        using var response = await client.DeleteAsync($"{BaseRoute}/submodel-data/products/000-001");
        Assert.Equal(expected, response.StatusCode);
    }

    [Fact]
    public async Task Reset_WhenCalled_Returns204AndRunsTruncateAndSeedScript()
    {
        await using var factory = new Factory();
        using var client = factory.CreateClient();
        using var response = await client.PostAsync($"{BaseRoute}/submodel-data/reset", content: null);
        Assert.Equal(HttpStatusCode.NoContent, response.StatusCode);
        Assert.Contains("RESTART IDENTITY CASCADE", factory.Provider.ResetSql);
        Assert.Contains("'000-001','Car1'", factory.Provider.ResetSql);
        Assert.Contains("INSERT INTO \"DocumentDocumentVersion\"", factory.Provider.ResetSql);
    }

    [Fact]
    public async Task Create_WhenInvalid_Returns400WithoutWriting()
    {
        await using var factory = new Factory();
        using var client = factory.CreateClient();
        using var response = await client.PostAsJsonAsync($"{BaseRoute}/submodel-data/products", new { name = "invalid name" });
        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        Assert.Contains("valid AAS idShort", await response.Content.ReadAsStringAsync());
        Assert.Null(factory.Provider.Created);
    }

    private sealed class Factory : WebApplicationFactory<Program>
    {
        public FakeProvider Provider { get; } = new();

        protected override void ConfigureWebHost(IWebHostBuilder builder)
        {
            builder.UseSetting("RelationalDatabaseConfiguration:ConnectionString",
                "Host=127.0.0.1;Port=1;Database=unused;Username=unused");
            builder.ConfigureServices(services =>
            {
                services.RemoveAll<IProductProvider>();
                services.AddSingleton<IProductProvider>(Provider);
            });
        }
    }

    private sealed class FakeProvider : IProductProvider
    {
        public bool Exists { get; set; } = true;
        public NewProduct? Created { get; private set; }
        public UpdatedProduct? Updated { get; private set; }
        private static CreatedProduct Product => new("000-001", "TestProduct", "https://example.test/aas/000-001", "https://example.test/assets/000-001");

        public Task<CreatedProduct?> CreateProductAsync(string sql, NewProduct product, CancellationToken token)
        {
            Created = product;
            return Task.FromResult<CreatedProduct?>(Product);
        }

        public Task<CreatedProduct?> UpdateProductAsync(string sql, UpdatedProduct product, CancellationToken token)
        {
            Updated = product;
            return Task.FromResult<CreatedProduct?>(Product);
        }

        public Task<bool> DeleteProductAsync(string sql, string productId, CancellationToken token) => Task.FromResult(Exists);

        public string? ResetSql { get; private set; }

        public Task ResetDataAsync(string sql, CancellationToken token)
        {
            ResetSql = sql;
            return Task.CompletedTask;
        }
    }
}

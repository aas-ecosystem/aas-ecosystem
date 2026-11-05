using AAS.TwinEngine.UI.Backend.ApplicationLogic.Exceptions.Application;
using AAS.TwinEngine.UI.Backend.ApplicationLogic.Exceptions.Base;
using AAS.TwinEngine.UI.Backend.ApplicationLogic.Services.SubmodelData.Providers;
using AAS.TwinEngine.UI.Backend.DomainModel.SubmodelData;

using IQueryProvider = AAS.TwinEngine.UI.Backend.ApplicationLogic.Services.Shared.IQueryProvider;

namespace AAS.TwinEngine.UI.Backend.ApplicationLogic.Services.SubmodelData;

public class ProductService(ILogger<ProductService> logger, IQueryProvider queryProvider, IProductProvider productProvider) : IProductService
{
    private const string CreateProductQueryName = "CreateProduct";

    public async Task DeleteProductAsync(string productId, CancellationToken cancellationToken)
    {
        var sqlQuery = queryProvider.GetQuery("DeleteProduct");
        if (string.IsNullOrWhiteSpace(sqlQuery))
        {
            throw new QueryNotAvailableException();
        }

        if (!await productProvider.DeleteProductAsync(sqlQuery, productId, cancellationToken).ConfigureAwait(false))
        {
            throw new NotFoundException("Product", productId);
        }

        logger.LogInformation("Deleted product {ProductId}", productId);
    }

    public async Task ResetDataAsync(CancellationToken cancellationToken)
    {
        var sqlQuery = queryProvider.GetQuery("ResetData");
        if (string.IsNullOrWhiteSpace(sqlQuery))
        {
            throw new QueryNotAvailableException();
        }

        await productProvider.ResetDataAsync(sqlQuery, cancellationToken).ConfigureAwait(false);
        logger.LogWarning("Product data was reset to the seed data");
    }

    public async Task<CreatedProduct> UpdateProductAsync(UpdatedProduct product, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(product);

        var sqlQuery = queryProvider.GetQuery("UpdateProduct");
        if (string.IsNullOrWhiteSpace(sqlQuery))
        {
            throw new QueryNotAvailableException();
        }

        var updatedProduct = await productProvider.UpdateProductAsync(sqlQuery, product, cancellationToken).ConfigureAwait(false);
        if (updatedProduct is null)
        {
            throw new NotFoundException("Product", product.ProductId);
        }

        logger.LogInformation("Updated product {ProductId}", updatedProduct.ProductId);
        return updatedProduct;
    }

    public async Task<CreatedProduct> CreateProductAsync(NewProduct product, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(product);

        var sqlQuery = queryProvider.GetQuery(CreateProductQueryName);
        if (string.IsNullOrWhiteSpace(sqlQuery))
        {
            logger.LogError("Query not available: {QueryName}", CreateProductQueryName);
            throw new QueryNotAvailableException();
        }

        var createdProduct = await productProvider.CreateProductAsync(sqlQuery, product, cancellationToken).ConfigureAwait(false);
        if (createdProduct is null)
        {
            logger.LogWarning("Product with IdShort {IdShort} already exists", product.IdShort);
            throw new ConflictException($"Product with IdShort '{product.IdShort}' already exists.");
        }

        logger.LogInformation("Created product {ProductId} with IdShort {IdShort}", createdProduct.ProductId, createdProduct.IdShort);

        return createdProduct;
    }
}

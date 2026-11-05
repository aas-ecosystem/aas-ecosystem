using AAS.TwinEngine.UI.Backend.DomainModel.SubmodelData;

namespace AAS.TwinEngine.UI.Backend.ApplicationLogic.Services.SubmodelData;

public interface IProductService
{
    Task DeleteProductAsync(string productId, CancellationToken cancellationToken);

    Task<CreatedProduct> CreateProductAsync(NewProduct product, CancellationToken cancellationToken);

    Task<CreatedProduct> UpdateProductAsync(UpdatedProduct product, CancellationToken cancellationToken);

    Task ResetDataAsync(CancellationToken cancellationToken);
}

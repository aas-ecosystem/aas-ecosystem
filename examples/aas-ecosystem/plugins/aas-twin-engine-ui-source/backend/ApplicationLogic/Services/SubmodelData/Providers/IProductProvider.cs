using AAS.TwinEngine.UI.Backend.DomainModel.SubmodelData;

namespace AAS.TwinEngine.UI.Backend.ApplicationLogic.Services.SubmodelData.Providers;

public interface IProductProvider
{
    Task<bool> DeleteProductAsync(string sqlQuery, string productId, CancellationToken cancellationToken);

    Task<CreatedProduct?> CreateProductAsync(string sqlQuery, NewProduct product, CancellationToken cancellationToken);

    Task<CreatedProduct?> UpdateProductAsync(string sqlQuery, UpdatedProduct product, CancellationToken cancellationToken);

    Task ResetDataAsync(string sqlQuery, CancellationToken cancellationToken);
}

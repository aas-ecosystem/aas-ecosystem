using AAS.TwinEngine.UI.Backend.Api.SubmodelData.Requests;
using AAS.TwinEngine.UI.Backend.Api.SubmodelData.Responses;

namespace AAS.TwinEngine.UI.Backend.Api.SubmodelData.Handler;

public interface IProductHandler
{
    Task DeleteProductAsync(string productId, CancellationToken cancellationToken);

    Task<CreateProductResponse> CreateProductAsync(CreateProductRequest request, CancellationToken cancellationToken);

    Task<UpdateProductResponse> UpdateProductAsync(string productId, UpdateProductRequest request, CancellationToken cancellationToken);

    Task ResetDataAsync(CancellationToken cancellationToken);
}

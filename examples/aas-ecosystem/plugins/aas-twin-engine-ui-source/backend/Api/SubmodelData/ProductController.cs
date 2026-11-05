using AAS.TwinEngine.UI.Backend.Api.SubmodelData.Handler;
using AAS.TwinEngine.UI.Backend.Api.SubmodelData.Requests;
using AAS.TwinEngine.UI.Backend.Api.SubmodelData.Responses;
using Microsoft.AspNetCore.Mvc;

namespace AAS.TwinEngine.UI.Backend.Api.SubmodelData;

[ApiController]
[Route("submodel-data/products")]
public sealed class ProductController(IProductHandler productHandler) : ControllerBase
{
    [HttpPost]
    [EndpointSummary("Create a product using the DPP product contract")]
    [ProducesResponseType<CreateProductResponse>(StatusCodes.Status201Created)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status409Conflict)]
    public async Task<ActionResult<CreateProductResponse>> CreateProductAsync(
        CreateProductRequest request, CancellationToken cancellationToken)
    {
        var response = await productHandler.CreateProductAsync(request, cancellationToken);
        return Created($"{Request.PathBase}/submodel-data/products/{Uri.EscapeDataString(response.ProductId)}", response);
    }

    [HttpPut("{productId}")]
    [EndpointSummary("Update editable product data without changing its identifiers")]
    [ProducesResponseType<UpdateProductResponse>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status409Conflict)]
    public async Task<ActionResult<UpdateProductResponse>> UpdateProductAsync(
        string productId, UpdateProductRequest request, CancellationToken cancellationToken)
    {
        return Ok(await productHandler.UpdateProductAsync(productId, request, cancellationToken));
    }

    [HttpDelete("{productId}")]
    [EndpointSummary("Delete a product and its unshared related records")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> DeleteProductAsync(string productId, CancellationToken cancellationToken)
    {
        await productHandler.DeleteProductAsync(productId, cancellationToken);
        return NoContent();
    }

    [HttpPost("~/submodel-data/reset")]
    [EndpointSummary("Truncate all product data and re-insert the demo seed data")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> ResetDataAsync(CancellationToken cancellationToken)
    {
        await productHandler.ResetDataAsync(cancellationToken);
        return NoContent();
    }
}

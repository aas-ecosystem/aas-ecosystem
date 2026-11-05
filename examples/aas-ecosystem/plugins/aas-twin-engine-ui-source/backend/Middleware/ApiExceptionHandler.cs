using AAS.TwinEngine.UI.Backend.ApplicationLogic.Exceptions.Base;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Npgsql;

namespace AAS.TwinEngine.UI.Backend.Middleware;

public sealed class ApiExceptionHandler(ILogger<ApiExceptionHandler> logger) : IExceptionHandler
{
    public async ValueTask<bool> TryHandleAsync(
        HttpContext httpContext, Exception exception, CancellationToken cancellationToken)
    {
        var (status, title, detail) = exception switch
        {
            BadRequestException => (400, "Invalid request", exception.Message),
            NotFoundException => (404, "Product not found", "The requested product does not exist."),
            ConflictException => (409, "Product conflict", exception.Message),
            NpgsqlException { IsTransient: true } => (503, "Database unavailable", "The product database is temporarily unavailable."),
            _ => (500, "Internal server error", "The product operation could not be completed.")
        };

        logger.Log(status >= 500 ? LogLevel.Error : LogLevel.Warning, exception,
            "Product API request failed with status {Status}", status);
        httpContext.Response.StatusCode = status;
        await httpContext.Response.WriteAsJsonAsync(new ProblemDetails
        {
            Status = status,
            Title = title,
            Detail = detail,
            Instance = httpContext.Request.Path
        }, options: null, contentType: "application/problem+json", cancellationToken: cancellationToken);
        return true;
    }
}

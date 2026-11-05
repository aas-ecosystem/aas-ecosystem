using AAS.TwinEngine.UI.Backend;
using AAS.TwinEngine.UI.Backend.Infrastructure.DataAccess;
using AAS.TwinEngine.UI.Backend.Middleware;

var builder = WebApplication.CreateBuilder(args);

// Use the same optional mounted configuration file and setting as the DPP plugin.
builder.Configuration.AddJsonFile("/config/dpp-env.json", optional: true, reloadOnChange: false);
builder.Configuration.AddEnvironmentVariables();
builder.Configuration.AddCommandLine(args);

var connectionString = builder.Configuration["RelationalDatabaseConfiguration:ConnectionString"];
if (string.IsNullOrWhiteSpace(connectionString))
{
    throw new InvalidOperationException(
        "Set RelationalDatabaseConfiguration__ConnectionString to the connection string used by the DPP plugin.");
}

var plugin = new TwinEngineBackendPlugin();
plugin.ConfigureServices(builder.Services);
builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.AddProblemDetails();
builder.Services.AddExceptionHandler<ApiExceptionHandler>();
builder.Services.AddHealthChecks().AddCheck<DatabaseHealthCheck>("database");

var allowedOrigins = builder.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>() ?? [];
builder.Services.AddCors(options => options.AddDefaultPolicy(policy =>
{
    if (allowedOrigins.Length > 0)
    {
        policy.WithOrigins(allowedOrigins).AllowAnyHeader().AllowAnyMethod();
    }
}));

var app = builder.Build();
app.UseExceptionHandler();
app.UseStatusCodePages();
app.UseCors();
app.MapHealthChecks("/healthz");
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.MapControllers();
plugin.MapEndpoints(app);
app.Run();

public partial class Program;

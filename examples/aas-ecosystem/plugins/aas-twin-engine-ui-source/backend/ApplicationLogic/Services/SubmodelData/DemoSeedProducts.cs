namespace AAS.TwinEngine.UI.Backend.ApplicationLogic.Services.SubmodelData;

/// <summary>
/// Products from the demo seed (postgres-init/seed, ResetData.sql). They must stay available for the
/// demo, so the API refuses to delete them; "Reset Data" restores them in any case.
/// Keep in sync with PROTECTED_PRODUCT_IDS in the frontend (shell-list.ts).
/// </summary>
public static class DemoSeedProducts
{
    public static IReadOnlySet<string> ProtectedProductIds { get; } =
        new HashSet<string>(StringComparer.Ordinal) { "000-001", "000-002", "000-003" };
}

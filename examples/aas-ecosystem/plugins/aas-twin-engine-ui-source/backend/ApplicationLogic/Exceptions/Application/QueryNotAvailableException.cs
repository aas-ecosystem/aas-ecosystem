using AAS.TwinEngine.UI.Backend.ApplicationLogic.Exceptions.Base;

namespace AAS.TwinEngine.UI.Backend.ApplicationLogic.Exceptions.Application;

public class QueryNotAvailableException : InternalServerException
{
    public const string DefaultMessage = "Internal Server Error.";

    public QueryNotAvailableException() : base(DefaultMessage) { }

    public QueryNotAvailableException(Exception ex) : base(DefaultMessage, ex) { }

    public QueryNotAvailableException(string message) : base(DefaultMessage)
    {
    }
}

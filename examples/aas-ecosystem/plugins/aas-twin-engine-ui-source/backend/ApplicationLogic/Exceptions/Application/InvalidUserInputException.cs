using AAS.TwinEngine.UI.Backend.ApplicationLogic.Exceptions.Base;

namespace AAS.TwinEngine.UI.Backend.ApplicationLogic.Exceptions.Application;

public class InvalidUserInputException : BadRequestException
{
    public const string DefaultMessage = "Invalid User Input.";

    public InvalidUserInputException() : base(DefaultMessage) { }

    public InvalidUserInputException(Exception ex) : base(DefaultMessage, ex) { }

    public InvalidUserInputException(string message) : base(message)
    {
    }

    public InvalidUserInputException(string message, Exception innerException) : base(message, innerException)
    {
    }
}

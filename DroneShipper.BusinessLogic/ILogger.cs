namespace DroneShipper.BusinessLogic {

    public interface ILogger {
        void Log(string message, params object[] parameters);
    }

}
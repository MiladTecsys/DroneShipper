using System.Threading;
using DroneShipper.BusinessLogic;

namespace DroneShipper.Processor.Console {
    internal class Program {

        private static void Main(string[] args) {
            var logger = new ConsoleLogger();
            logger.Log("Shipment processor console app start");
            var shipmentProcessor = new ShipmentProcessor(logger);
            while (true) {
                logger.Log("");
                shipmentProcessor.Run();
                Thread.Sleep(5000);
                logger.Log("");
            }
        }
    }
}
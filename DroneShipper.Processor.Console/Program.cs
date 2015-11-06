using DroneShipper.BusinessLogic;

namespace DroneShipper.Processor.Console {
    internal class Program {
        private static void Main(string[] args) {
            var logger = new ConsoleLogger();
            logger.Log("Shipment processor console app start");
            var shipmentProcessor = new ShipmentProcessor(logger);
            shipmentProcessor.Run();
            logger.Log("Shipment processor console app end. Press any key to exit...");
            System.Console.ReadKey();
        }
    }
}
namespace DroneShipper.BusinessFacade {
    public class ShipmentInfo {
        public int Id { get; set; }

        public AddressInfo SourceAddress { get; set; }

        public AddressInfo DestinationAddress { get; set; }

        public decimal Weight { get; set; }

        public ShipmentStatus Status { get; set; }

        public int DroneId { get; set; }
    }
}
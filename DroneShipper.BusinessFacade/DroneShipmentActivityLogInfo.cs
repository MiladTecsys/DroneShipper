using System;

namespace DroneShipper.BusinessFacade {
    public class DroneShipmentActivityLogInfo {
        public int Id { get; set; }
        public int DroneId { get; set; }
        public int ShipmentId { get; set; }
        public DateTime DateTimeUtc { get; set; }
        public string Message { get; set; }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

using DroneShipper.BusinessFacade;

namespace DroneShipper.BusinessLogic
{
    public class DroneAPI
    {
        private const int MIN_TRAVEL_TIME_IN_SECONDS = 10;
        private const int MAX_TRAVEL_TIME_IN_SECONDS = 30;

        public int ShipmentId{
            get;
            set;
        }

        public int DroneId{
            get;
            set;
        }

        public void ProcessShipment() {

            if (ShipmentId <= 0) {
                throw new ArgumentOutOfRangeException("ShipmentId not specified");
            }

            if (DroneId <= 0) {
                throw new ArgumentOutOfRangeException("DroneId not specified");
            }

            ProcessShipment(ShipmentId, DroneId);
        }

        private void ProcessShipment(int shipmentId, int droneId) {

            Random r = new Random();
            int travelTime;

            ShipmentBLL shipBLL = new ShipmentBLL();
            DroneBLL droneBLL = new DroneBLL();
            DroneShipmentActivityLogBLL logBLL = new DroneShipmentActivityLogBLL();
            BaseBLL baseBll = new BaseBLL();
            AddressBLL addressBll = new AddressBLL();

            // Start
            ShipmentInfo shipment = shipBLL.GetShipment(shipmentId);
            shipment.Status = ShipmentStatus.InTransit;
            shipment.DroneId = droneId;
            shipBLL.UpdateShipment(shipment);

            DroneShipmentActivityLogInfo log = new DroneShipmentActivityLogInfo();
            log.DroneId = droneId;
            log.ShipmentId = shipmentId;
            log.Message = "Beginning processing";
            logBLL.AddDroneShipmentActivityLog(log);

            // Go pick up shipment
            DroneInfo drone = droneBLL.GetDrone(droneId);
            drone.Status = DroneStatus.PickingUpShipment;
            droneBLL.UpdateDrone(drone);

            log.Message = "Travelling to shipment source for pickup";
            logBLL.AddDroneShipmentActivityLog(log);

            travelTime= r.Next(MIN_TRAVEL_TIME_IN_SECONDS, MAX_TRAVEL_TIME_IN_SECONDS);
            log.Message = string.Format("Estimated time to reach shipment source (in seconds): {0}", travelTime);
            logBLL.AddDroneShipmentActivityLog(log);

            TravelTo(droneBLL, drone, shipment.SourceAddress.Longitude, shipment.SourceAddress.Latitude, travelTime);

            // Deliver shipment

            log.Message = "Delivering shipment to destination";
            logBLL.AddDroneShipmentActivityLog(log);

            drone.Status = DroneStatus.DeliveringShipment;
            droneBLL.UpdateDrone(drone);

            travelTime = r.Next(MIN_TRAVEL_TIME_IN_SECONDS, MAX_TRAVEL_TIME_IN_SECONDS);
            log.Message = string.Format("Estimated time to reach shipment destination (in seconds): {0}", travelTime);
            logBLL.AddDroneShipmentActivityLog(log);


            TravelTo(droneBLL, drone, shipment.DestinationAddress.Longitude, shipment.DestinationAddress.Latitude, travelTime);

            // Shipment delivered
            shipment.Status = ShipmentStatus.Shipped;
            shipBLL.UpdateShipment(shipment);

            log.Message = "Shipment delivered";
            logBLL.AddDroneShipmentActivityLog(log);

            // Returning home
            log.Message = "Returning to base";
            logBLL.AddDroneShipmentActivityLog(log);
            drone.Status = DroneStatus.ReturningToBase;
            droneBLL.UpdateDrone(drone);

            // Find the nearest base and go there
            log.Message = "Locating the nearest base";
            logBLL.AddDroneShipmentActivityLog(log);

            var bases = baseBll.GetAll();
            BaseInfo nearestBase = null;
            double shortestDistance = double.MaxValue;
            foreach (var baseInfo in bases) {
                var distance = addressBll.GetDistanceKm((double)drone.Latitude, (double)drone.Longitude, (double)baseInfo.Address.Latitude, (double)baseInfo.Address.Longitude);
                if (distance < shortestDistance) {
                    shortestDistance = distance;
                    nearestBase = baseInfo;
                }
            }

            log.Message = string.Format("Nearest base is: {0}", nearestBase.Name);
            logBLL.AddDroneShipmentActivityLog(log);
            travelTime = r.Next(MIN_TRAVEL_TIME_IN_SECONDS, MAX_TRAVEL_TIME_IN_SECONDS);
            log.Message = string.Format("Estimated time to reach base (in seconds): {0}", travelTime);
            logBLL.AddDroneShipmentActivityLog(log);

            TravelTo(droneBLL, drone, nearestBase.Address.Longitude, nearestBase.Address.Latitude, travelTime);

            // End 
            log.Message = "Now available";
            logBLL.AddDroneShipmentActivityLog(log);

            drone.Status = DroneStatus.Available;
            droneBLL.UpdateDrone(drone);
        }

        private void TravelTo(DroneBLL droneBLL, DroneInfo drone, decimal destinationLongitude, decimal destinationLatitude, int maxTravelTime) {

            int currentTravelTime = 0;

            decimal totalLatitudeDistanceToTravel = drone.Latitude > destinationLatitude ? -(drone.Latitude - destinationLatitude) : destinationLatitude - drone.Latitude;
            decimal totalLongitudeDistanceToTravel = drone.Longitude > destinationLongitude ? -(drone.Longitude - destinationLongitude) : destinationLongitude - drone.Longitude;

            decimal latitudeIncrement = totalLatitudeDistanceToTravel / Convert.ToDecimal(maxTravelTime);
            decimal longitudeIncrement = totalLongitudeDistanceToTravel / Convert.ToDecimal(maxTravelTime);

            // will update every second
            while (currentTravelTime < maxTravelTime) {

                drone.Latitude += latitudeIncrement;
                drone.Longitude += longitudeIncrement;

                droneBLL.UpdateDrone(drone);

                currentTravelTime += 1;
                Thread.Sleep(1000);
            }

        }
    }
}

using System.Collections.Generic;
using System.Linq;
using DroneShipper.BusinessFacade;

namespace DroneShipper.BusinessLogic {

    public class ShipmentProcessor {

        private readonly ShipmentBLL _shipmentBll;
        private readonly AddressBLL _addressBll;
        private readonly DroneBLL _droneBll;
        private readonly ILogger _logger;
        private readonly DroneStatus[] _availableDroneStatus = {DroneStatus.Available, DroneStatus.ReturningToBase};

        public ShipmentProcessor(ILogger logger) {
            _shipmentBll = new ShipmentBLL();
            _addressBll = new AddressBLL();
            _droneBll = new DroneBLL();
            _logger = logger;
        }

        public void Run() {

            _logger.Log("Shipment processor start");

            ProcessShipments();

            _logger.Log("Shipment processor end");

        }

        private void ProcessShipments() {
            
            var shipments = _shipmentBll.GetShipments(new List<ShipmentStatus> {ShipmentStatus.AwaitingShipment}).OrderBy(s => s.Id);

            if (!shipments.Any()) {
                _logger.Log("There are no shipments to process");
                return;
            }

            _logger.Log("There are {0} shipments waiting to process", shipments.Count());

            var drones = GetAvailableDrones();
            if (!drones.Any()) {
                _logger.Log("No drone is available for delivering shipments");
                return;
            }

            foreach (var shipment in shipments) {
                // Get the closes drone that matches shipment specs
                _logger.Log("Processing shipment #{0} (weight: {1})", shipment.Id, shipment.Weight);
                var drone = GetNearestDrone(shipment);
                if (drone != null) {
                    AssignShipmentToDrone(shipment, drone);
                }
                if (!GetAvailableDrones().Any()) {
                    _logger.Log("No more drones available to deliver shipments");
                    break;
                }
            }

        }

        private void AssignShipmentToDrone(ShipmentInfo shipment, DroneInfo drone) {
            _logger.Log("Assignig shipment #{0} to drone {1}", shipment.Id, drone.Name);
            _shipmentBll.AssignDroneToShipment(drone.Id, shipment.Id);
        }

        private DroneInfo GetNearestDrone(ShipmentInfo shipment) {
            _logger.Log("Getting the nearest drone");
            var drones = GetAvailableDrones(shipment.Weight);
            if (!drones.Any()) {
                _logger.Log("No drone is available that can handle shipment's weight ({0})", shipment.Weight);
                return null;
            }
            double shortestDistance = double.MaxValue;
            DroneInfo candidDrone = null;
            foreach (var drone in drones) {
                double distance = _addressBll.GetDistanceKm(
                    (double) shipment.SourceAddress.Latitude, (double) shipment.SourceAddress.Longitude, 
                    (double) drone.Latitude, (double) drone.Longitude);
                _logger.Log("Drone {0} distance: {1}km", drone.Name, distance);
                if (distance < shortestDistance) {
                    _logger.Log("Drone {0} is a candidate", drone.Name);
                    shortestDistance = distance;
                    candidDrone = drone;
                }
            }
            _logger.Log("Drone {0} is the best choice", candidDrone.Name);
            return candidDrone;
        }

        private List<DroneInfo> GetAvailableDrones(decimal shipmentWeight) {
            var drones = _droneBll.GetDrones();
            var availableDrones = drones.Where(d => _availableDroneStatus.Contains(d.Status) && d.MaxWeight >= shipmentWeight).ToList();
            return availableDrones;
        }

        private List<DroneInfo> GetAvailableDrones() {
            var drones = _droneBll.GetDrones();
            var availableDrones = drones.Where(d => _availableDroneStatus.Contains(d.Status)).ToList();
            return availableDrones;
        }
        
    }

}
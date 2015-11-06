using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using DroneShipper.BusinessFacade;

namespace DroneShipper.BusinessLogic
{
    public class DroneAPI
    {
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

            ShipmentBLL shipBLL = new ShipmentBLL();
            DroneBLL droneBLL = new DroneBLL();

            // Start
            ShipmentInfo shipment = shipBLL.GetShipment(shipmentId);
            shipment.Status = ShipmentStatus.InTransit;
            shipment.DroneId = droneId;
            shipBLL.UpdateShipment(shipment);

            DroneInfo drone = droneBLL.GetDrone(droneId);
            drone.Status = DroneStatus.PickingUpShipment;
            droneBLL.UpdateDrone(drone);

            // Go pick up shipment


            // Deliver shipment


            // Shipment delivered
            shipment.Status = ShipmentStatus.Shipped;
            shipBLL.UpdateShipment(shipment);

            // Returning home

            // End 

        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using DroneShipper.BusinessFacade;
using DroneShipper.DataAccess;

namespace DroneShipper.BusinessLogic
{
    public class ShipmentBLL
    {
        private ShipmentDAL shipmentDAL = null;
        private AddressDAL addressDAL = null;

        public ShipmentBLL() {
            shipmentDAL = new ShipmentDAL();
            addressDAL = new AddressDAL();
        }

        public ShipmentInfo GetShipment(int shipmentId) {

            ShipmentInfo shipment = shipmentDAL.GetShipment(shipmentId);
            shipment.SourceAddress = addressDAL.GetAddress(shipment.SourceAddress.Id);
            shipment.DestinationAddress = addressDAL.GetAddress(shipment.DestinationAddress.Id);

            return shipment;
        }

        public void UpdateShipment(ShipmentInfo shipment) {

            shipmentDAL.UpdateShipment(shipment);
            addressDAL.UpdateAddress(shipment.SourceAddress);
            addressDAL.UpdateAddress(shipment.DestinationAddress);
        }

        public int AddShipment(ShipmentInfo shipment) {
            shipment.SourceAddress.Id = addressDAL.AddAddress(shipment.SourceAddress);
            shipment.DestinationAddress.Id = addressDAL.AddAddress(shipment.DestinationAddress);
            shipment.Id = shipmentDAL.AddShipment(shipment);

            return shipment.Id;
        }

        public List<ShipmentInfo> GetShipments(List<ShipmentStatus> statuses) {
            return shipmentDAL.GetShipments(statuses);
        }
    }
}

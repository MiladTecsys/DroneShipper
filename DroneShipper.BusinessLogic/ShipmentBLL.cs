using System.Collections.Generic;
using DroneShipper.BusinessFacade;
using DroneShipper.DataAccess;

namespace DroneShipper.BusinessLogic
{
    public class ShipmentBLL
    {
        private ShipmentDAL _shipmentDal = null;
        private AddressBLL _addressBll = null;

        public ShipmentBLL() {
            _shipmentDal = new ShipmentDAL();
            _addressBll = new AddressBLL();
        }

        public ShipmentInfo GetShipment(int shipmentId) {

            ShipmentInfo shipment = _shipmentDal.GetShipment(shipmentId);
            shipment.SourceAddress = _addressBll.GetAddress(shipment.SourceAddress.Id);
            shipment.DestinationAddress = _addressBll.GetAddress(shipment.DestinationAddress.Id);

            return shipment;
        }

        public void UpdateShipment(ShipmentInfo shipment) {

            _shipmentDal.UpdateShipment(shipment);
            _addressBll.UpdateAddress(shipment.SourceAddress);
            _addressBll.UpdateAddress(shipment.DestinationAddress);
        }

        public int AddShipment(ShipmentInfo shipment) {
            shipment.SourceAddress.Id = _addressBll.AddAddress(shipment.SourceAddress);
            shipment.DestinationAddress.Id = _addressBll.AddAddress(shipment.DestinationAddress);
            shipment.Id = _shipmentDal.AddShipment(shipment);

            return shipment.Id;
        }

        public List<ShipmentInfo> GetShipments(List<ShipmentStatus> statuses) {
            return _shipmentDal.GetShipments(statuses);
        }

        public void AssignDroneToShipment(int droneId, int shipmentId) {



        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


using DroneShipper.BusinessFacade;
using DroneShipper.BusinessLogic;


namespace DroneShipper.TestApp
{
    class Program
    {
        static void Main(string[] args) {

            ShipmentBLL shipBll = new ShipmentBLL();
            DroneBLL droneBll = new DroneBLL();

            ShipmentInfo shipment = new ShipmentInfo();
            shipment.DestinationAddress = new AddressInfo();
            shipment.DestinationAddress.Address1 = "70 East Beaver Creek Road";
            shipment.DestinationAddress.City = "Richmond Hill";
            shipment.DestinationAddress.Country = "Canada";
            shipment.DestinationAddress.State = "Ontario";
            shipment.DestinationAddress.ZipCode = "L4B 3B2";
            shipment.DestinationAddress.Latitude = 43.85657M;
            shipment.DestinationAddress.Longitude = -79.37895M;
            shipment.Weight = 1M;
            shipment.Status = ShipmentStatus.AwaitingShipment;
            shipment.SourceAddress = new AddressInfo();
            shipment.SourceAddress.Address1 = "8725 Yonge St";
            shipment.SourceAddress.City = "Richmond Hill";
            shipment.SourceAddress.Country = "Canada";
            shipment.SourceAddress.State = "Ontario";
            shipment.SourceAddress.ZipCode = "L4C 6Z1";
            shipment.SourceAddress.Latitude = 43.84292M;
            shipment.SourceAddress.Longitude = -79.43053M;
            shipBll.AddShipment(shipment);

            DroneInfo drone = new DroneInfo();
            drone.Latitude = 43.86071M;
            drone.Longitude = -79.37736M;
            drone.MaxWeight = 1000M;
            drone.Name = "DRONE 001";
            drone.Status = DroneStatus.Available;
            droneBll.AddDrone(drone);

            shipBll.AssignDroneToShipment(drone.Id, shipment.Id);

        }
    }
}

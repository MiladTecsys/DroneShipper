using System.Collections.Generic;
using System.Web.Mvc;
using DroneShipper.BusinessFacade;
using DroneShipper.BusinessLogic;

namespace DroneShipper.Web.Controllers {

    public class ShipmentsController : Controller {
        // GET: Shipments

        public ActionResult Index() {
            var bll = new ShipmentBLL();
            var model = bll.GetShipments(new List<ShipmentStatus> {ShipmentStatus.AwaitingShipment, ShipmentStatus.InTransit});
            return View(model);
        }

        [HttpGet]
        public ActionResult AddShipment() {
            return View();
        }

        [HttpPost]
        public ActionResult AddShipment(
              string sourceAdddress, string sourceCity, string sourcePostalCode
            , string destinationAddress, string destinationCity, string destinationPostalCode
            , decimal weight) {

            var shipment = new ShipmentInfo {
                SourceAddress = new AddressInfo{Address1 = sourceAdddress, City = sourceCity, ZipCode = sourcePostalCode},
                DestinationAddress = new AddressInfo{Address1 = destinationAddress, City = destinationCity, ZipCode = destinationPostalCode},
                Weight = weight
            };
            
            var bll = new ShipmentBLL();

            bll.AddShipment(shipment);

            return RedirectToAction("Index");

        }

    }

}
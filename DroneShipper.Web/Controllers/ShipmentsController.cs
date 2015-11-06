using System;
using System.Collections.Generic;
using System.Web.Mvc;
using DroneShipper.BusinessFacade;
using DroneShipper.BusinessLogic;

namespace DroneShipper.Web.Controllers {

    public class ShipmentsController : Controller {
        // GET: Shipments

        public ActionResult Index() {
            var bll = new ShipmentBLL();
            var model = bll.GetShipments(new List<ShipmentStatus> {ShipmentStatus.AwaitingShipment, ShipmentStatus.InTransit, ShipmentStatus.Shipped});
            return View(model);
        }

        [HttpGet]
        public ActionResult AddShipment() {

            if (!string.IsNullOrEmpty(Request.QueryString["shipmentId"])) {
                int shipmentId = Convert.ToInt32(Request.QueryString["shipmentId"]);

                var logBll = new DroneShipmentActivityLogBLL();
                ViewBag.Logs = logBll.GetActivityByShipment(shipmentId);
            }

            return View();
        }


        [HttpPost]
        public ActionResult AddShipment(
              string sourceAddress, string sourceCity, string sourcePostalCode
            , string destinationAddress, string destinationCity, string destinationPostalCode
            , decimal weight) {

            var shipment = new ShipmentInfo {
                SourceAddress = new AddressInfo{Address1 = sourceAddress, City = sourceCity, ZipCode = sourcePostalCode},
                DestinationAddress = new AddressInfo{Address1 = destinationAddress, City = destinationCity, ZipCode = destinationPostalCode},
                Weight = weight
            };
            
            var bll = new ShipmentBLL();

            bll.AddShipment(shipment);

            return RedirectToAction("Index");

        }

    }

}
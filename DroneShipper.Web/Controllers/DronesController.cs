using System.Web.Mvc;
using DroneShipper.BusinessFacade;
using DroneShipper.BusinessLogic;

namespace DroneShipper.Web.Controllers {
    
    public class DronesController : Controller {
        
        public ActionResult Index() {
            var bll = new DroneBLL();
            var drones = bll.GetDrones();
            return View(drones);
        }

        public ActionResult AddDrone() {
            return View();
        }

        [HttpPost]
        public ActionResult AddDrone(string name, decimal maxWeight, string postalCode) {
            var addressBll = new AddressBLL();
            var postalCodeInfo = addressBll.GeoCodePostalCode(postalCode);
            var bll = new DroneBLL();
            var drone = new DroneInfo {
                Name =  name,
                MaxWeight = maxWeight,
                Status = DroneStatus.Available,
                Latitude = postalCodeInfo.Latitude,
                Longitude = postalCodeInfo.Longitude
            };
            bll.AddDrone(drone);
            return RedirectToAction("Index");
        }

    }

}
using System.Web.Mvc;
using DroneShipper.BusinessFacade;
using DroneShipper.BusinessLogic;

namespace DroneShipper.Web.Controllers {
    
    public class DronesController : Controller {

        private readonly DroneBLL _droneBll;
        private readonly BaseBLL _baseBll;

        public DronesController() {
            _droneBll = new DroneBLL();
            _baseBll = new BaseBLL();
        }

        public ActionResult Index() {
            var drones = _droneBll.GetDrones();
            return View(drones);
        }

        public ActionResult AddDrone() {
            var bases = _baseBll.GetAll();
            return View(bases);
        }

        [HttpPost]
        public ActionResult AddDrone(string name, decimal maxWeight, int baseId) {
            var addressBll = new AddressBLL();
            var baseInfo = _baseBll.Get(baseId);
            var postalCodeInfo = addressBll.GeoCodePostalCode(baseInfo.Address.ZipCode);
            var drone = new DroneInfo {
                Name =  name,
                MaxWeight = maxWeight,
                Status = DroneStatus.Available,
                Latitude = postalCodeInfo.Latitude,
                Longitude = postalCodeInfo.Longitude
            };
            _droneBll.AddDrone(drone);
            return RedirectToAction("Index");
        }

    }

}
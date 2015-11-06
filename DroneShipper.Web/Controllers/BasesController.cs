using System.Web.Mvc;
using DroneShipper.BusinessFacade;
using DroneShipper.BusinessLogic;

namespace DroneShipper.Web.Controllers {

    public class BasesController : Controller {

        private readonly BaseBLL _baseBll;

        public BasesController() {
            _baseBll = new BaseBLL();
        }

        public ActionResult Index() {
            var bases = _baseBll.GetAll();
            return View(bases);
        }

        public ActionResult AddBase() {
            return View();
        }

        [HttpPost]
        public ActionResult AddBase(string name, string address, string city, string postalCode) {
            var baseInfo = new BaseInfo {
                Name = name,
                Address = new AddressInfo {
                    Address1 = address,
                    City = city,
                    ZipCode = postalCode
                }
            };
            _baseBll.Add(baseInfo);
            return RedirectToAction("Index");
        }

    }

}
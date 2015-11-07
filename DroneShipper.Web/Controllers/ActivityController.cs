using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using DroneShipper.BusinessFacade;
using DroneShipper.BusinessLogic;

namespace DroneShipper.Web.Controllers
{
    public class ActivityController : Controller
    {
        private DroneBLL droneBll;
        private BaseBLL baseBll;

        public ActivityController() {
            droneBll = new DroneBLL();
            baseBll = new BaseBLL();
        }

        // GET: Activity
        public ActionResult Index()
        {

            List<string> markers = new List<string>();

            List<DroneInfo> drones = droneBll.GetDrones();


            foreach (DroneInfo drone in drones) {
                markers.Add(string.Format("{{ name: '{0}', latitude: {1}, longitude: {2}, label: '{3}', icon: '{4}'}}", drone.Name, drone.Latitude, drone.Longitude, string.Empty, "content/MapIconPlane.png"));
            }

            var bases = baseBll.GetAll();
            foreach (var baseInfo in bases)             {
                markers.Add(string.Format("{{ name: '{0}', latitude: {1}, longitude: {2}, label: '{3}', icon: '{4}'}}", string.Empty, baseInfo.Address.Latitude, baseInfo.Address.Longitude, baseInfo.Name, "content/MapIconHome.png"));
            }

            var model = string.Join(",", markers.ToArray());

            return View((object)model);
        }
    }
}
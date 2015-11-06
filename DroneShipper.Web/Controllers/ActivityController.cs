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

        public ActivityController() {
            droneBll = new DroneBLL();
        }

        // GET: Activity
        public ActionResult Index()
        {
            List<DroneInfo> drones = droneBll.GetDrones();

            List<string> droneStrings = new List<string>();

            foreach (DroneInfo drone in drones) {
                droneStrings.Add(string.Format("{{ name: '{0}', latitude: {1}, longitude: {2}}}", drone.Name, drone.Latitude, drone.Longitude));
            }

            ViewBag.DroneArray = string.Join(",", droneStrings.ToArray());

            return View();
        }
    }
}
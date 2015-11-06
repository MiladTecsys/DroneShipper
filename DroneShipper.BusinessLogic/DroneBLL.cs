using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using DroneShipper.BusinessFacade;
using DroneShipper.DataAccess;

namespace DroneShipper.BusinessLogic
{
    public class DroneBLL
    {
        private DroneDAL dal = null;

        public DroneBLL() {
            dal = new DroneDAL();
        }

        public DroneInfo GetDrone(int droneId) {
            if (droneId <= 0)
                throw new ArgumentOutOfRangeException("droneId", droneId, "droneId must be a positive integer");

            return dal.GetDrone(droneId);
        }

        public List<DroneInfo> GetDrones() {
            return dal.GetDrones();
        }

        public int AddDrone(DroneInfo drone) {
            // Validate input
            if (drone == null) {
                throw new ArgumentNullException("drone");
            }

            return dal.AddDrone(drone);
        }

        public void UpdateDrone(DroneInfo drone) {
            dal.UpdateDrone(drone);
        }
    }
}

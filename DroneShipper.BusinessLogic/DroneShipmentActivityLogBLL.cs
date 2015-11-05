using DroneShipper.BusinessFacade;
using DroneShipper.DataAccess;

namespace DroneShipper.BusinessLogic
{
    public class DroneShipmentActivityLogBLL {

        private readonly DroneShipmentActivityLogDAL _dal;

        public DroneShipmentActivityLogBLL() {
            _dal = new DroneShipmentActivityLogDAL();
        }

        public int AddDroneShipmentActivityLog(DroneShipmentActivityLogInfo log) {
            return _dal.AddActivity(log);
        }

    }
}

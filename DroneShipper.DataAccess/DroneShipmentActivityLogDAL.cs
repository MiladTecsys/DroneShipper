using System;
using System.Collections.Generic;
using System.Data.SqlClient;


using DroneShipper.BusinessFacade;

using Microsoft.ApplicationBlocks.Data;

namespace DroneShipper.DataAccess
{
    public class DroneShipmentActivityLogDAL : DALBase {

        private const string INSERT_LOG = "[InsertDroneShipmentActivityLog]";
        private const string GET_LOGS_BY_SHIPMENT = "[GetActivityLogsByShipment]";

        public int AddActivity(DroneShipmentActivityLogInfo log)
        {
            int id = 0;

            using (SqlDataReader rdr = SqlHelper.ExecuteReader(_connString, INSERT_LOG,
                log.DroneId, log.ShipmentId, log.Message))
            {
                if (rdr.Read())
                    id = Convert.ToInt32(rdr.GetDecimal(0));
            }

            log.Id = id;

            return id;
        }

        public List<DroneShipmentActivityLogInfo> GetActivityByShipment(int shipmentId) {

            List<DroneShipmentActivityLogInfo> retVal = new List<DroneShipmentActivityLogInfo>();

            using (SqlDataReader rdr = SqlHelper.ExecuteReader(_connString, GET_LOGS_BY_SHIPMENT, shipmentId)){
                while (rdr.Read()) {
                    DroneShipmentActivityLogInfo log = FillFromReader(rdr);
                    retVal.Add(log);
                }
            }

            return retVal;
        }

        private DroneShipmentActivityLogInfo FillFromReader(SqlDataReader rdr) {

            DroneShipmentActivityLogInfo retVal = new DroneShipmentActivityLogInfo();

            retVal.DateTimeUtc = (DateTime)rdr["DateTimeUTC"];
            retVal.DroneId = (int)rdr["DroneId"];
            retVal.Id = (int)rdr["Id"];
            retVal.Message = (string)rdr["Message"];
            retVal.ShipmentId = (int)rdr["ShipmentId"];

            return retVal;
        }

    }
}

using System;
using System.Data.SqlClient;
using DroneShipper.BusinessFacade;
using Microsoft.ApplicationBlocks.Data;

namespace DroneShipper.DataAccess
{
    public class DroneShipmentActivityLogDAL : DALBase {

        private const string INSERT_LOG = "[InsertDroneShipmentActivityLog]";

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

    }
}

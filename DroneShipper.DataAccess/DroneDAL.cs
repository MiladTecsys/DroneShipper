using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

using DroneShipper.BusinessFacade;

using Microsoft.ApplicationBlocks.Data;

namespace DroneShipper.DataAccess
{
    public class DroneDAL : DALBase
    {
        private const string GET_DRONE = "GetDrone";
        private const string GET_DRONES = "GetDrones";
        private const string ADD_DRONE = "AddDrone";
        private const string UPDATE_DRONE = "UpdateDrone";

        public DroneInfo GetDrone(int droneId) {
            DroneInfo drone = null;

            using (SqlDataReader rdr = SqlHelper.ExecuteReader(_connString, GET_DRONE, droneId)) {
                if (rdr.Read()) {
                    drone = FillFromReader(rdr);
                }
            }

            return drone;
        }

        public List<DroneInfo> GetDrones() {

            List<DroneInfo> retVal = new List<DroneInfo>();

            using (SqlDataReader rdr = SqlHelper.ExecuteReader(_connString, GET_DRONES)) {
                while (rdr.Read()) {
                    DroneInfo drone = FillFromReader(rdr);
                    retVal.Add(drone);
                }
            }

            return retVal;
        }

        public int AddDrone(DroneInfo drone){
          
            int id = 0;

            using (SqlDataReader rdr = SqlHelper.ExecuteReader(_connString, ADD_DRONE,
                drone.Name, drone.Status, drone.Longitude, drone.Latitude, drone.MaxWeight)) {
                if (rdr.Read())
                    id = Convert.ToInt32(rdr.GetDecimal(0));
            }

            drone.Id = id;

            return id;
        }

        public void UpdateDrone(DroneInfo drone) {
            SqlHelper.ExecuteNonQuery(_connString, UPDATE_DRONE, drone.Id, 
     drone.Name, drone.Status, drone.Longitude, drone.Latitude, drone.MaxWeight);
        }


        private DroneInfo FillFromReader(SqlDataReader rdr) {
            DroneInfo drone = new DroneInfo();

            drone.Id = (int)rdr["Id"];
            
            if (rdr["Name"] != DBNull.Value){
                drone.Name = (string)rdr["Name"];
            }

            if (rdr["Status"] != DBNull.Value) {
                drone.Status = (DroneStatus)rdr["Status"];
            }

            if (rdr["MaxWeight"] != DBNull.Value) {
                drone.MaxWeight = (decimal)rdr["MaxWeight"];
            }

            drone.Longitude = (decimal)rdr["Longitude"];
            drone.Latitude = (decimal)rdr["Latitude"];
            

            return drone;
        }
    }
}

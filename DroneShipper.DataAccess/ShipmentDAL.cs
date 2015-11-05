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
    public class ShipmentDAL : DALBase
    {
        private const string GET_SHIPMENT = "GetShipment";
        private const string GET_SHIPMENTS = "GetShipments";
        private const string UPDATE_SHIPMENT = "UpdateShipment";
        private const string INSERT_SHIPMENT = "InsertShipment";

        public ShipmentDAL() {
        }

        public ShipmentInfo GetShipment(int shipmentId) {

            ShipmentInfo shipment = null;

            using (SqlDataReader rdr = SqlHelper.ExecuteReader(_connString, GET_SHIPMENT, shipmentId)) {
                if (rdr.Read()) {
                    shipment = FillFromReader(rdr);
                }
            }

            return shipment;
        }

        public List<ShipmentInfo> GetShipments(List<ShipmentStatus> statuses) {
            var result = new List<ShipmentInfo>();
            string statusList = string.Join(",", statuses.Cast<int>());
            using (SqlDataReader rdr = SqlHelper.ExecuteReader(_connString, GET_SHIPMENTS, statusList)) {
                while (rdr.Read()) {
                    var shipment = FillFromReader(rdr);
                    result.Add(shipment);
                }
            }
            return result;
        }

        public int AddShipment(ShipmentInfo shipment) {
            int id = 0;

            using (SqlDataReader rdr = SqlHelper.ExecuteReader(_connString, INSERT_SHIPMENT,
                shipment.SourceAddress.Id, shipment.DestinationAddress.Id, shipment.Weight, shipment.Status)) {
                if (rdr.Read())
                    id = Convert.ToInt32(rdr.GetDecimal(0));
            }

            shipment.Id = id;

            return id;
        }

        public void UpdateShipment(ShipmentInfo shipment) {

            SqlHelper.ExecuteNonQuery(_connString, UPDATE_SHIPMENT, shipment.Id,
                shipment.SourceAddress.Id, shipment.DestinationAddress.Id, shipment.Weight, shipment.Status, shipment.DroneId);
        }

        private ShipmentInfo FillFromReader(SqlDataReader rdr) {
            ShipmentInfo shipment = new ShipmentInfo();

            shipment.Id = (int)rdr["Id"];

            if (rdr["Status"] != DBNull.Value) {
                shipment.Status = (ShipmentStatus)((int)rdr["Status"]);
            }

            if (rdr["Weight"] != DBNull.Value) {
                shipment.Weight = (decimal)rdr["Weight"];
            }

            int destinationAddressId = (int)rdr["DestinationAddressId"];
            shipment.DestinationAddress = new AddressInfo();
            shipment.DestinationAddress.Id = destinationAddressId;

            int sourceAddressId = (int)rdr["SourceAddressId"];
            shipment.SourceAddress = new AddressInfo();
            shipment.SourceAddress.Id = sourceAddressId;

            if (rdr["DroneId"] != DBNull.Value) {
                shipment.DroneId = (int) rdr["DroneId"];
            }

            return shipment;
        }

    }
}

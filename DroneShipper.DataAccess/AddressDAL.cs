using System;
using System.Data.SqlClient;
using DroneShipper.BusinessFacade;

using Microsoft.ApplicationBlocks.Data;

namespace DroneShipper.DataAccess
{
    public class AddressDAL : DALBase
    {
        private const string GET_ADDRESS = "GetAddress";
        private const string ADD_ADDRESS = "InsertAddress";
        private const string UPDATE_ADDRESS = "UpdateAddress";
        private const string GET_POSTALCODE = "GetPostalCode";

        public AddressInfo GetAddress(int addressId) {
            AddressInfo address = null;

            using (SqlDataReader rdr = SqlHelper.ExecuteReader(_connString, GET_ADDRESS, addressId)) {
                if (rdr.Read()) {
                    address = FillFromReader(rdr);
                }
            }

            return address;
        }

        public void UpdateAddress(AddressInfo address) {
            SqlHelper.ExecuteNonQuery(_connString, UPDATE_ADDRESS, address.Id,
                address.Address1, address.Address2, address.Address3,
                address.City, address.State, address.Country, address.ZipCode, address.Longitude, address.Latitude);
        }

        public virtual int AddAddress(AddressInfo address) {
            int id = 0;

            using (SqlDataReader rdr = SqlHelper.ExecuteReader(_connString, ADD_ADDRESS,
                address.Address1, address.Address2, address.Address3,
                address.City, address.State, address.Country, address.ZipCode, address.Longitude, address.Latitude)) {
                if (rdr.Read())
                    id = Convert.ToInt32(rdr.GetDecimal(0));
            }

            address.Id = id;

            return id;
        }

        public PostalCodeInfo GeocodePostalCode(string postalCode) {
            PostalCodeInfo result = null;
            using (SqlDataReader rdr = SqlHelper.ExecuteReader(_connString, GET_POSTALCODE, postalCode)) {
                if (rdr.Read()) {
                    result = FillPostalCodeFromReader(rdr);
                }
            }
            return result;
        }

        private AddressInfo FillFromReader(SqlDataReader rdr) {
            var address = new AddressInfo();

            address.Id = (int)rdr["Id"];
            if (rdr["AddressLine1"] != DBNull.Value) {
                address.Address1 = (string)rdr["AddressLine1"];
            }
            if (rdr["AddressLine2"] != DBNull.Value) {
                address.Address2 = (string)rdr["AddressLine2"];
            }
            if (rdr["AddressLine3"] != DBNull.Value) {
                address.Address3 = (string)rdr["AddressLine3"];
            }
            if (rdr["City"] != DBNull.Value) {
                address.City = (string)rdr["City"];
            }

             if (rdr["ProvinceState"] != DBNull.Value) {
                address.State = (string)rdr["ProvinceState"];
             }
                     
            if (rdr["Country"] != DBNull.Value) {
             address.Country = (string)rdr["Country"];
            }

            if (rdr["PostalZipCode"] != DBNull.Value) {
                address.ZipCode = (string)rdr["PostalZipCode"];
            }
            address.Longitude = (decimal)rdr["Longitude"];
            address.Latitude = (decimal)rdr["Latitude"];

            return address;
        }

        private PostalCodeInfo FillPostalCodeFromReader(SqlDataReader rdr) {
            var postalCode = new PostalCodeInfo {
                Latitude = (decimal)rdr["Latitude"],
                Longitude = (decimal)rdr["Longitude"],
                PostalCode = (string)rdr["PostalCode"]
            };
            return postalCode;
        }

    }
}

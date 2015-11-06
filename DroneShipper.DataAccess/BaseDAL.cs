using System.Collections.Generic;
using System.Data.SqlClient;
using DroneShipper.BusinessFacade;
using Microsoft.ApplicationBlocks.Data;

namespace DroneShipper.DataAccess {

    public class BaseDAL : DALBase {

        private const string GET = "GetBase";
        private const string GET_ALL = "GetBases";
        private const string ADD = "InsertBase";

        public BaseInfo Get(int id) {
            BaseInfo result = null;
            using (SqlDataReader rdr = SqlHelper.ExecuteReader(_connString, GET, id)) {
                if (rdr.Read()) {
                    result = FillFromReader(rdr);
                }
            }
            return result;
        }

        public List<BaseInfo> GetAll() {
            var result = new List<BaseInfo>();
            using (SqlDataReader rdr = SqlHelper.ExecuteReader(_connString, GET_ALL)) {
                while (rdr.Read()) {
                    var baseInfo = FillFromReader(rdr);
                    result.Add(baseInfo);
                }
            }
            return result;
        }

        public int Add(BaseInfo baseInfo) {
            int id = 0;
            using (SqlDataReader rdr = SqlHelper.ExecuteReader(_connString, ADD, baseInfo.Name, baseInfo.Address.Id)) {
                if (rdr.Read()) {
                    id = (int) rdr.GetDecimal(0);
                }
            }
            baseInfo.Id = id;
            return id;
        }

        private BaseInfo FillFromReader(SqlDataReader rdr) {
            var addressDal = new AddressDAL();
            var result = new BaseInfo {
                Id = (int) rdr["Id"],
                Name = (string) rdr["Name"],
                Address = addressDal.GetAddress((int) rdr["AddressId"])
            };
            return result;
        }

    }

}
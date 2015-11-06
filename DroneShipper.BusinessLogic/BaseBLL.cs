using System.Collections.Generic;
using DroneShipper.BusinessFacade;
using DroneShipper.DataAccess;

namespace DroneShipper.BusinessLogic {
    public class BaseBLL {
        
        private readonly BaseDAL _baseDal;
        private readonly AddressDAL _addressDal;

        public BaseBLL() {
            _baseDal = new BaseDAL();
            _addressDal = new AddressDAL();
        }

        public BaseInfo Get(int id) {
            var result = _baseDal.Get(id);
            return result;
        }

        public List<BaseInfo> GetAll() {
            var result = _baseDal.GetAll();
            return result;
        }

        public int Add(BaseInfo baseInfo) {
            _addressDal.AddAddress(baseInfo.Address);
            var id = _baseDal.Add(baseInfo);
            return id;
        }

    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using DroneShipper.BusinessFacade;
using DroneShipper.DataAccess;

namespace DroneShipper.BusinessLogic
{
    public class AddressBLL
    {
        private AddressDAL ad = null;

        public AddressBLL() {
            ad = new AddressDAL();
        }

        public virtual AddressInfo GetAddress(int addressId) {
            // Validate
            if (addressId <= 0)
                throw new ArgumentOutOfRangeException("addressId", addressId, "addressId must be a positive integer");

            return ad.GetAddress(addressId);
        }

        public int AddAddress(AddressInfo address) {
            // Validate input
            if (address == null) {
                throw new ArgumentNullException("address");
            }

            return ad.AddAddress(address);
        }
    }
}

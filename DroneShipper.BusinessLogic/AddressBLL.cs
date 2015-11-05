using System;
using System.Text.RegularExpressions;
using DroneShipper.BusinessFacade;
using DroneShipper.DataAccess;

namespace DroneShipper.BusinessLogic
{
    public class AddressBLL
    {
        private readonly AddressDAL _addressDal = null;

        public AddressBLL() {
            _addressDal = new AddressDAL();
        }

        public virtual AddressInfo GetAddress(int addressId) {
            // Validate
            if (addressId <= 0)
                throw new ArgumentOutOfRangeException("addressId", addressId, "addressId must be a positive integer");

            var address = _addressDal.GetAddress(addressId);
            return address;
        }

        public int AddAddress(AddressInfo address) {
            // Validate input
            if (address == null) {
                throw new ArgumentNullException("address");
            }

            var postalCode = GeoCodePostalCode(address.ZipCode);
            address.Latitude = postalCode.Latitude;
            address.Longitude = postalCode.Longitude;

            var id = _addressDal.AddAddress(address);
            return id;
        }

        public PostalCodeInfo GeoCodePostalCode(string postalCode) {
            var sanitizedPostalCode = Regex.Replace(postalCode, @"\s+", "");
            var result = _addressDal.GeocodePostalCode(sanitizedPostalCode);
            return result;
        }

        public void UpdateAddress(AddressInfo address) {
            _addressDal.UpdateAddress(address);
        }

    }

}

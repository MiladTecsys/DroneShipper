using System;
using System.Text.RegularExpressions;
using DroneShipper.BusinessFacade;
using DroneShipper.DataAccess;

namespace DroneShipper.BusinessLogic {
    public class AddressBLL {

        private const double EARTH_RADIUS_KM = 6371;

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


        public static double GetDistanceKm(double fromLat, double fromLong, double toLat, double toLong) {
            double dLat = ToRad(toLat - fromLat);
            double dLon = ToRad(toLong - fromLong);

            double a = Math.Pow(Math.Sin(dLat/2), 2) +
                       Math.Cos(ToRad(fromLat))*Math.Cos(ToRad(toLat))*
                       Math.Pow(Math.Sin(dLon/2), 2);

            double c = 2*Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));

            double distance = EARTH_RADIUS_KM*c;
            return distance;
        }

        private static double ToRad(double input) {
            return input*(Math.PI/180);
        }

    }

}
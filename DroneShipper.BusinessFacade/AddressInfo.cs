using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DroneShipper.BusinessFacade
{
    public class AddressInfo
    {

        public int Id {
            get;
            set;
        }

        public decimal Longitude {
            get;
            set;
        }

        public decimal Latitude {
            get;
            set;
        }



        /// <summary>
        /// Gets or sets the address1.
        /// </summary>
        /// <value>The address1.</value>
        public string Address1 {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the address2.
        /// </summary>
        /// <value>The address2.</value>
        public string Address2 {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the address3.
        /// </summary>
        /// <value>The address3.</value>
        public string Address3 {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the city.
        /// </summary>
        /// <value>The city.</value>
        public string City {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the state.
        /// </summary>
        /// <value>The state.</value>
        public string State {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the country.
        /// </summary>
        /// <value>The country.</value>
        public string Country {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the ZIP code.
        /// </summary>
        /// <value>The ZIP code.</value>
        public string ZipCode {
            get;
            set;
        }



 

     
    }
}

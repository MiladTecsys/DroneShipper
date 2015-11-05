using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


using DroneShipper.BusinessFacade;
using DroneShipper.BusinessLogic;


namespace DroneShipper.TestApp
{
    class Program
    {
        static void Main(string[] args) {
            AddressBLL abll = new AddressBLL();
            AddressInfo address = abll.GetAddress(1);


        }
    }
}

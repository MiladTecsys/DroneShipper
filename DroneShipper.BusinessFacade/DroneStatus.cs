using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DroneShipper.BusinessFacade
{
    public enum DroneStatus
    {
        OutOfService,
        Available,
        PickingUpShipment,
        DeliveringShipment,
        ReturningToBase
    }
}

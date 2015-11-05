using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DroneShipper.DataAccess
{
    public abstract class DALBase
    {
        protected string _connString = "server=(local);database=DroneShipper;Integrated Security=SSPI;MultipleActiveResultSets=true;";
    }
}

namespace DroneShipper.BusinessFacade
{
    public class DroneInfo
    {
        public int Id {
            get;
            set;
        }
        
        public string Name {
           get;
           set;
        }

        public DroneStatus Status {
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

        public decimal MaxWeight {
            get;
            set;
        }
    }
}

package body CLContexts is
   function Default return Context is
		Platform : constant CL.Platforms.Platform :=
         CL.Platforms.List (1);

		Device : constant CL.Platforms.Device :=
			Platform.Devices (CL.Platforms.Device_Kind_All) (1);

		Device_List : constant CL.Platforms.Device_List := (1 => Device);

		Ctx : constant CL.Contexts.Context :=
			CL.Contexts.Constructors.Create_For_Devices (Platform, (1 => Device));

		Queue : constant CL.Command_Queues.Queue :=
			CL.Command_Queues.Constructors.Create
			  (Ctx, Device, CL.Platforms.CQ_Property_Vector'
           	  (Out_Of_Order_Exec_Mode_Enable => False,
			      Profiling_Enable => False));
   begin
      return (Platform, Device, Device_List, Ctx, Queue);
   end Default;
end CLContexts;

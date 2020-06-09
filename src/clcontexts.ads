with CL.Platforms;
with CL.Contexts;
with CL.Command_Queues;
with CL.Events;

package CLContexts is
   type Context is record
		Platform    : CL.Platforms.Platform;
		Device      : CL.Platforms.Device;
		Device_List : CL.Platforms.Device_List (1 .. 1);
		Context     : CL.Contexts.Context;
      Queue       : CL.Command_Queues.Queue;
   end record;

   function Default return Context;
end CLContexts;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Variable;

with CL.Programs;
with CL.Kernels;
with CL.Queueing;
with CL.Events;

package body Store_All is
   package Index is new Variable (Natural, "i");
   package In_Get is new Values.Get (Index.E);
   package Out_Set is new Mem.Set (Index.E, In_Get.E);

   function Generate_Dispatch_Code
     (Ctx : in out Codegen.Emit_Context) return Codegen.Code
   is
      Content : constant Codegen.Code := Out_Set.Generate_Code (Ctx);
   begin
      return "__kernel void main("
         & Codegen.Signature (Ctx) & ") { " & LF
         & "size_t i = get_global_id(0); " & LF
         & To_String (Codegen.Pop_Statements (Ctx))
         & Content & ";" & LF
         & "}";
   end Generate_Dispatch_Code;

   procedure Compute (Ctx : CLContexts.Context) is
      Len : constant CL.Size := CL.Size (Values.Length);

      Emit_Ctx : Codegen.Emit_Context;
      Program : constant CL.Programs.Program :=
         CL.Programs.Constructors.Create_From_Source
           (Ctx.Context, Generate_Dispatch_Code (Emit_Ctx));

      Kernel : CL.Kernels.Kernel;

      Event : CL.Events.Event;

      Global_Work_Size : aliased CL.Size_List := (1 => Len);
      Local_Work_Size  : aliased CL.Size_List := (1 => 1);
   begin
      Program.Build (Ctx.Device_List, "", null);

      Kernel := CL.Kernels.Constructors.Create (Program, "main");

      Codegen.Set_Kernel_Arguments (Emit_Ctx, Kernel);

      Event := CL.Queueing.Execute_Kernel
        (Ctx.Queue, Kernel, 1, Global_Work_Size'Access, Local_Work_Size'Access, null);

      Event.Wait_For;
   end Compute;
end Store_All;

with Variable;

with CL.Programs;
with CL.Kernels;
with CL.Queueing;
with CL.Events;

package body Map is
   package Index is new Variable (Natural, "i");
   package In_Get is new Ins.Get (Index.E);
   package Op_Call is new Op.Call (In_Get.E);

   --  function Generate_Code (Ctx : in out Codegen.Emit_Context) return Codegen.Code is
   --     Len : constant Natural := Ins.Length;
   --  begin
   --     return "for (int i = 0; i < " & Len'Image & "; ++i) { "
   --        &  Out_Set.Generate_Code (Ctx)
   --        & " ; }";
   --  end Generate_Code;

   package body Dispatch is
      package Out_Set is new Outs.Set (Index.E, Op_Call.E);

      function Generate_Code (Ctx : in out Codegen.Emit_Context) return Codegen.Code is
         Content : constant Codegen.Code := Out_Set.Generate_Code (Ctx);
      begin
         return "__kernel void main("
            &  Codegen.Signature (Ctx) & ") { "
            & "size_t i = get_global_id(0); "
            &  Content
            & "; }";
      end Generate_Code;

      procedure Compute (Ctx : CLContexts.Context) is
         Len : constant CL.Size := CL.Size (Ins.Length);

         Emit_Ctx : Codegen.Emit_Context;
         Program : constant CL.Programs.Program :=
            CL.Programs.Constructors.Create_From_Source
              (Ctx.Context, Generate_Code (Emit_Ctx));

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
   end Dispatch;

   function Generate_Indexable_Code
     (Index_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code
   is
      package Index is new Variable (Natural, Index_Code);
      package In_Get is new Ins.Get (Index.E);
      package Op_Call is new Op.Call (In_Get.E);
   begin
      return Op_Call.Generate_Code (Ctx);
   end Generate_Indexable_Code;
end Map;

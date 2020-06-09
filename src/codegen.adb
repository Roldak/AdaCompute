package body Codegen is
   procedure Append_CL_Object (Ctx : in out Emit_Context; Obj : CL_Object) is
   begin
      for X of Ctx.Kernel_Arguments loop
         if X.Object = Obj.Object then
            return;
         end if;
      end loop;

      CL_Object_Vectors.Append (Ctx.Kernel_Arguments, Obj);
   end Append_CL_Object;

   function Signature (Ctx : Emit_Context) return Code is
      function Create_Signature (N : Natural) return String is
         Ref  : constant CL_Object := Ctx.Kernel_Arguments (N);
         Self : constant Code := "__global int* " & Ref.Name.all;
      begin
         return Self;
      end Create_Signature;

      use type Ada.Containers.Count_Type;
   begin
      if Ctx.Kernel_Arguments.Length = 0 then
         return "";
      else
         return Create_Signature (0);
      end if;
   end Signature;

   procedure Set_Kernel_Arguments
     (Ctx : Emit_Context; K : CL.Kernels.Kernel)
   is
      use type CL.UInt;

      Arg_Index : CL.UInt := 0;
   begin
      for X of Ctx.Kernel_Arguments loop
         CL.Kernels.Set_Kernel_Argument_Object
           (K, Arg_Index, X.Object.all);

         Arg_Index := Arg_Index + 1;
      end loop;
   end Set_Kernel_Arguments;
end Codegen;

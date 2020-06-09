package body Arithmetic_Operator is
   function Generate_Code
     (Ctx : in out Codegen.Emit_Context) return Codegen.Code
   is
      pragma Unreferenced (Ctx);
   begin
      return Repr;
   end Generate_Code;
end Arithmetic_Operator;

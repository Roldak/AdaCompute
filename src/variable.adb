package body Variable is
   function Generate_Code (Ctx : in out Codegen.Emit_Context) return Codegen.Code is
      pragma Unreferenced (Ctx);
   begin
      return Name;
   end Generate_Code;
end Variable;

package body Index_Assignable is
   package body Set is
      function Generate_Code
        (Ctx : in out Codegen.Emit_Context) return Codegen.Code
      is
         Index_Code : constant Codegen.Code := Index.Generate_Code (Ctx);
         Value_Code : constant Codegen.Code := Value.Generate_Code (Ctx);
      begin
         return Emit (Index_Code, Value_Code, Ctx);
      end Generate_Code;
   end Set;
end Index_Assignable;

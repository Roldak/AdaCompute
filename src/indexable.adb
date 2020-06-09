package body Indexable is
   package body Get is
      function Generate_Code
        (Ctx : in out Codegen.Emit_Context) return Codegen.Code
      is
         Index_Code : constant Codegen.Code := Index.Generate_Code (Ctx);
      begin
         return Emit (Index_Code, Ctx);
      end Generate_Code;
   end Get;
end Indexable;

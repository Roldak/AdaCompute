package body Indexable_2 is
   package body Get is
      function Generate_Code
        (Ctx : in out Codegen.Emit_Context) return Codegen.Code
      is
         Index_1_Code : constant Codegen.Code := Index_1.Generate_Code (Ctx);
         Index_2_Code : constant Codegen.Code := Index_2.Generate_Code (Ctx);
      begin
         return Emit (Index_1_Code, Index_2_Code, Ctx);
      end Generate_Code;
   end Get;
end Indexable_2;

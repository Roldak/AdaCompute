package body Int_Range is
   function Generate_Indexable_Code
     (Index_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code
   is
      pragma Unreferenced (Ctx);
   begin
      return "(" & Index_Code & " + " & Lower_Bound'Image & ")";
   end Generate_Indexable_Code;
end Int_Range;

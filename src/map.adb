with Variable;

package body Map is
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

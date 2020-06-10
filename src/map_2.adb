with Variable;

package body Map_2 is
   function Generate_Indexable_Code
     (Index_1_Code : Codegen.Code;
      Index_2_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code
   is
      package Index_1 is new Variable (Natural, Index_1_Code);
      package Index_2 is new Variable (Natural, Index_2_Code);
      package In_1_Get is new Ins_1.Get (Index_1.E);
      package In_2_Get is new Ins_2.Get (Index_2.E);
      package Op_Call is new Op.Call (In_1_Get.E, In_2_Get.E);
   begin
      return Op_Call.Generate_Code (Ctx);
   end Generate_Indexable_Code;
end Map_2;

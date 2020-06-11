with Variable;

package body Zip is
   function Generate_Indexable_Code
     (Index_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code
   is
      package Index is new Variable (Natural, Index_Code);
      package Ins_1_Get is new Ins_1.Get (Index.E);
      package Ins_2_Get is new Ins_2.Get (Index.E);
      package Op_Call is new Op.Call (Ins_1_Get.E, Ins_2_Get.E);
   begin
      return Op_Call.Generate_Code (Ctx);
   end Generate_Indexable_Code;
end Zip;

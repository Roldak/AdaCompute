with Operation_2;
with Codegen;
with Indexable;
with Indexable_2;

generic
   with package Op is new Operation_2 (<>);
   with package Ins_1 is new Indexable (Op.Param_Type_1, <>, <>);
   with package Ins_2 is new Indexable (Op.Param_Type_2, <>, <>);
package Map_2 is
   function Generate_Indexable_Code
     (Index_1_Code : Codegen.Code;
      Index_2_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code;

   package I is new Indexable_2
     (Op.Result_Type, Ins_1.Length, Ins_2.Length, Generate_Indexable_Code);
end Map_2;

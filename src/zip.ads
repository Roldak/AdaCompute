with Indexable;
with Operation_2;
with Codegen;

generic
   with package Op is new Operation_2 (<>);
   with package Ins_1 is new Indexable (Op.Param_Type_1, <>, <>);
   with package Ins_2 is new Indexable (Op.Param_Type_2, Ins_1.Size, <>);
package Zip is
   function Generate_Indexable_Code
     (Index_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code;

   package I is new Indexable
     (Op.Result_Type, Ins_1.Size, Generate_Indexable_Code);
end Zip;

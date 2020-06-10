with Operation;
with Codegen;
with Indexable;

generic
   with package Op is new Operation (<>);
   with package Ins is new Indexable (Op.Param_Type, <>, <>);
package Map is
   function Generate_Indexable_Code
     (Index_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code;

   package I is new Indexable
     (Op.Result_Type, Ins.Length, Generate_Indexable_Code);
end Map;

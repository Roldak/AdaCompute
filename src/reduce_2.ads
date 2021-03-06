with Expr;
with Operation_2;
with Indexable;
with Indexable_2;
with Codegen;

generic
   with package Coll is new Indexable_2 (<>);
   with package Op is new Operation_2
     (Coll.Element_Type,
      Coll.Element_Type,
      Coll.Element_Type,
      <>);
package Reduce_2 is
   function Generate_Indexable_Code
     (Index_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code;

   package I is new Indexable
     (Op.Result_Type, Coll.Length_1, Generate_Indexable_Code);
end Reduce_2;

with Expr;
with Operation_2;
with Indexable;
with Indexable_2;
with Codegen;

generic
   with package Init is new Expr (<>);
   with package Op is new Operation_2
     (From_1 => Init.Expr_Type, To => Init.Expr_Type, others => <>);
   with package Coll is new Indexable_2 (Op.Param_Type_2, <>, <>, <>);
package Fold_2 is
   function Generate_Indexable_Code
     (Index_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code;

   package I is new Indexable
     (Init.Expr_Type, Coll.Length_1, Generate_Indexable_Code);
end Fold_2;

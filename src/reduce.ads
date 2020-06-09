with Expr;
with Operation_2;
with Indexable;
with Codegen;

generic
   with package Init is new Expr (<>);
   with package Op is new Operation_2
     (From_1 => Init.Expr_Type, To => Init.Expr_Type, others => <>);
   with package Coll is new Indexable (Op.Param_Type_2, <>, <>);
package Reduce is
   function Generate_Code
     (Ctx : in out Codegen.Emit_Context) return Codegen.Code;

   package E is new Expr (Init.Expr_Type, Generate_Code);
end Reduce;

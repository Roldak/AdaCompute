with Codegen;

generic
   type T is private;
   with function Emit (Ctx : in out Codegen.Emit_Context) return Codegen.Code;
package Expr is
   subtype Expr_Type is T;

   function Generate_Code (Ctx : in out Codegen.Emit_Context) return Codegen.Code is
      (Emit (Ctx));
end Expr;

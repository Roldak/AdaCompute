with Expr;
with Codegen;

generic
   type T is private;
   Name : String;
package Variable is
   function Generate_Code (Ctx : in out Codegen.Emit_Context) return Codegen.Code;

   package E is new Expr (T, Generate_Code);
end Variable;

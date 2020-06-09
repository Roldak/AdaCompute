with Expr;
with Codegen;

generic
   type From is private;
   type To is private;
   with function Emit
     (Arg : Codegen.Code; Ctx : in out Codegen.Emit_Context) return Codegen.Code;
package Operation is
   subtype Param_Type is From;
   subtype Result_Type is To;

   generic
      with package Arg is new Expr (Param_Type, <>);
   package Call is
      function Generate_Code (Ctx : in out Codegen.Emit_Context) return Codegen.Code;

      package E is new Expr (Result_Type, Generate_Code);
   end Call;
end Operation;

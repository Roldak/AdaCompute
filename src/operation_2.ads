with Expr;
with Codegen;

generic
   type From_1 is private;
   type From_2 is private;
   type To is private;
   with function Emit
     (Arg_1 : Codegen.Code;
      Arg_2 : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code;
package Operation_2 is
   subtype Param_Type_1 is From_1;
   subtype Param_Type_2 is From_2;
   subtype Result_Type is To;

   generic
      with package Arg_1 is new Expr (Param_Type_1, <>);
      with package Arg_2 is new Expr (Param_Type_2, <>);
   package Call is
      function Generate_Code (Ctx : in out Codegen.Emit_Context) return Codegen.Code;

      package E is new Expr (Result_Type, Generate_Code);
   end Call;
end Operation_2;

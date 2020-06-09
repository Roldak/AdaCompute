with Expr;
with Operation;
with Operation_2;
with Codegen;
with Arithmetic_Operator;

package BinOps is
   package Add is new Arithmetic_Operator ("+");
   package Multiply is new Arithmetic_Operator ("*");

   generic
      with package Operator is new Arithmetic_Operator (<>);
      type T is private;
   package Arithmetic_2 is
      function Generate_Code
        (Arg_1 : Codegen.Code;
         Arg_2 : Codegen.Code;
         Ctx   : in out Codegen.Emit_Context) return Codegen.Code;

      package Op is new Operation_2 (T, T, T, Generate_Code);
   end Arithmetic_2;

   generic
      with package Operator is new Arithmetic_Operator (<>);
      with package X is new Expr (<>);
   package Arithmetic_1 is
      function Generate_Code
        (Arg : Codegen.Code; Ctx : in out Codegen.Emit_Context) return Codegen.Code;

      package Op is new Operation
        (X.Expr_Type,
         X.Expr_Type,
         Generate_Code);
   end Arithmetic_1;

   generic
      with package Operator is new Arithmetic_Operator (<>);
      with package X is new Expr (<>);
      with package Y is new Expr (X.Expr_Type, <>);
   package Arithmetic is
      function Generate_Code
        (Ctx : in out Codegen.Emit_Context) return Codegen.Code;

      package E is new Expr (X.Expr_Type, Generate_Code);
   end Arithmetic;
end BinOps;

with Codegen;

generic
   Repr : Codegen.Code;
package Arithmetic_Operator is
   function Generate_Code
     (Ctx : in out Codegen.Emit_Context) return Codegen.Code;
end Arithmetic_Operator;

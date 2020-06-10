with Codegen;
with Expr;
with Operation_2;

generic
   type Result_Type is private;
   Size_1 : Natural;
   Size_2 : Natural;
   with function Emit
     (Index_1_Code : Codegen.Code;
      Index_2_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code;
package Indexable_2 is
   Length_1 : constant Natural := Size_1;
   Length_2 : constant Natural := Size_2;

   generic
      with package Index_1 is new Expr (Natural, <>);
      with package Index_2 is new Expr (Natural, <>);
   package Get is
      function Generate_Code
        (Ctx : in out Codegen.Emit_Context) return Codegen.Code;

      package E is new Expr (Result_Type, Generate_Code);
   end Get;

   package Op is new Operation_2 (Natural, Natural, Result_Type, Emit);
end Indexable_2;

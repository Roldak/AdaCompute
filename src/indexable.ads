with Codegen;
with Expr;
with Operation;

generic
   type Result_Type is private;
   Size : Natural;
   with function Emit
     (Index_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code;
package Indexable is
   function Length return Natural is (Size);

   generic
      with package Index is new Expr (Natural, <>);
   package Get is
      function Generate_Code
        (Ctx : in out Codegen.Emit_Context) return Codegen.Code;

      package E is new Expr (Result_Type, Generate_Code);
   end Get;

   package Op is new Operation (Natural, Result_Type, Emit);
end Indexable;

with Codegen;
with Expr;

generic
   type Value_Type is private;
   Size : Natural;
   with function Emit
     (Index_Code : Codegen.Code;
      Value_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code;
package Index_Assignable is
   generic
      with package Index is new Expr (Natural, <>);
      with package Value is new Expr (Value_Type, <>);
   package Set is
      function Generate_Code
        (Ctx : in out Codegen.Emit_Context) return Codegen.Code;
   end Set;
end Index_Assignable;

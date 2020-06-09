with Operation;
with Codegen;
with CLContexts;
with Indexable;
with Index_Assignable;

generic
   with package Op is new Operation (<>);
   with package Ins is new Indexable (Op.Param_Type, <>, <>);
package Map is
   --  function Generate_Code (Ctx : in out Codegen.Emit_Context) return Codegen.Code;

   generic
      with package Outs is new Index_Assignable
        (Op.Result_Type, Ins.Size, <>);
   package Dispatch is
      function Generate_Code
        (Ctx : in out Codegen.Emit_Context) return Codegen.Code;

      procedure Compute (Ctx : CLContexts.Context);
   end Dispatch;

   function Generate_Indexable_Code
     (Index_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code;

   package I is new Indexable
     (Op.Result_Type, Ins.Length, Generate_Indexable_Code);
end Map;

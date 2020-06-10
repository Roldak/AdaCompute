with Indexable;
with Index_Assignable;
with Codegen;
with CLContexts;

generic
   with package Values is new Indexable (<>);
   with package Mem is new Index_Assignable
     (Values.Result_Type, Values.Size, <>);
package Store_All is
   function Generate_Dispatch_Code
     (Ctx : in out Codegen.Emit_Context) return Codegen.Code;

   procedure Compute (Ctx : CLContexts.Context);
end Store_All;

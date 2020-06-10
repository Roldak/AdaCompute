with Operation;
with Operation_2;
with Codegen;

package Operations is
   generic
      with package First is new Operation_2 (<>);
      with package Second is new Operation (First.To, <>, <>);
   package Combine_2_1 is
      function Generate_Code
        (Arg_1 : Codegen.Code;
         Arg_2 : Codegen.Code;
         Ctx : in out Codegen.Emit_Context) return Codegen.Code;

      package Op is new Operation_2
        (First.Param_Type_1,
         First.Param_Type_2,
         Second.Result_Type,
         Generate_Code);
   end Combine_2_1;
end Operations;

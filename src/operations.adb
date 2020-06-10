package body Operations is
   package body Combine_2_1 is
      function Generate_Code
        (Arg_1 : Codegen.Code;
         Arg_2 : Codegen.Code;
         Ctx : in out Codegen.Emit_Context) return Codegen.Code
      is
      begin
         return Second.Emit (First.Emit (Arg_1, Arg_2, Ctx), Ctx);
      end Generate_Code;
   end Combine_2_1;
end Operations;

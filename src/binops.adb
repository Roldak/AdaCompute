package body BinOps is
   package body Arithmetic_2 is
      function Generate_Code
        (Arg_1 : Codegen.Code;
         Arg_2 : Codegen.Code;
         Ctx   : in out Codegen.Emit_Context) return Codegen.Code
      is
      begin
         return "(" & Arg_1 & ") "
            & Operator.Generate_Code (Ctx)
            & " (" & Arg_2 & ")";
      end Generate_Code;
   end Arithmetic_2;

   package body Arithmetic_1 is
      function Generate_Code
        (Arg : Codegen.Code;
         Ctx   : in out Codegen.Emit_Context) return Codegen.Code
      is
      begin
         return "(" & Arg & ") "
            & Operator.Generate_Code (Ctx)
            & " (" & X.Generate_Code (Ctx) & ")";
      end Generate_Code;
   end Arithmetic_1;

   package body Arithmetic is
      function Generate_Code
        (Ctx : in out Codegen.Emit_Context) return Codegen.Code
      is
      begin
         return "(" & X.Generate_Code (Ctx) & ") "
            & Operator.Generate_Code (Ctx)
            & " (" & Y.Generate_Code (Ctx) & ")";
      end Generate_Code;
   end Arithmetic;
end BinOps;

package body Operation_2 is
   package body Call is
      function Generate_Code
         (Ctx : in out Codegen.Emit_Context) return Codegen.Code
      is
         Arg_1_Code : constant Codegen.Code := Arg_1.Generate_Code (Ctx);
         Arg_2_Code : constant Codegen.Code := Arg_2.Generate_Code (Ctx);
      begin
         return Emit (Arg_1_Code, Arg_2_Code, Ctx);
      end Generate_Code;
   end Call;
end Operation_2;

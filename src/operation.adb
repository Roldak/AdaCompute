package body Operation is
   package body Call is
      function Generate_Code
         (Ctx : in out Codegen.Emit_Context) return Codegen.Code
      is
         Arg_Code : constant Codegen.Code := Arg.Generate_Code (Ctx);
      begin
         return Emit (Arg_Code, Ctx);
      end Generate_Code;
   end Call;
end Operation;

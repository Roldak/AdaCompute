with Ada.Text_IO; use Ada.Text_IO;

with Buffer;
with BinOps;
with Map;
with Store_All;
with Const;
with CLContexts;
with Codegen;

procedure Double_Example is
   package Buf is new Buffer (Integer, 10);

   package Two is new Const (Integer, 2);
   package Mul is new BinOps.Arithmetic_1 (BinOps.Multiply, Two.E);

   package Transform is new Map (Mul.Op, Buf.I);
   package Kernel is new Store_All (Transform.I, Buf.A);

   procedure Dump is new Buf.Dump (Integer'Image);

   Emit_Ctx : Codegen.Emit_Context;
   Ctx : constant CLContexts.Context := CLContexts.Default;
begin
   Put_Line (Kernel.Generate_Dispatch_Code (Emit_Ctx));

   Buf.Write (Ctx, (5, 4, 1, 6, 3, 6, 8, 2, 2, 5));
   Dump (Ctx);
   Kernel.Compute (Ctx);
   Dump (Ctx);
end Double_Example;

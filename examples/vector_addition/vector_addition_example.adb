with Ada.Text_IO; use Ada.Text_IO;

with Buffer;
with BinOps;
with Zip;
with Store_All;
with CLContexts;
with Codegen;

procedure Vector_Addition_Example is
   package In_Buf_1 is new Buffer (Integer, 10);
   package In_Buf_2 is new Buffer (Integer, 10);
   package Out_Buf is new Buffer (Integer, 10);

   package Add is new BinOps.Arithmetic_2 (BinOps.Add, Integer);
   package Res is new Zip (Add.Op, In_Buf_1.I, In_Buf_2.I);
   package Kernel is new Store_All (Res.I, Out_Buf.A);

   procedure Dump is new Out_Buf.Dump (Integer'Image);

   Emit_Ctx : Codegen.Emit_Context;
   Ctx : constant CLContexts.Context := CLContexts.Default;
begin
   Put_Line (Kernel.Generate_Dispatch_Code (Emit_Ctx));

   In_Buf_1.Write (Ctx, (5,  4, 1, 6, 3, 6, 8, 2, 2, 5));
   In_Buf_2.Write (Ctx, (8, -4, 3, 5, 1, 1, 2, 0, 6, 7));
   Out_Buf.Write (Ctx, (others => 0));
   Kernel.Compute (Ctx);
   Dump (Ctx);
end Vector_Addition_Example;

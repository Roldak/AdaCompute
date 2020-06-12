with Ada.Text_IO; use Ada.Text_IO;

with Buffer;
with Map;
with Map_2;
with Reduce_2;
with Const;
with Store_All;
with Int_Range;
with BinOps;
with Operations;
with CLContexts;
with Codegen;

procedure Convolution_1D_Example is
   package Buf is new Buffer (Integer, 10);

   package Rng_1 is new Int_Range (Integer, 0, 9);
   package Rng_2 is new Int_Range (Integer, -1, 1);
   package Zero is new Const (Integer, 0);

   package Add is new BinOps.Arithmetic_2 (BinOps.Add, Integer);
   package Buf_Get is new Buf.Safe_Get (Zero.E);
   package Buf_Add_Get is new Operations.Combine_2_1 (Add.Op, Buf_Get.Op);

   package Trf is new Map_2 (Buf_Add_Get.Op, Rng_1.I, Rng_2.I);
   package Red is new Reduce_2 (Zero.E, Add.Op, Trf.I);
   package Kernel is new Store_All (Red.I, Buf.A);

   procedure Dump is new Buf.Dump (Integer'Image);

   Emit_Ctx : Codegen.Emit_Context;
   Ctx : constant CLContexts.Context := CLContexts.Default;
begin
   Put_Line (Kernel.Generate_Dispatch_Code (Emit_Ctx));

   Buf.Write (Ctx, (1, 6, 4, 2, 5, 7, 2, 1, 7, 3));
   Dump (Ctx);
   Kernel.Compute (Ctx);
   Dump (Ctx);
end Convolution_1D_Example;

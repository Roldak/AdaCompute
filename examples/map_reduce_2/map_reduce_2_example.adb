with Ada.Text_IO; use Ada.Text_IO;

with Buffer;
with Map;
with Map_2;
with Reduce_2;
with Const;
with Store_All;
with Int_Range;
with BinOps;
with CLContexts;
with Codegen;

procedure Map_Reduce_2_Example is
   package Out_Buf is new Buffer (Natural, 10);

   package Rng_1 is new Int_Range (Natural, 0, 9);
   package Rng_2 is new Int_Range (Natural, 0, 5);

   package Zero is new Const (Natural, 0);
   package Add is new BinOps.Arithmetic_2 (BinOps.Add, Natural);
   package Trf is new Map_2 (Add.Op, Rng_1.I, Rng_2.I);
   package Red is new Reduce_2 (Zero.E, Add.Op, Trf.I);
   package Kernel is new Store_All (Red.I, Out_Buf.A);

   procedure Out_Dump is new Out_Buf.Dump (Natural'Image);

   Emit_Ctx : Codegen.Emit_Context;
   Ctx : constant CLContexts.Context := CLContexts.Default;
begin
   Put_Line (Kernel.Generate_Dispatch_Code (Emit_Ctx));

   Out_Buf.Write (Ctx, (others => 3));
   Kernel.Compute (Ctx);
   Out_Dump (Ctx);
end Map_Reduce_2_Example;

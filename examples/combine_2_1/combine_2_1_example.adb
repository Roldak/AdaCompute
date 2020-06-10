with Ada.Text_IO; use Ada.Text_IO;

with Buffer;
with Map;
with Const;
with Store_All;
with Int_Range;
with BinOps;
with Operations;
with CLContexts;
with Codegen;

procedure Combine_2_1_Example is
   Ctx : constant CLContexts.Context := CLContexts.Default;

   package In_Buf is new Buffer (Integer, 10, Ctx);
   package Out_Buf is new Buffer (Integer, 8, Ctx);
   package Rng is new Int_Range (Integer, -1, 6);

   package Zero is new Const (Integer, 0);
   package Two is new Const (Integer, 2);
   package Safe_Buf_Get is new In_Buf.Safe_Get (Zero.E);
   package Add is new BinOps.Arithmetic_2 (BinOps.Add, Integer);
   package Add_Get is new Operations.Combine_2_1 (Add.Op, Safe_Buf_Get.Op);
   package Partial is new Add_Get.Op.Apply_First (Two.E);
   package Transform is new Map (Partial.Op, Rng.I);
   package Kernel is new Store_All (Transform.I, Out_Buf.A);

   procedure In_Dump is new In_Buf.Dump (Integer'Image);
   procedure Out_Dump is new Out_Buf.Dump (Integer'Image);

   Emit_Ctx : Codegen.Emit_Context;
begin
   Put_Line (Kernel.Generate_Dispatch_Code (Emit_Ctx));

   In_Buf.Write ((5, 4, 1, 6, 3, 6, 8, 2, 2, 5));
   Out_Buf.Write ((others => 0));
   In_Dump;
   Kernel.Compute (Ctx);
   Out_Dump;
end Combine_2_1_Example;

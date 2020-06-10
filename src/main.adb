with Ada.Text_IO; use Ada.Text_IO;

with Buffer;
with BinOps;
with Map;
with Store_All;
with Const;
with Int_Range;
with CLContexts;
with Codegen;

procedure Main is
   Ctx : constant CLContexts.Context := CLContexts.Default;

   package Buf is new Buffer (Integer, 10, Ctx);

   package Two is new Const (Integer, 2);
   package Mul is new BinOps.Arithmetic_1 (BinOps.Multiply, Two.E);

   package Rng is new Int_Range (Integer, 0, 9);
   package Transform is new Map (Mul.Op, Rng.I);
   package Kernel is new Store_All (Transform.I, Buf.A);

   Values : Buf.Array_Type;

   Emit_Ctx : Codegen.Emit_Context;

   procedure Dump is
   begin
      Put ("[");
      for I in Values'Range loop
         Put (Values (I)'Image);
         Put (", ");
      end loop;
      Put_Line ("]");
   end Dump;
begin
   for I in Values'Range loop
      Values (I) := I;
   end loop;

   Put_Line (Kernel.Generate_Dispatch_Code (Emit_Ctx));

   Dump;
   Buf.Write (Values);
   Kernel.Compute (Ctx);
   Buf.Read (Values);
   Dump;
end Main;

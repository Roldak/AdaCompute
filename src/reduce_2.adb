with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with GID;

with Variable;

package body Reduce_2 is
   Reduce_Var_Id     : constant Natural := GID.Next;
   Reduce_Var_Id_Str : constant String := Reduce_Var_Id'Image;
   Reference         : aliased constant Codegen.Code :=
      "reduce_" & Reduce_Var_Id_Str
        (Reduce_Var_Id_Str'First + 1 .. Reduce_Var_Id_Str'Last);

   function Generate_Indexable_Code
     (Index_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code
   is
      package Index_1 is new Variable (Natural, Index_Code);
      package Index_2 is new Variable (Natural, "r");
      package Acc is new Variable (Init.Expr_Type, Reference);
      package Coll_Get is new Coll.Get (Index_1.E, Index_2.E);
      package Op_Call is new Op.Call (Acc.E, Coll_Get.E);

      Init_Code : constant Codegen.Code := Init.Generate_Code (Ctx);
      Init_Stmts : constant Unbounded_String := Codegen.Pop_Statements (Ctx);

      Op_Call_Code : constant Codegen.Code := Op_Call.Generate_Code (Ctx);
      Op_Call_Stmts : constant Unbounded_String :=
         Codegen.Pop_Statements (Ctx);

      Len : constant Natural := Coll.Length_2;
   begin
      Ctx.Statements := Init_Stmts
         & "int " & Reference & " = " & Init_Code & ";" & LF
         & "for (int r = 0; r < " & Len'Image & "; ++r) { " & LF
         & Op_Call_Stmts
         & Reference & " = " & Op_Call_Code & ";" & LF
         & "}" & LF;
      return Reference;
   end Generate_Indexable_Code;
end Reduce_2;

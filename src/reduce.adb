with GID;
with Variable;

package body Reduce is
   Reduce_Var_Id     : constant Natural := GID.Next;
   Reduce_Var_Id_Str : constant String := Reduce_Var_Id'Image;
   Reference         : aliased constant Codegen.Code :=
      "reduce_" & Reduce_Var_Id_Str
        (Reduce_Var_Id_Str'First + 1 .. Reduce_Var_Id_Str'Last);

   package Index is new Variable (Natural, "r");
   package Acc is new Variable (Init.Expr_Type, Reference);
   package Coll_Get is new Coll.Get (Index.E);
   package Op_Call is new Op.Call (Acc.E, Coll_Get.E);

   function Generate_Code
     (Ctx : in out Codegen.Emit_Context) return Codegen.Code
   is
      Init_Code : constant Codegen.Code :=
         Init.Generate_Code (Ctx);
      Len : constant Natural := Coll.Length;
   begin
      return "int " & Reference & " = " & Init_Code & ";"
         & "for (int r = 0; r < " & Len'Image & "; ++r) { "
         & Reference & " = " & Op_Call.Generate_Code (Ctx)
         & " ; }";
   end Generate_Code;
end Reduce;

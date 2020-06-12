with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with GID;

with CL.Queueing.Memory_Objects;
with CL.Events;

package body Buffer is
   Buffer_Id : constant Natural := GID.Next;
   Buffer_Id_Str : constant String := Buffer_Id'Image;
   Reference : aliased constant Codegen.Code :=
      "buffer_" & Buffer_Id_Str
        (Buffer_Id_Str'First + 1 .. Buffer_Id_Str'Last);

   Internal_Buffer : aliased CL.Memory.Buffers.Buffer;

   function Create_From_Source is new
      CL.Memory.Buffers.Constructors.Create_From_Source
        (Element_Type, Unconstrained_Array_Type);

   package Buffer_Objects is new
      CL.Queueing.Memory_Objects
        (Element_Type, Unconstrained_Array_Type);

   function Generate_Indexable_Code
     (Index_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code
   is
      Obj : constant Codegen.CL_Object :=
        (Name   => Reference'Unrestricted_Access,
         Object => Internal_Buffer'Unrestricted_Access);
   begin
      Codegen.Append_CL_Object (Ctx, Obj);
      return Reference & "[" & Index_Code & "]";
   end Generate_Indexable_Code;

   function Generate_Assignable_Code
     (Index_Code : Codegen.Code;
      Value_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code
   is
      Obj : constant Codegen.CL_Object :=
        (Name   => Reference'Unrestricted_Access,
         Object => Internal_Buffer'Unrestricted_Access);
   begin
      Codegen.Append_CL_Object (Ctx, Obj);
      return Reference & "[" & Index_Code & "] = " & Value_Code;
   end Generate_Assignable_Code;

   package body Safe_Get is
      function Generate_Code
        (Index_Code : Codegen.Code;
         Ctx : in out Codegen.Emit_Context) return Codegen.Code
      is
         Obj : constant Codegen.CL_Object :=
           (Name   => Reference'Unrestricted_Access,
            Object => Internal_Buffer'Unrestricted_Access);

         Stmts : constant Unbounded_String := Codegen.Pop_Statements (Ctx);
         Default_Code : constant Codegen.Code := Default.Generate_Code (Ctx);

         Fresh_Idx : constant Codegen.Code := Codegen.Fresh_Id (Ctx, "idx");
      begin
         Codegen.Append_CL_Object (Ctx, Obj);
         Ctx.Statements := Stmts
            & "int " & Fresh_Idx & " = " & Index_Code & ";" & LF
            & Codegen.Pop_Statements (Ctx);
         return "(" & Fresh_Idx & " < 0 || " & Fresh_Idx & " >= "
            & Size'Image & ") ? "
            & Default_Code
            & " : "
            & Reference & "[" & Fresh_Idx & "]";
      end Generate_Code;
   end Safe_Get;

   procedure Write (Ctx : CLContexts.Context; Values : Array_Type) is
   begin
      Internal_Buffer := Create_From_Source
        (Ctx.Context, CL.Memory.Read_Write, Values);
   end Write;

   procedure Read (Ctx : CLContexts.Context; Values : out Array_Type) is
		Event  : CL.Events.Event;
   begin
      Buffer_Objects.Read_Buffer
        (Ctx.Queue, Internal_Buffer, True, 0, Values, Event);
      Event.Wait_For;
   end Read;

   procedure Dump (Ctx : CLContexts.Context) is
      Values : Array_Type;
   begin
      Read (Ctx, Values);
      Put ("[");
      for I in Values'Range loop
         Put (Image (Values (I)));
         if I < Values'Last then
            Put (", ");
         end if;
      end loop;
      Put_Line ("]");
   end Dump;
end Buffer;

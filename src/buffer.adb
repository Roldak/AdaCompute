with GID;

with CL.Queueing.Memory_Objects;
with CL.Events;

package body Buffer is
   Buffer_Id : constant Natural := GID.Next;
   Buffer_Id_Str : constant String := Buffer_Id'Image;
   Reference : aliased constant Codegen.Code :=
      "buffer_" & Buffer_Id_Str
        (Buffer_Id_Str'First + 1 .. Buffer_Id_Str'Last);

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

   procedure Write (Values : Array_Type) is
   begin
      Internal_Buffer := Create_From_Source
         (Ctx.Context, CL.Memory.Read_Write, Values);
   end Write;

   procedure Read (Values : out Array_Type) is
		Event  : CL.Events.Event;
   begin
      Buffer_Objects.Read_Buffer
        (Ctx.Queue, Internal_Buffer, True, 0, Values, Event);
      Event.Wait_For;
   end Read;
end Buffer;

with Codegen;
with CLContexts;
with Indexable;
with Index_Assignable;
with Operation;

with CL.Memory.Buffers;

generic
   type T is private;
   Size : Natural;
   Ctx  : CLContexts.Context;
package Buffer is
   subtype Element_Type is T;

   type Unconstrained_Array_Type is
      array (Integer range <>) of aliased Element_Type;

   subtype Range_Type is Natural range 1 .. Size;
   subtype Array_Type is Unconstrained_Array_Type (Range_Type);

   function Generate_Indexable_Code
     (Index_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code;

   package I is new Indexable (T, Size, Generate_Indexable_Code);

   function Generate_Assignable_Code
     (Index_Code : Codegen.Code;
      Value_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code;

   package A is new Index_Assignable (T, Size, Generate_Assignable_Code);

   generic
      Default : T;
   package Safe_Get is
      function Generate_Code
        (Index_Code : Codegen.Code;
         Ctx : in out Codegen.Emit_Context) return Codegen.Code;

      package Op is new Operation (Integer, T, Generate_Code);
   end Safe_Get;

   Internal_Buffer : aliased CL.Memory.Buffers.Buffer;

   procedure Write (Values : Array_Type);

   procedure Read (Values : out Array_Type);

   generic
      with function Image (X : T) return String;
   procedure Dump;
end Buffer;

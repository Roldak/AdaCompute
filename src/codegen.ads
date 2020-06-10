with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

with CL;
with CL.Kernels;

package Codegen is
   subtype Code is String;

   type CL_Reference_Access is access all Code;
   type CL_Object_Access is access all CL.Runtime_Object'Class;

   type CL_Object is record
      Name   : CL_Reference_Access;
      Object : CL_Object_Access;
   end record;

   package CL_Object_Vectors is
      new Ada.Containers.Vectors (Natural, CL_Object);

   type Emit_Context is record
      Kernel_Arguments : CL_Object_Vectors.Vector;
      Statements : Unbounded_String;
   end record;

   procedure Append_CL_Object (Ctx : in out Emit_Context; Obj : CL_Object);

   function Signature (Ctx : Emit_Context) return Code;
   procedure Set_Kernel_Arguments (Ctx : Emit_Context; K : CL.Kernels.Kernel);
end Codegen;

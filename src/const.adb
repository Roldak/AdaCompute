with Ada.Unchecked_Conversion;

package body Const is
   function Generate_Code (Ctx : in out Codegen.Emit_Context) return Codegen.Code is
      pragma Unreferenced (Ctx);

      pragma Warnings (Off);
      function Convert is new Ada.Unchecked_Conversion
        (T, Integer);
      pragma Warnings (On);
   begin
      return Integer'Image (Convert (Value));
   end Generate_Code;
end Const;

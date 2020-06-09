with Indexable;
with Codegen;

generic
   type T is range <>;
   Lower_Bound : T;
   Upper_Bound : T;
package Int_Range is
   Length : constant Natural := Natural (1 + Upper_Bound - Lower_Bound);

   function Generate_Indexable_Code
     (Index_Code : Codegen.Code;
      Ctx : in out Codegen.Emit_Context) return Codegen.Code;

   package I is new Indexable (T, Length, Generate_Indexable_Code);
end Int_Range;

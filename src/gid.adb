package body GID is
   ID : Natural := 0;

   function Next return Natural is
   begin
      ID := ID + 1;
      return ID;
   end Next;
end GID;

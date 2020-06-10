# AdaCompute
An Ada-hosted, statically-checked, high-level DSL that compiles to OpenCL kernels.

## Example

Here is a simple program that doubles each value in the provided buffer. This transformation will be executed on the GPU but any type/range error will be reported at compile time.

```ada
procedure Double is
   --  Declare a GPU-allocated buffer of 10 integers
   package Buf is new Buffer (Integer, 10);
   
   --  Declare the integer constant "2"
   package Two is new Const (Integer, 2);
   
   --  Declare the partial operation "multiply by two"
   package Op is new BinOps.Arithmetic_1 (BinOps.Multiply, Two.E);
   
   --  Map the values of the given buffer to the operation defined above
   package Trsf is new Map (Op.Op, Buf.I);
   
   --  Copy the transformed values back in the buffer
   package Kernel is new Store_All (Trsf.I, Buf.A);
begin
   --  Write a random array to the GPU buffer
   Buf.Write ((5, 4, 1, 6, 3, 6, 8, 2, 2, 5));
   
   --  Execute the kernel
   Kernel.Execute;
   
   --  Read back the values from the GPU and print them
   Buf.Dump;
end Double;
```
This prints:

```
[10, 8, 2, 12, 6, 12, 16, 4, 4, 10]
```

The generated kernel is

```c
__kernel main(__global int* buffer_1) {
   int id = get_global_id (0);
   buffer_1[id] = buffer_1[id] * 2;
}
```

## Features

### Static checking

One of the main added value of this DSL is that it is statically checked. That is, any error made while designing the kernel will be reported at compile-time by your Ada compiler.

In comparison, the basic OpenCL workflow is to write your kernel in a `.cl` file, then to load it and compile it at runtime, meaning that any error would be catched at runtime only, or not catched at all and result in undefined behavior during execution.

To illustrate this, consider the following buggy kernel definition:
```ada
--  declare a GPU-allocated buffer of 10 Natural integers
package Buf is new Buffer (Natural, 10);

--  Create a Range expression from -5 to 5 (both ends included)
package Rng is new Int_Range (Integer, -5, 5);

--  Copy this range to the buffer
package Cpy is new Copy (Rng.I, Buf.A);

--  Prepare a dispatch operation
package Kernel is new Cpy.Dispatch;
```

Fortunately, this program will not even compile! First, the compiler will complain that you are trying to assign integer
values to a buffer of natural numbers. Once you fix this (replace `Natural` by `Integer` in the definition of `Buf`), the compiler will now complain that you cannot assign a range of 11 elements to a buffer of 10 elements. Modify the declaration of `Buf` to `package Buf is new Buffer (Integer, 11);` and it will now compile correctly.

### High-level description of kernels

Another big feature is that the programs are written using high-level functional-style constructs. These are then compiled to low-level OpenCL kernels, as shown in the introductory example. Such constructs include `Map`, `Reduce`, etc. 

## Build Steps

- Clone and build [OpenCLAda](https://github.com/flyx/OpenCLAda) (GL support not required), make sure `opencl.gpr` is in your `GPR_PROJECT_PATH` environment variable.
- Run `sh make`

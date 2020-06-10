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
package Kernel is new Store_All (Rng.I, Buf.A);
```

Fortunately, this program will not even compile! First, the compiler will complain that you are trying to assign integer
values to a buffer of natural numbers. Once you fix this (replace `Natural` by `Integer` in the definition of `Buf`), the compiler will now complain that you cannot assign a range of 11 elements to a buffer of 10 elements. Modify the declaration of `Buf` to `package Buf is new Buffer (Integer, 11);` and it will now compile correctly.

### High-level description of kernels

Another big feature is that the programs are written using high-level functional-style constructs. These are then compiled to low-level OpenCL kernels, as shown in the introductory example. Such constructs include `Map`, `Reduce`, etc. 

## Build Steps

- Clone and build [OpenCLAda](https://github.com/flyx/OpenCLAda) (GL support not required), make sure `opencl.gpr` is in your `GPR_PROJECT_PATH` environment variable.
- Run `sh make`

## More complex example

Here is how to describe 1D convolution:

```ada
--  The input and output buffer
package Buf is new Buffer (Integer, 10, Ctx);

--  Declare some constants
package Rng_1 is new Int_Range (Integer, 0, 9);
package Rng_2 is new Int_Range (Integer, -1, 1);
package Zero is new Const (Integer, 0);

--  Create the operation `(i, j) => buffer[i + j]` (with bound checks)
package Add is new BinOps.Arithmetic_2 (BinOps.Add, Integer);
package Buf_Get is new Buf.Safe_Get (Zero.E);
package Buf_Add_Get is new Operations.Combine_2_1 (Add.Op, Buf_Get.Op);

--  Compute the convolution
package Trf is new Map_2 (Buf_Add_Get.Op, Rng_1.I, Rng_2.I);
package Red is new Reduce_2 (Zero.E, Add.Op, Trf.I);

--  Store the convolution of each element back in the buffer.
package Kernel is new Store_All (Red.I, Buf.A);
```

This generates the following OpenCL kernel:

```c
__kernel void main(__global int* buffer_1) {
   size_t i = get_global_id(0);
   int reduce_2 =  0;
   for (int r = 0; r <  3; ++r) {
      int idx = i + r - 1;
      reduce_2 = reduce_2 + ((idx < 0 || idx >=  10) ? 0 : buffer_1[idx]);
   }
   buffer_1[i] = reduce_2;
}
```

Applied to a buffer containing `[ 1,  6,  4,  2,  5,  7,  2,  1,  7,  3]`, it yields `[ 7,  11,  12,  11,  14,  14,  10,  10,  11,  10]`. You can find the source code for this example in the `examples` directory.

# Reverse engineering native code

These are some notes based on disassembling XComEW.exe. Feel free to add to these as needed.

Some data structures such as dynamic arrays and strings aren't discussed here, but their layouts can be found in the ReClass file.

# Observed UE3 conventions

## General memory layout

* All memory is aligned to 4-byte (DWORD) boundaries.
* Enums are 1 byte each. Enums declared sequentially will occupy the same DWORD. If enums do not fill a DWORD, trailing bytes are padded with zeroes.
* Booleans are 1 bit each. Booleans declared sequentially will occupy the same DWORD. If booleans do not fill a DWORD, trailing bytes are padded with zeroes.
  * Accordingly, accessing a boolean value typically requires bit shifting and masking. Bits are ordered such that, if you have boolean variables `bool0` through `bool31` in the same DWORD, `bool0` requires a right shift of 0, `bool1` requires a right shift of 1, and so on. (In this example, `bool0` is declared above all others, and `bool31` below all others.)

This packing behavior makes it much more efficient to declare all enums sequential with each other, and likewise with booleans. This is followed in some places within the XCOM code, but not all.

## Function calls

* `eax` is used for return values from functions.
* `ecx` is used to pass the `this` pointer.
* Calls to functions declared `native` from UnrealScript will use typical dynamic dispatch, such that if a subclass overrides the function without the `native` keyword, the non-native implementation is used.
* Calls to functions declared `native` from native code **will not** use UE3's virtual machine for dynamic dispatch; they use the object's vtable directly. This means that if you override a native function with a non-native version, **native code will not call your non-native override**.

Due to the last point above, overriding native functions should be a last resort, and memory access monitoring should be used to try and ensure that all calls to the overridden function have been rewritten as well. Rewriting a native function means you have to rewrite the entire hierarchy of native calls leading to that function, so it's very time consuming and error prone.

## Names

All `name` variables consist of two parts: an index into the global name table, and an integer suffix to append to the name. This approach saves memory by only allocating the string portion of each name once.

The global name table is what it sounds like: an enormous array in memory with each entry representing one name. The location moves around slightly each time the game is started, but a DWORD which holds the address has been marked in IDA. The table doesn't hold the actual names, but instead pointers to the name entries; the name entries themselves are variable size.

Each entry in the name table points to a data structure composed of:

* 16 bytes at the start of the entry. Bytes 9 through 12 are an `int32` which is always 2x the index of the entry. Other bytes are generally 0, and their purpose is unknown. Why the index is stored at all, and why it's 2x the index value, is also unknown.
* The remaining bytes of the entry contain the actual string, which is null-terminated. It appears that, following the null character, the next name entry begins immediately, with no regards for alignment.

## Virtual tables

Vtables are laid out in typical fashion, starting from the topmost class in the hierarchy and proceeding sequentially through the hierarchy. Within each class, functions are arranged in the same order they are declared. As would be expected, only `native` functions generate vtable entries, and only those that aren't marked `final` or `static`. Functions marked `native event` are also included, but non-native `event` functions are not.

So far I've only had success with the last class in the hierarchy. Virtual table entries prior to this include a lot of repeated subs that I can't make sense of.

# ReClass.NET tips

This is a great program, but buggy. Off the top of my head:

* Do not enter addresses with the `0x` prefix. It will throw an exception and you'll have to restart the program. Yes, really.
* Sometimes you simply won't be able to change the type of a node, for no apparent reason. You also might be unable to delete nodes. There are a few classes in our file which have nodes of the wrong type or wrong name because of this.
* Copy and paste with keyboard shortcuts works sometimes and not others.
* When you create a new enum type and close it, upon reopening the enum, you'll find the names and values have switched. This doesn't seem to break anything.
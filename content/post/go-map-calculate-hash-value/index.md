+++
title = "How does go calculate a hash value for keys in a map?"
date = "2021-10-10T15:27:19+08:00"
author = "resyon"
authorTwitter = "" #do not include @
cover = ""
tags = ["golang"]
description = ""
showFullContent = false
readingTime = false
draft = false
+++

# How does go calculate a hash value for keys in a map?
> [ref](https://stackoverflow.com/questions/37625480/how-does-go-calculate-a-hash-value-for-keys-in-a-map)

## original
1. The language spec doesn't say, which means that it's free to change at any time, or differ between implementations.

2. The hash algorithm varies somewhat between types and platforms. As of now: On x86 (32 or 64 bit) if the CPU supports AES instructions, the runtime uses aeshash, a hash built on AES primitives, otherwise it uses a function "inspired by" xxHash and cityhash, but different from either. There are different variants for 32-bit and 64-bit systems. Most types use a simple hash of their memory contents, but floating-point types have code to ensure that 0 and -0 hash equally (since they compare equally) and NaNs hash randomly (since two NaNs are never equal). Since complex types are built from floats, their hashes are composed from the hashes of their two floating-point parts. And an interface's hash is the hash of the value stored in the interface, and not the interface header itself.

3. All of this stuff is in private functions, so no, you can't access Go's internal hash for a value in your own code.

4. if two things compare equal with == they must have equal hashes (or maps wouldn't work... this is also the reasoning behind all of the special cases I outlined above). That means that strings hash their bodies, not their headers. And structs compose the hashes of all of their fields. I can't find the code actually implementing that, but the tests and the comparison rules make it clear.

## summary
1. 平台/体系结构相关, `func hash`绑定至`_type.alg`中, `x86`下且支持`AES`指令使用基于`AES`原语的`aeshash`, 否则...
2. `float`的计算方式比较特殊, 由于`IEEE-754`. 
3. `interface`的哈希根据存储其中的`hash value`计算出, 而非头部
4. `string`, `struct` 的哈希值由构成他们的域/字符计算得出, 而非头部
5. `golang`定义的`hash`均为私有, 但可以通过`==`推断二者的`hash value`是否相等, [但注意 `slice`, `map`, `func`, `带有前面3者的array && struct`不可比较](https://golang.org/ref/spec#Comparison_operators)


+++
title = "golang nil interface"
date = "2021-10-09T17:47:39+08:00"
author = "resyon"
authorTwitter = "" #do not include @
cover = ""
tags = ["golang"]
description = ""
showFullContent = false
readingTime = false
draft = false
+++

# golang nil interface

> [ref](https://golang.design/go-questions/interface/dynamic-typing/)

## preparation: structure of interface entry

### common interface

```go
type iface struct {
	tab  *itab
	data unsafe.Pointer
}

type itab struct {
	inter  *interfacetype
	_type  *_type
	link   *itab
	hash   uint32 // copy of _type.hash. Used for type switches.
	bad    bool   // type does not implement interface
	inhash bool   // has this itab been added to hash?
	unused [2]byte
	fun    [1]uintptr // variable sized
}

type interfacetype struct {
	typ     _type
	pkgpath name
	mhdr    []imethod
}
```
### `interface{}`

```go
type eface struct {
    _type *_type
    data  unsafe.Pointer
}
```

## `nil` 

> interface nil := type == nil && data == nil
> struct nil := data == nil
### common interface 

```go
type Coder interface {
        code()
}

type Gopher struct {
}

func (g Gopher) code() {
}

func main() {
        var c Coder
        fmt.Println(c == nil) 		// true
        fmt.Printf("c: %T, %v\n", c, c) // c: <nil>, <nil>

        var g *Gopher
        fmt.Println(g == nil)		// true
	// declare an interface `g`, type of `g` is still `nil`
        fmt.Printf("g: %T, %v\n", g, g) // g: *main.Gopher, <nil>

	// assign interface `c` struct type `g`
        c = g
        fmt.Println(c == nil)		// false
        fmt.Printf("c: %T, %v\n", c, c) // c: *main.Gopher, <nil>

}
```
> output
```
true
c: <nil>, <nil>
true
g: *main.Gopher, <nil>
false
c: *main.Gopher, <nil>
```

### `interface{}`

```go
func main() {
    var i interface{}
    fmt.Printf("%T, %v\n", i, i) // <nil>, <nil>
    i = 8
    fmt.Printf("%T, %v\n", i, i) // int, 8
    v, _ :=  i.(int)
    fmt.Printf("%T, %v\n", v, v) // int, 8
}
```
> output
```
<nil>, <nil>
int, 8
int, 8 
```
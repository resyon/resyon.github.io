+++
title = "awesome way to make use of nil channel"
date = "2021-12-08T20:45:20+08:00"
author = "resyon"
authorTwitter = "" #do not include @
cover = ""
tags = ["golang"]
description = ""
showFullContent = false
readingTime = false
draft = false
+++

# Awesome way to make use of `nil` channel

## common 
Send and receive operations on a nil channel block forver. It's a well documented behavior

```go
package main

import (
	"fmt"
)

func main() {
	var ch chan int

	go func() {
		fmt.Println("ready to read from ch")
		fmt.Printf("get val: %v\n", <-ch)
	}()
	fmt.Println("ready to write val to ch")
	ch <- 17
}
```
got output
![image.png](/upload/2021/12/image-91291c0c90e24bb4b012c102129be6cd.png)

## awesome usage
This behavior can be used as a way to dynamically enable and disable case blocks in a select statement.

```go
package main

import(
	"fmt"
	"time"
)

func main() {  
    inch := make(chan int)
    outch := make(chan int)

    go func() {
	// (0) `in != nil`
        var in <- chan int = inch
        var out chan <- int
        var val int
        for {
	    // enable and disable `out`, `in`
            select {
	    // (1)(3) out == nil => { blocking }
	    // (2)(4) out != nil => { out <- val; in != nil } 
            case out <- val:
                out = nil
                in = inch

	    // (1)(3) in != nil => { out != nil; val <- in; in == nil }
	    // (2)(4) in == nil => { blocking }
            case val = <- in:
                out = outch
                in = nil
            }
        }
    }()

    go func() {
	// (1) blocking
	// (2) result: 1
	// (3) blocking
	// (4) result: 2
        for r := range outch {
            fmt.Println("result:",r)
        }
    }()

    time.Sleep(0)
    inch <- 1
    inch <- 2
    time.Sleep(3 * time.Second)
}
```


### ref
[http://devs.cloudimmunity.com/gotchas-and-common-mistakes-in-go-golang/index.html](http://devs.cloudimmunity.com/gotchas-and-common-mistakes-in-go-golang/index.html)
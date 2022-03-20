+++
title = "ACM 模式输入输出"
date = "2022-03-20T17:19:42+08:00"
author = "resyon"
authorTwitter = "" #do not include @
cover = ""
description = "golang 在 acm 模式输入输出"
showFullContent = false
readingTime = false
draft = false
+++

# ACM 模式输入输出

> 近期参加了几场笔试，对 ACM 模式的算法输入输出倍感恶心， 总结一下

## API

1. fmt.Scanf: 和 C 一样
2. fmt.Scan: 同上
3. fmt.Scanln: 和名字不一样，**他遇到空格会停下**
4. strings.Fields(string) -> string: 将字符串按空格分开
5. bufio.Reader.ReadBytes(byte) -> ([]byte, error): 读取目标字符前的所有字符

## 输入

输入样例
2 对坐标，n 行整型
```
8 9
7 3
0 32 4 3 5
43 4 2 4 3
```

```go
var x int
var y int
var m int
var n int
var vs [][]int
// 1. c-like
fmt.Scanf("%d %d", &x, &y) // 

// 2.
fmt.Scan(&m, &n)

// 3. read line
reader := bufio.NewReader(io.Stdin)
for {
    line, err := reader.ReadBytes('\n')
    // now line is "0 32 4 3 5"
    var tmp []int
    for _, v := range strings.Fields(string(line)) {  // split line by space
       vv, _ := strconv.Atoi(v)
       tmp = append(tmp, vv) 
    }
    vs = append(vs, tmp)
    if err == io.EOF {
        break
    }
}

```

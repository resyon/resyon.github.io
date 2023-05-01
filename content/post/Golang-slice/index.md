+++
title = "Golang切片使用风格"
date = "2021-05-09T21:54:38+08:00"
author = "resyon"
authorTwitter = "" #do not include @
cover = ""
tags = ["golang"]
description = ""
showFullContent = false
readingTime = false
draft = false
+++

## 切片声明
>此前特别喜欢用字面量声明一个切片,
即， `slice := []int{}` ,
读了[uber go 风格指南](https://github.com/gocn/translator/blob/master/2019/w38_uber_go_style_guide.md#zero-value-mutexes-are-valid)后发现，这样其实不大好

![image.png](/upload/2021/05/image-4f1f94305ece4de2a7ee4f0c2281e518.png)

此前总是那样做是担心声明的方式`var slice []int`，`slice`未初始化，

然而， 切片的默认值实际是有效的
## 切片默认值(`nil`)使用
![image.png](/upload/2021/05/image-d38fa7064a654779b21ba9e53a09a1b1.png)
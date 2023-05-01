+++
title = "OS Summary"
date = "2022-02-20T12:58:28+08:00"
author = "resyon"
authorTwitter = "" #do not include @
cover = ""
tags = ["2022-Spring"]
keywords = ["", ""]
description = "总结的一些操作系统/ Linux 常见八股"
showFullContent = false
readingTime = true
+++

# 操作系统 / Linux

## 绪论

### 什么是操作系统

操作系统是 **管理计算机软硬件资源的计算机程序**，同时也是计算机系统的内核与基石

### 操作系统的基本功能

1. 内存管理

内存分配，地址映射，内存保护与共享，虚拟内存等

2. 进程管理

进程控制，同步，通信；死锁处理，处理器掉调度

3. 设备管理

完成用户的 IO 请求，方便用户使用设备，提高设备利用率。主要包括缓冲管理，设备分配，设备处理，虚拟设备等

4. 文件管理

文件存储空间，目录的管理，文件读写管理和保护

### 操作系统的特点

1. 虚拟：一个物理实体映为多个逻辑对应物，分为空分复用（eg. 虚拟内存），时分复用（分时系统）
2. 共享：资源可供内存中多个并发执行的进程共同使用
3. 并发
4. 异步：独立，不可预知的速度向前推进

## 中断

## 进程，线程，协程

### 进程

**进程是资源分配的基本单位**，用于管理资源（内存，文件，网络等资源）

#### 进程的特点

PCB 描述进程的基本信息和运行状态，所谓的创建进程和撤销进程，都是指对 PCB 的操作

1. 动态性（相对程序）
2. 并发
3. 独立
4. 异步

#### 特殊进程

1. 守护进程：运行在后台的一种特殊进程，独立于控制终端并周期性地执行某些任务

2. 僵尸进程：子进程退出，而父进程未调用 `wait/waitpid` 获取子进程的状态信息，则该子进程的 **进程描述符** 等信息仍保存在系统中，称为僵尸进程

3. 孤儿进程：父进程退出，仍在运行的子进程称为孤儿进程，将由 `init` 进程收养

### 线程

**线程是独立调度的基本单位**，一个进程可以有多个线程，共享进程资源

### 超线程

超线程，也叫多线程，是指一种 **处理器特性**，一个 `CPU`可以保持两个线程状态，然后在纳秒级间隔内 **切换**。
实际上是并行。


## 设备

### I/O 设备

I/O 设备包括 **设备控制器** 和 **设备本身**
**设备控制器** 的作用是为操作系统提供简单的接口




## 杂项

### 如何修改内核参数

> [ref](https://www.rootusers.com/use-procsys-and-sysctl-to-modify-and-set-kernel-runtime-parameters/)

`/proc/sys` 下的文件对应内核参数, ( `/ -> .`)

1. 重启即恢复默认

```bash
# eg. modify net.ipv4.icmp_echo_igore_all = 1

echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all

# or

sysctl -w net.ipv4.icmp_echo_ignore_all=1
```

2. 持久化修改

```bash
# eg. on RHE7

# make sure a *.conf existed in /etc/sysctl.d/

# touch /etc/sysctl.d/icmp_ignore.conf

echo "net.ipv4.icmp_echo_ignore_all = 1" > /etc/sysctl.d/icmp-ignore.conf
```

## ref

- [https://blog.csdn.net/ewq21qwe/article/details/106578620?spm=1001.2014.3001.5501](https://blog.csdn.net/ewq21qwe/article/details/106578620?spm=1001.2014.3001.5501)
- [https://www.rootusers.com/use-procsys-and-sysctl-to-modify-and-set-kernel-runtime-parameters](https://www.rootusers.com/use-procsys-and-sysctl-to-modify-and-set-kernel-runtime-parameters/)
- [https://github.com/KeKe-Li/data-structures-questions/blob/master/src/chapter06/golang.01.md](https://github.com/KeKe-Li/data-structures-questions/blob/master/src/chapter06/golang.01.md)
+++
title = "美团 SRE"
date = "2022-03-21T16:19:42+08:00"
author = "resyon"
authorTwitter = "" #do not include @
cover = ""
description = "美团 SRE 面经"
showFullContent = false
readingTime = false
draft = false
+++

> 投的后端, 但一面面试官告知是 SRE KV 存储

## 一面 (3.21; 63min)

1. `TCP` 3 握 4 挥
2. 为什么 握手要 3 次, 而挥手要 4 次
3. `HTTP` 状态码; 403; 503; 499 (HTTP 499 in Nginx means that the client closed the connection before the server answered the request. In my experience is usually caused by client side timeout. As I know it's an Nginx specific error code.)
4. 浏览器输入 URL 之后发生了什么
5. 僵尸进程 和 孤儿进程 的区别
6. 知道 `top` 吗, `top` 内存栏里 `free`, `used`, `buff` 占用的含义
   
![top](/img/13.png)

> [ref](https://unix.stackexchange.com/questions/390518/what-do-the-buff-cache-and-avail-mem-fields-in-top-mean)

```
top's manpage doesn't describe the fields, but free's does:

> **buffers**: Memory used by kernel buffers (`Buffers` in `/proc/meminfo`)
>
> **cache**: Memory used by the page cache and slabs (`Cached` and `SReclaimable` in `/proc/meminfo`)
>
>**buff/cache**: Sum of buffers and cache
>
>**available**: Estimation of how much memory is available for starting new applications, **without swapping**. Unlike the data provided by the cache or free fields, this field **takes into account page cache** and also that not all reclaimable memory slabs will be reclaimed due to items being in use (MemAvailable in /proc/meminfo, available on kernels 3.14, emulated on kernels 2.6.27+, otherwise the same as free)

Basically, "buff/cache" counts memory used for data that's on disk or should end up there soon, and as a result is potentially usable (the corresponding memory can be made available immediately, if it hasn't been modified since it was read, or given enough time, if it has); "available" measures the amount of memory which can be allocated and used without causing more swapping (see How can I get the amount of available memory portably across distributions? for a lot more detail on that).
```

7. shell 题

```bash
# text.txt:
a 1 
b 2
c 3
a 14
b 24
c 77

# 按第一列去重后求和第二列

awk '{a[$1]++; if(a[$1]==1)sum+=$2} END {print sum}' text.txt
```

7. 平时用过啥命令
8. MySQL 索引, 主键, 外键的区别
9. MySQL MyISAM, Innodb 的区别
10. MySQL 主从复制
11. MySQL 半同步复杂有什么利弊
12. Redis 数据类型
13. Redis 持久化
14. Redis Cluster
15. MQ 一致性
16. Go defer 原理
17. Go 单个函数使用多个 defer 的情况
18. Go 并发控制有哪些方式
19. Go Slice 并发安全吗
20. Go Slice 扩容 
21. 实习经历
22. 合并有序数组
23. 反转链表


## 总结 1

八股有些生疏了
面试官评价技术细节掌握的不太清楚
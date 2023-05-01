+++
title = "Network Summary"
date = "2022-02-20T13:01:00+08:00"
author = ""
authorTwitter = "" #do not include @
cover = ""
tags = ["2022-Spring"]
keywords = ["", ""]
description = "总结了一些常见的计网八股"
showFullContent = false
readingTime = true
+++

# 计网

## TCP

### 说一下 `TCP`

`TCP` 是位于运输层的协议，为应用层提供 **面向连接的**，**可靠的** **字节流** 服务

面向连接：一定是「一对一」才能连接，不能像 UDP 协议 可以一个主机同时向多个主机发送消息，也就是一对多是无法做到的；

可靠的：无论的网络链路中出现了怎样的链路变化，TCP 都可以保证一个报文一定能够到达接收端；

字节流：消息是「没有边界」的，所以无论我们消息有多大都可以进行传输。并且消息是「有序的」，当「前一个」消息没有收到的时候，即使它先收到了后面的字节已经收到，那么也不能扔给应用层去处理，同时对「重复」的报文会自动丢弃。

### `TCP` 连接

```
Connections: 

The reliability and flow control mechanisms described above require that TCPs initialize and maintain certain status information for each data stream.  

The combination of this information, including sockets, sequence numbers, and window sizes, is called a connection.
```

简单来说就是，用于保证 **可靠性和流量控制维护的某些状态信息**，这些信息的组合，包括Socket、序列号和窗口大小称为连接。

（源地址，源端口，目的地址，目的端口）4 元组可以唯一确定 1 个连接

### `TCP` 与 `UDP` 的区别

#### 连接

TCP 是面向连接的传输层协议，传输数据前先要建立连接。

UDP 是不需要连接，即刻传输数据。

#### 服务对象

TCP 是一对一的两点服务，即一条连接只有两个端点。

UDP 支持一对一、一对多、多对多的交互通信

#### 可靠性

TCP 是可靠交付数据的，数据可以无差错、不丢失、不重复、按需到达。

UDP 是尽最大努力交付，不保证可靠交付数据。

#### 拥塞控制、流量控制

TCP 有拥塞控制和流量控制机制，保证数据传输的安全性。

UDP 则没有，即使网络非常拥堵了，也不会影响 UDP 的发送速率。

#### 首部开销

TCP 首部长度较长，会有一定的开销，首部在没有使用「选项」字段时是 20 个字节，如果使用了「选项」字段则会变长的。

UDP 首部只有 8 个字节，并且是固定不变的，开销较小。

#### 分段

TCP 对应用层传来的数据包进行分段，UDP 则不做处理

> 为什么 IP 有分片，TCP 还要进行分段
> ![图源: https://www.imperva.com/blog/mtu-mss-explained/](/img/8.png)

为了保证 **传输效能**，也方便重传

为了达到最佳的传输效能 TCP 协议在建立连接的时候通常要协商双方的 MSS 值，使 `MSS + IP首部  <= MTU`，确保单个 TCP 报文段无需再经过 IP 层进一步分片。这样，如果一个 TCP 分片丢失，进行重发时也是以 MSS 为单位，而不用重传所有的分片，大大增加了重传的效率

### `TCP` 如何保证 **可靠** 传输

1. 确认应答，自适应的超时及重传策略确保不丢包
2. 首部校验和确保不接收差错报文
3. 序列号使得 `TCP` 能够通过重排序确保报文段不失序，不冗余
4. 流量控制确保缓冲区不溢出

### `TCP` 3 次握手

#### 过程

> [原图 url](http://blog-img.coolsen./img/image-20210520161056918.png)

![tcp3 次握手](/img/4.png)

1. 客户端将 `SYN` 置为 1 ，随机产生一个 `seq=i`，并将数据包发送给服务器，客户端进入 `SYN_SENT` 状态，等待服务器确认。
2. 服务器收到数据包后，由 `SYN` 为 1 知道客户端请求建立连接，将 `SYN` 和 `ACK` 置为1，`ack=i+1`，随机产生 `seq=j`，并将数据包发送给客户端以确认连接请求。服务器进入 `SYN_RCVD` 状态。
3. 客户端收到确认后，检查 `ack` 是否为 `i+1`，`ACK` 是否为 1，如果正确将 `ACK=1`，`ack` 置为 `j+1`，并将数据包发送给服务器，服务器检查 `ack` 是否为 `j+1`，`ACK=1`，如果正确则连接建立成功，双方进入 `ESTABLISHED` 状态，完成三次握手。

#### 原因（为什么要 3 次握手）

##### 为什么不是两次？

1. 首要原因是为了防止旧的重复连接初始化造成混乱。
   
   ![过期 SYN 干扰](/img/5.jpg)
   
   在双方两次握手即可建立连接的情况下，假设客户端发送 A 报文段请求建立连接，由于网络原因造成 A 暂时无法到达服务器，服务器接收不到请求报文段就不会返回确认报文段。
   
   客户端在长时间得不到应答的情况下重新发送请求报文段 B，这次 B 顺利到达服务器，服务器随即返回确认报文并进入 ESTABLISHED 状态，客户端在收到 确认报文后也进入 ESTABLISHED 状态，双方建立连接并传输数据，之后正常断开连接。
   
   此时姗姗来迟的 A 报文段才到达服务器，服务器随即返回确认报文并进入 ESTABLISHED 状态，但是已经进入 CLOSED 状态的客户端无法再接受确认报文段，更无法进入 ESTABLISHED 状态，这将导致服务器长时间单方面等待，造成资源浪费。

2. 三次握手才能让双方均确认自己和对方的发送和接收能力都正常（有能力建立全双工连接）。2 次握手，如果客户端的 SYN 阻塞了，重复发送多次 SYN 报文，那么服务器在收到请求后就会建立多个冗余的无效链接，造成不必要的资源浪费。

![2 次握手, SYN 阻塞造成的资源浪费](/img/6.jpg)

   第一次握手：客户端只是发送处请求报文段，什么都无法确认，而服务器可以确认自己的接收能力和对方的发送能力正常；

   第二次握手：客户端可以确认自己发送能力和接收能力正常，对方发送能力和接收能力正常；

   第三次握手：服务器可以确认自己发送能力和接收能力正常，对方发送能力和接收能力正常；

   可见三次握手才能让双方都确认自己和对方的发送和接收能力全部正常，这样就可以愉快地进行通信了。

3. 告知对方自己的初始序号值，并确认收到对方的初始序号值。（同步 `seq`）
   
   TCP 实现了可靠的数据传输，原因之一就是 TCP 报文段中维护了序号字段和确认序号字段，通过这两个字段双方都可以知道在自己发出的数据中，哪些是已经被对方确认接收的。这两个字段的值会在初始序号值得基础递增，如果是两次握手，只有发起方的初始序号可以得到确认，而另一方的初始序号则得不到确认。

##### 为什么不是 4 次

![4 次握手](/img/7.jpg)

没有必要。因为三次握手已经可以确认双方的发送接收能力正常，双方都知道彼此已经准备好，而且也可以完成对双方初始序号值得确认，也就无需再第四次握手了。

### 半连接队列(`sync`) 全连接队列(`backlog`) 积压值 (`backlog`)

> [https://www.bilibili.com/video/BV1AK4y177WA](https://www.bilibili.com/video/BV1AK4y177WA)

#### 作用

![连接队列](/img/3.png)

`TCP` 完成 3 次握手建立连接后，放入连接队列，这个队列的长度称为 `backlog`，取值范围 [0, 5]，通常为 5

积压值说明的是 TCP 监听的端点已被 TCP 接受而等待应用层接受的最大连接数，对系统所允许的最大连接数或者并发服务器所能并发处理的客户数无影响

#### accept queue满了之后的协议栈处理

```bash
cat /proc/sys/net/ipv4/tcp_abort_on_overflow
```

有效值:0或者1
0: 当 `TCP` 建立连接的 3 路握手完成后，将连接置入 `ESTABLISHED` 状态并交付给应用程序的 `backlog` 队列时，会检查 `backlog` 队列是否已满。若已满，通常行为是将连接还原至 `SYN_ACK` 状态，以造成 3 路握手最后的 `ACK` 包意外丢失假象――这样在客户端等待超时后可重发 `AcK` —―以再次尝试进入 `ESTABLISHED` 状态――作为一种修复/重试机制。

1: 如果 `tcp _abort_on_overflow` 为 1，则在检查到   `backlog` 队列已满时，直接发 `RST` 包给客户端终止此连接--此时客户端程序会收到 `104 Connection reset by pee` r错误

### `SYN` 攻击

#### 原理

攻击者短时间内伪造不同 `IP` 的 `SYN` 报文，服务端回之 `ACK + SYN` 并进入 `SYN_RCVD` 状态，由于没有收到 `ACK` 的确认连接，长期停滞在 `SYN_RCVD` 状态，最终占满半连接队列，使得服务器不能为正常用户服务

#### 避免

1. 通过修改内核参数，调整 **队列大小** 和 **队列满时的行为**

> [如何修改内核参数 ? ](./os.md)

```conf
# 缓存网卡至内核数据包的队列大小
net.core.netdev_max_backlog

# 半连接队列的大小，限制处于 `SYN_RCVD` 状态的连接数目
net.ipv4.tcp_max_syn_backlog

# 对超出处理能力的 SYN 回复 RST
net.ipv4.tcp_abort_on_overflow
```

2. `tcp_syncookies` 

原理

![tcp_syn_cookies](/img/9.jpg)

半连接队列满后，不再插入后续的 `SYN` 包，而在回应的 `SYN + ACK` 包中夹带计算得到的 `cookie`，后续若收到 `ACK` 报文，则在检查合法性通过后将其直接加入 **全连接队列**

打开方法

```conf
net.ipv4.tcp_syncookies = 1
```

3. 通过防火墙、路由器等过滤网关防护

### `TCP` 四次挥手

#### 过程

> [原图：小林coding](/img/10.jpg)

1. 客户端将 `FIN` 置为1，发送给服务器，用来关闭客户端到服务器的数据传送，客户端进入 `FIN_WAIT_1` 状态。
2. 服务器收到 `FIN` 之后，回复 `ACK`，确认序号为收到序号+1，服务器进入 `CLOSE_WAIT` 状态，此时 `TCP` 连接处于**半关闭状态**，即客户端没有要发送的数据了，但是仍然可以接受服务器端的数据。
3. 当服务器也没有要发送的数据时，向客户端发送一个 `FIN`，用来关闭服务器到客户端的数据传送，服务器进入 `LAST_ACK` 状态。
4. 客户端收到 `FIN` 之后，进入 `TIME_WAIT` 状态，回复 `ACK`，确认序号为收到序号+1，服务器进入 `CLOSED` 状态，完成四次挥手

#### 为什么 `TIME_WAIT` 要等 2MSL

> Linux 默认 MSL=30s
> MSL：报文最大生存时间

1. 确保 `FIN` 发起方的最后一个 `ACK` 被接收，否则接收方超时，重发 `FIN`
2. 确保本次连接的报文段在网络中消失，以免干扰下一次连接. `2MSL` 时间的 `TIME_WAIT` 状态能够确保网络上两个传输方向上尚未被接收到的、迟到的 `TCP` 报文段都已经消失（被中转路由丢弃）。

![旧的延迟的报文干扰](/img/11.jpg)

### `TCP` 发送 `RST` 的情形

> `RST` 表示复位，用来异常的关闭连接，在 `TCP` 的设计中它是不可或缺的。发送 `RST` 包关闭连接时，不必等缓冲区的包都发出去，**直接就丢弃** 缓存区的包发送 `RST`包。而接收端收到RST包后，也 **不必** 发送 `ACK` 包来确认。

1. 在一个已关闭的socket上收到数据
2. 异常终止/异常关闭（如使用 `SO_LINGER` 选项，故意在关闭时发 `RST` 而非 `FIN`，以跳过 `TIME_WAIT`
3. 拒绝连接，如限定本地 IP 地址的服务端接收到非本地的 `SYN` 时

> 一方已经关闭或异常终止而另一方仍未察觉的 `TCP` 连接，称为 **半打开连接**, 常见原因：主机异常；异常终止的一方重启后，若收到 `TCP` 报文，将回复 `RST`

4. 检测，处理 **半打开连接** ：A关闭了连接，B却没有收到结束报文（如网络故障），此时B还维持着原来的连接。A重启之后收到了B发送的报文，则回应RST复位报文。
5. 端口未打开：服务器程序端口未打开而客户端来连接。服务器程序 core dump 之后重启之前连续出现 `RST` 的情况。
6. 端口不存在：若端口不存在，则直接返回 `RST`，同时 `RST` 报文接收通告窗口大小为0.
7. 请求超时：建立连接过程中，一端认为接收超时，即使受到了想要的数据，也会发送 `RST` 拒绝进一步发送数据。

### `TCP` 连接同时打开/关闭

#### 同时打开

`TCP` 设计上会通过4次握手 **成功** 建立连接，但实现上不一定支持

![状态转换](/img/0.png)

#### 同时关闭

4次挥手关闭，最后都进入 `TIME_WAIT`

![状态转换](/img/1.png)

### `TCP` 各阶段状态可能原因及解决

#### TIMEWAIT

> 大量连接处于 `TIME_WAIT` 原因

`TIME_WAIT` 状态说明是主动断开的连接，原因可能是应用所使用的反向代理服务器 (如 nginx) 未设置 `connection: keep-alive`

> 危害

1. 内存占用
2. 端口占用，一个 `TCP` 连接至少消耗 1 个本地端口，用尽则无法创建新连接

> 解决

1. 调整 `net.ipv4.ip_local_port_range` 增大可用的端口数量
2. 复用处于 `TIME_WAIT` 的 `socket`
```conf

# turn on reuse
net.ipv4.tcp_tw_reuse = 1

# make sure tcp timestamps on, default = 1
# 若客户端和服务端主机时间不同步时，客服端发送的消息会直接被拒绝
net.ipv4.tcp_timestamps = 1

```

3. 重置 `TIME_WAIT` 连接

```conf

# 默认为 18000，超过该值后，系统会重置所有的 TIME_WAIT
net.ipv4.tcp_max_tw_buckets = 18000

```

4. 异常关闭连接，跳过 `TIME_WAIT`

```c

struct linger so_linger;
so_linger.l_onoff = 1;
so_linger.l_linger = 0;
// SO_LINGER 使得关闭时发送 RST，而非 FIN
setsockopt(s, SOL_SOCKET, SO_LINGER, &so_linger,sizeof(so_linger));

```

#### CLOSE_WAIT

> 原因

说明应用程序没有合适的关闭 `socket`，既可能是程序写的有问题没有关闭，或者因为 IO，锁陷入睡眠状态，也可能是 CPU 过载，得不到调度

通常来说，一个 `CLOSE_WAIT` 会维持至少2个小时的时间（系统默认超时时间的是7200秒，也就是2小时）。如果服务端程序因某个原因导致系统造成一堆 `CLOSE_WAIT` 消耗资源，那么通常是等不到释放那一刻，系统就已崩溃。

> 解决

解决这个问题的方法还可以通过修改 `TCP/IP` 的参数来缩短这个时间，于是修改tcp_keepalive_*系列参数。
给每一个 `socket` 设置一个时间戳 `last_update`，每接收或者是发送成功数据，就用当前时间更新这个时间戳。定期检查所有的时间戳，如果时间戳与当前时间差值超过一定的阈值，就关闭这个 `socket`。

#### 其他

可以用 `netstat -nat` 命令查看tcp各个状态的数量，哪个端口被占用、套接字的状态、接收缓冲区和发送缓冲区中的数据个数、IP、还有程序名字。

NOTE：

（1）主动端出现大量的 `FIN_WAIT_1` 时需要注意网络是否畅通、出现大量的 `FIN_WAIT_2` 需要仔细检查程序为何迟迟收不到对端的 `FIN`（可能是主动方或者被动方的 bug ）、出现大量的 TIME_WAIT 需要注意系统的并发量/ socket 句柄资源/内存使用/端口号资源等。

（2）被动端出现大量的 CLOSE_WAIT 需要仔细检查为何自己迟迟不愿调用 close 关闭连接（可能是bug，socket打开用完没有关闭）

 
1. LISTENING：侦听来自远方的 TCP 端口的连接请求. 首先服务端需要打开一个 socket 进行监听，状态为 `LISTEN`。TCP 状态变化就是某个端口的状态变化，提供一个服务就打开一个端口。关闭不必要的端口是保证安全的一个非常重要的方面（ DDoS 攻击）。处于侦听 LISTENING 状态时，该端口是开放的，等待连接，但还没有被连接。

2. SYN_SENT（客户端）：客户端通过应用程序 `connect()` 连接时，客户端发送一个SYN以请求建立一个连接，之后状态置为SYN_SENT 。正常情况下 SYN_SENT 状态非常短暂。

如果发现有很多 SYN_SENT 出现，那一般有这么几种情况：

一是你要访问的网站不存在或线路不好，

二是用扫描软件扫描一个网段的机器，也会出现很多 SYN_SENT，

三是可能中了病毒了，例如中了"冲击波"，病毒发作时会扫描其它机器（扫描过程发出了同步请求），这样会有很多 SYN_SENT出现。

3，SYN_RECEIVED（服务端）：当服务器收到客户端发送的同步信号时，将标志位 ACK 和 SYN 置 1 发送给客户端，此时服务器端处 SYN_RCVD 状态，如果连接成功了就变为 ESTABLISHED，正常情况下 SYN_RCVD 状态非常短暂。

如果发现有很多 SYN_RCVD 状态，那你的机器有可能被 `SYN Flood` 的 DoS (拒绝服务攻击)攻击了。这种情况下服务器端一般会重试（再次发送 SYN+ACK 给客户端）并等待一段时间后丢弃这个未完成的连接，这段时间的长度我们称为 SYN Timeout。

4. ESTABLISHED：代表一个打开的连接。

服务器出现很多 ESTABLISHED 状态：当客户端未主动 close 的时候就断开连接（没有正常进行四次挥手断开连接），若客户端断开的时候发送了 FIN 包，则服务端将会处于 CLOSE_WAIT 状态，若断开的时候未发送 FIN 包，则服务端处还是显示 ESTABLISHED 状态。当客户端重新连接服务器的时候，服务端肯定是 ESTABLISHED 状态，如果客户端重复上演这种情况，那么服务端将会出现大量的假的 ESTABLISHED 连接和 CLOSE_WAIT 连接。最终结果就是新的其他客户端无法连接上来，但是利用 netstat 还是能看到一条连接已经建立。


5. FIN-WAIT-1：主动关闭(active close)端应用程序调用close()，于是其 TCP 发出 FIN 请求主动关闭连接，之后进入 FIN_WAIT_1 状态。等待远程 TCP 的连接中断请求，或先前的连接中断请求的确认。

如果服务器（作为主动关闭方？） 出现 shutdown 再重启，使用`netstat -nat` 查看，就会看到很多 `FIN-WAIT-1` 的状态。就是因为服务器当前有很多客户端连接，直接关闭服务器后，无法接收到客户端的 ACK。

6. CLOSE-WAIT：被动关闭 (passive close) 端 TCP 接到 FIN 后，就发出 ACK 以回应 FIN 请求(它的接收也作为文件结束符传递给上层应用程序),并进入 CLOSE_WAIT。

大量 closewait 的原因：代码层面上未对连接进行关闭，比如关闭代码未写在 finally 块关闭，如果程序中发生异常就会跳过关闭代码；程序响应过慢，比如双方进行通讯，当客户端请求服务端迟迟得不到响应，就断开连接，重新发起请求，导致服务端一直忙于业务处理，没空去关闭连接。这种情况也会导致这个问题；

7. FIN-WAIT-2：主动关闭端接到 ACK 后，就进入了FIN-WAIT-2。这就是著名的 **半关闭状态** 了，这是在关闭连接时，客户端和服务器两次握手之后的状态。在这个状态下，应用程序还有接受数据的能力，但是已经无法发送数据，但是也有一种可能是，客户端一直处于 FIN_WAIT_2 状态，而服务器则一直处于 CLOSE_WAIT 状态，而直到应用层来决定关闭这个状态。

8. LAST-ACK：被动关闭端一段时间后，接收到文件结束符的应用程序将调用 close() 关闭连接。这导致它的 TCP 也发送一个  FIN, 等待对方的 ACK. 就进入了 LAST-ACK。

使用并发压力测试的时候，突然断开压力测试客户端，服务器会看到很多 LAST-ACK。

9，TIME-WAIT：在主动关闭端接收到 FIN 后，TCP 就发送 ACK包，并进入 TIME-WAIT 状态。等待足够的时间以确保远程TCP接收到连接中断请求的确认。

这个状态是防止最后一次握手的数据报没有传送到对方那里而准备的（注意这不是四次握手，这是第四次握手的保险状态）。这个状态在很大程度上保证了双方都可以正常结束，但是，问题也来了。

由于插口的 2MSL 状态（插口是 IP 和端口对的意思，socket），使得应用程序在 2MSL 时间内是无法再次使用同一个插口的，对于客户程序还好一些，但是对于服务程序，例如 httpd，它总是要使用同一个端口来进行服务，而在 2MSL 时间内，启动 httpd 就会出现错误（插口被使用）。为了避免这个错误，服务器给出了一个平静时间的概念，这是说在2MSL时间内，虽然可以重新启动服务器，但是这个服务器还是要平静的等待2MSL时间的过去才能进行下一次连接。

10. CLOSED：没有任何连接状态

11. CLOSING 状态：一般较少出现，这种是客户端和服务端同时发起了 FIN 主动关闭。如客户端发送 FIN 主动关闭，但是没有收到服务端发来的 ACK 确认，而是先收到了服务端发来的 FIN 关闭连接，所以必须是同时。

在进入 CLOSING 状态后，只要收到了对方对自己发送的 FIN 的 ACK，收到 FIN 的 ACK 确认就进入 TIME_WAIT 状态，因此，如果 RTT(Round Trip Time TCP包的往返延时)处在一个可接受的范围内，发出的 FIN 会很快被 ACK 从而进入到 TIME_WAIT 状态，CLOSING 状态持续的时间就特别短，因此很难看到这种状态

### `Nagle` 算法

该算法要求一个 `TCP` 连接上最多只能有一个未被确认分未完成的小分组，在该分组的确认之前不能发送其他的小分组

#### 作用

避免小分组 (`tinygram`) 在较慢的广域网上增加拥塞出现的可能，该算法的优越性在于自适应，通过确认的回复速率控制报文的传播速率

#### 弊端

> 即便关闭 `Nagle` 算法，`ACK` 也会延迟发送（累积确认），默认为 200ms
> 更大延迟发送的 TCP 报文进一步影响实时性

### 滑动窗口

![滑动窗口](/img/2.png)

注意：窗口缩小时，右边沿并不（规定不能）向左移动

### 拥塞窗口

为支持 **慢启动** 算法，发送方的 `TCP` 增加了另一个窗口，即 **拥塞窗口**

### `TCP Tahoe` `TCP Reno`

**快速重传** 算法最早出现的 `4.3BSD Tahoe` 版本，`3 Dup ACK` 后错误的使用慢启动；`4.3BSD Reno` 出现了 **快速恢复**

> 快速恢复
> ssthresh = cwnd / 2
> cwnd = ssthresh + 3 * MSS

### `TCP` 坚持定时器

窗口为 0 时，发送方受到抑制，若此时接收方的通告窗口不为 0 的 `ACK` 恰好丢失，将发生死锁，发送方使用 **坚持定时器** 来周期性地向接收方查询窗口是否增大，这种查询窗口的报文称为 **窗口探查**

### 保活机制

```conf

# 7200s 无活动，保活机制启动
net.ipv4.tcp_keepalive_time=7200
# 每次检测间隔 75s
net.ipv4.tcp_keepalive_intvl=75  
# 9次无响应则视为死亡
net.ipv4.tcp_keepalive_probes=9
```

## HTTP

### 范围请求

> [ref](https://juejin.cn/post/6844903642034765837)

1. `HTTP` 范围请求，需要 `HTTP/1.1` 及之上支持，如果双端某一段低于此版本，则认为不支持。
2. 通过响应头中的 `Accept-Ranges`（只有可选参数 `bytes`）来确定是否支持范围请求。
3. 通过在请求头中添加 `Range` 这个请求头，来指定请求的内容实体的字节范围。
4. 在响应头中，状态码为 `206 Partial Content; 416 Range Not Satisfiable`, 通过 `Content-Range` 来标识当前返回的内容实体范围，并使用 `Content-Length` 来标识当前返回的内容实体范围长度。
5. 在请求过程中，可以通过 `If-Range` 来区分资源文件是否变动，它的值来自 `ETag` 或者 `Last-Modifled`。如果资源文件有改动，会重新走下载流程。

![img](/img/13.awebp)

### `cookie`, `session` 的区别

- `cookie` 实际上是一小段的文本信息。浏览器发送请求到服务器，如果服务器需要记录该用户的状态（比如：用户访问网页的次数，登录状态等），就使用 `response` 向客户端浏览器颁发一个 `cookie`。客户端浏览器会把 `cookie` 保存起来。当浏览器再次请求该网站时，浏览器就会把请求地址和 `cookie` 一同给服务器。服务器检查该 `cookie`，从而判断用户的状态。服务器还可以根据需要修改 `cookie` 的内容。

- `session` 也是类似的记录用户状态的机制。不同的是

   1. `cookie` 保存在 **客户端** 浏览器中，而 `session` 保存在 **服务器** 上。
   2. `session` 比 `cookie` **安全**，别人可以分析存放在本地的 `cookie` 并进行 `cookie` 欺骗。
   3. `cookie` 能保存的 **数据量** 比 `session` 小，且 **只能保存字符串**；

#### session 实现

> [ref](https://blog.csdn.net/hongweigg/article/details/38115675)

> session 是保存在服务端的会话信息，使用 `SessionID` 标识

1. `cookie` 可用，直接使用会话 `cookie` 暂存 `SessionID`
2. `cookie` 不可用，使用 `url` 重写将 `SessionID` 告知服务端

## `ref`

- 《 TCP/IP 详解（卷一）》
- [https://mp.weixin.qq.com/s/tH8RFmjrveOmgLvk9hmrkw](https://mp.weixin.qq.com/s/tH8RFmjrveOmgLvk9hmrkw)
- [https://github.com/cosen1024/Java-Interview/blob/main/%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%BD%91%E7%BB%9C/%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%BD%91%E7%BB%9C%E4%B8%8A.md](https://github.com/cosen1024/Java-Interview/blob/main/%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%BD%91%E7%BB%9C/%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%BD%91%E7%BB%9C%E4%B8%8A.md)
- [https://blog.csdn.net/ewq21qwe/article/details/106578463](https://blog.csdn.net/ewq21qwe/article/details/106578463)
- [https://segmentfault.com/a/1190000040786792?utm_source=sf-similar-article](https://segmentfault.com/a/1190000040786792?utm_source=sf-similar-article)
- [https://www.nowcoder.com/questionTerminal/5a2d287965824d3ca93921bf89f8654c](https://www.nowcoder.com/questionTerminal/5a2d287965824d3ca93921bf89f8654c)
- [https://blog.csdn.net/hongweigg/article/details/38115675](https://blog.csdn.net/hongweigg/article/details/38115675)
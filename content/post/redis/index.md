+++
title = "Redis 八股"
date = "2022-03-06T15:45:12+08:00"
author = ""
authorTwitter = "" #do not include @
cover = ""
tags = ["2022-Spring"]
keywords = ["", ""]
description = "对 redis 使用和底层逻辑的一些总结"
showFullContent = false
readingTime = true
+++


# Redis 总结

## Redis 对象系统

1. 便于实现内存回收。为 `C` 这种没有 `GC` 的语言实现了基于 ***** 引用计数 ** 的垃圾回收
2. 对象共享。多个相同的键可以共享同一块内存空间，节约资源

Redis 只对包含整数的字符串进行共享，主要原因在于共享其余更复杂的对象，在缓存的对象池中验证的成本过高，节省的少量空间不抵 CPU 消耗，实际仍是时间和空间的权衡


## Redis 持久化

> **Redis 状态** 指 Redis 中非空的数据库 及 其中的键值对

持久化是指 保存和恢复 Redis 状态
主要有 AOF, RDB 两种

### 载入

没有专门的命令用于载入 `AOF` `RDB` 文件，Redis 会在启动时自动载入，并且 **优先** 载入 AOF 文件（AOF 的更新相对频繁些，丢失的键值对相对较少）

## Redis 分布式锁

### 定义

分布式锁是控制分布式系统或不同系统之间共同访问共享资源的一种锁实现.

### 特征

- 互斥
- 超时释放. 便面死锁
- 可重入. 一个线程在持有锁的情况可以对其再次加锁, 防止锁在线程执行完临界区操作之前释放
- 高性能, 高可用, 低开销

### 单机分布式锁

#### 1.0 SETNX

**使用**

```
SETNX ${key} ${value}
EXPIRE ${key} ${time_in_second}
do sth
DEL ${key}
```

**原理**: `SETNX`: `key` 不存在则设置, 否则不做任何动作

**优点**: 简单
**缺点**: `SETNX`, `EXPIRE` 两条指令实现超时删除, 不为原子操作, 若在两条指令间发生意外, 将死锁


#### v2.0 扩展 SET

**使用**:

```
SET ${key} ${value} NX EX ${expire_time_in_second}
do sth
DEL ${key}
```

**原理**: 同 `SETNX`, 但设置值和设置超时两个动作为原子操作

**问题**:

1. 提前释放: A 执行过程中, 超时, 键被删除, B 成功获得锁
2. 误删: 上一过程中的 A 执行完成后, 仍然删除键, 导致 B 获得的锁被误删

#### v2.1 删除安全的 SET

**解决**:

1. 避免在耗时过长的操作中使用分布式锁; 使用 `Redisson` 续命
2. 将值设置为随机数, 释放锁时检查

**使用**:

```
SET ${key} ${random_value} NX EX ${expire_time_in_second}
do sth
check_key_valid && DEL ${key}
```

**问题**: `check_key_valid` && `DEL ${key}` 不为原子操作

#### v2.2 删除安全的 SET

使用 `LUA` 脚本, 使其原子执行得到保证, (`EVAL`)

```lua
if redis.call("get", KEYS[1]) == ARGV[1] then
    return redis.call("del", KEYS[1])
else
    return 0
end
```

#### v3.0 带 `Redisson` 的分布式锁

**目的**: 解决锁被提前释放的问题

**原理**: 利用锁的可重入特性, 让获得锁的线程开启一个定时器的守护进程, 每 `expireTime/3` 执行一次, 检查该线程的锁是否存在, 存在则重新设置为 `expireTime` 续命, 防止锁由于过期提前释放


### 多机分布式锁 `Redlock`









## ref

- 《Redis 设计与实现》
- [浅析 Redis 分布式锁解决方案](https://www.infoq.cn/article/dvaaj71f4fbqsxmgvdce)
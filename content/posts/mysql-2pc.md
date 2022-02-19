+++
title = "mysql 事务两阶段提交"
date = "2021-12-16T16:03:22+08:00"
author = "resyon"
authorTwitter = "" #do not include @
cover = ""
tags = ["mysql"]
description = ""
showFullContent = false
readingTime = false
draft = false
+++

# Mysql 事务两阶段提交

## overview

> 准确的说是使用`innodb`引擎的`mysql`事务的两阶段提交
> `redo-log`是`innodb`引擎在存储引擎层面实现的

例表
```sql
create table t(
	id int primary key,
	c int
);
```
如下查询
```sql
update `t` set c=c+1 
where `id`=2;
```

有以下过程

![image.png](/upload/2021/12/image-8897670d04f14a109066df3f7d0943d0.png)

## 两阶段提交的必要性

主要是保证`redo-log` 和 `bin-log`的一致性。这种必要性体现在异常恢复上。
由常识我们知道
`redo-log`用于保证事务的`原子性`和`持久性`，记录的是物理日志，由存储引擎实现
`bin-log`用于归档， 记录的逻辑日志，由mysql `server` 层实现

若不保证二者同步更新（不使用两阶段提交，即在二者之一完成之后立即提交事务），将出现以下两种情况

1. `redo-log` -> `commit` -> `bin-log`
若在`commit`和`bin-log`间异常重启，系统能根据`redo-log`恢复事务，`bin-log`于是实际上少了一条记录，这就影响了后续对`bin-log`的使用，如构建从库，恢复到某一检查点

2. `bin-log` -> `commit` -> `redo-log`
若在`commit`和`redo-log`间异常重启，系统无法恢复事务，而`bin-log`多了一条记录，而数据库里实际没有，以后用`bin-log`也会出现与原库不一样的问题


## 总结

`redo-log`和`bin-log`都可以用于表示事务的提交状态，而两阶段提交就是让这两个状态保持逻辑上的一致。


> ref 丁奇《MySQL实战45讲》
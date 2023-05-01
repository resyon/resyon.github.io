+++
title = "UNIX pipeline & file descriptor"
date = "2021-09-11T10:49:41+08:00"
author = "resyon"
authorTwitter = "" #do not include @
cover = ""
tags = ["linux"]
description = ""
showFullContent = false
readingTime = false
draft = false
+++

> 完成`6.s081` lab1 后对`pipeline`, `file descriptor` 有了一定了解，做个笔记

## `pipeline` (`pipe`)
> A `pipe` is a small kernel buffer exposed to processes as a pair of file descriptors, one for reading and one for writing. Writing data to one end of the pipe makes that data available for reading from the other end of the pipe. Pipes provide a way for processes to communicate.

### 使用:
```c
int pd[2];
// make pipeline, return pd[0] for read, pd[1] for write
if(pipe(pd) < 0){
	// handle fail
	fprintf(stderr, "fail to make pipeline\n");
	exit(1);
}

int pid = fork();
if(pid < 0){
	// handle fail
}else if(pid == 0){
	// child
	char cnt = "this is test content from child process";
	write(pd[1], cnt, strlen(cnt));
	exit(0);
}else{
	// parent
	char buf[128];
	// assume that size of content to read would not exceed buf
	read(pd[0], buf, sizeof(buf));
	printf("get buf from child, buf=<%s>\n", buf);
}
```

## `file descriptor` (`fd`)
`fd`是对广义上的`UNIX file`进行引用的一层抽象，这层抽象使得在操作`regular file`, `device`, `pipeline` 等文件时，表面上一致，操作起来简单，(都可使用`read(int fd,..)`; `write(int fd,...)`等透过`fd`的`API`), 但实现上，不同类型的文件大不相同.


### 几个重要的`fd`特性

- 总是自动打开3个`fd`, 0=`stdin` , 1=`stdout`, 2=`stderr`
- 总是选取最小的`fd`
```c
close(1);
int fd = open("/tmp/test.c", O_RDONLY);
fprintf(stderr, "fd=%d\n", fd); // fd=1
```
- `file descriptor table`由进程维护，即进程间`fd`互不影响
> 以下代码来自`lab 1`实验`primes`, 实现了下图所示的`埃氏筛法`
![image.png](/upload/2021/09/image-a50ab1eafdde4f5d8e9516ed77376b38.png)
为摆脱`xv6`对`fd`数目的限制，每个子进程都对管道传入的`fd`进行了多次重定向, 但在子进程改变`fd`并不影响父进程，程序能正常执行

```c
// redirect pd[k] to k, both pd[k] and k are fd
static void redirect(int k, int pd[]){
    close(k);
    dup(pd[k]);
    close(pd[0]);
    close(pd[1]);
}

static void loop(){
    int p, v, pid;
    int pd[2];
    if(read(0, &p, sizeof(int))){
        printf("prime %d\n", p);
        pipe(pd);
	pid = fork();
	if(pid < 0){
	    fprintf(stderr, "fail to fork, current pid=%d\n", getpid());
	    return;
	}else if(pid > 0){
            redirect(0, pd);
            loop();
        }else{
            redirect(1, pd);
            while(read(0, &v, sizeof(int))){
                if(v % p != 0){
                    write(1, &v, sizeof(int));
                }
            }
        }
    }
}

int main(){
    int p[2];
    pipe(p);
    if(fork()>0){
        redirect(0, p);
        loop();
    }else{
        redirect(1, p);
        for(int i=2; i<35;++i){
            write(1, &i, sizeof(int));
        }
    }
    exit(0);
}
```

- 经由`fork`和`dup`得到，的对同一文件的`fd`, 它们共享偏移

> fork
```c
if(fork() == 0){
	fprintf(stdout, "hello ");
	exit(0);
}else{
	wait((int*)0); // wait child exit
	fprintf(stdout, "world\n");
	exit(0);
}

// always get
// "hello world\n"
```

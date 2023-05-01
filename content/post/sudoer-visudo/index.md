+++
title = "Editor for /etc/sudoer"
date = "2021-08-14T14:26:34+08:00"
author = "resyon"
authorTwitter = "" #do not include @
cover = ""
tags = ["linux"]
description = ""
showFullContent = false
readingTime = false
draft = false
+++

新建用户，添加至sudo的若干步骤

```bash
usermod -aG root username
```
这时候，我在debian上依旧不行
(这是因为`/etc/sudoer`的配置中，并没有指定`root`用户组中的成员都可以使用`sudo`)
```bash
adduser useradd root
```
还是没用，选择直接编辑`/etc/sudoer`,
注意到这个文件的权限
![image.png](/upload/2021/08/image-45acfb1b60e347239b1a19eaf23609bf.png)
通常使用`sudoedit`进行编辑， 这个时候如果出现语法错误，会非常蛋疼，查了[资料](https://askubuntu.com/questions/73864/how-to-modify-an-invalid-etc-sudoers-file)后发现，
`visudo`是个更好的选择，`visudo`不会在`/etc/sudoer`语法错误时拒绝编辑该文件，还会在保存后语法错误时提示重新编辑
![image.png](2)
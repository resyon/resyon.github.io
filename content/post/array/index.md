+++
title = "数组"
date = "2021-05-21T07:56:13+08:00"
author = "resyon"
authorTwitter = "" #do not include @
cover = ""
tags = ["algorithm"]
description = ""
showFullContent = false
readingTime = false
draft = false
+++

## [binary-search](https://leetcode-cn.com/problems/binary-search/)
```cpp
#include<vector>
using namespace std;

int search(vector<int>& nums, int target) {
	int i = 0, j = nums.size()-1; //这里的类型别用auto, 否则后续
                                //mid - 1 可能溢出
    int mid;
	while (i <= j) {
		mid = (i + j ) / 2;
		if (nums[mid] == target) {
			return mid;
		}else if (nums[mid] > target)	j = mid-1; //注意此处 -1
		else i = mid+1; //以及此处 + 1
        //否则容易陷入死循环
	}
	return -1;
}
```
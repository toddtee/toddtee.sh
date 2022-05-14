---
title: Defanging Malicious IP Addresses
description: 'Take a bite out of malicious links!'
date: 2020-03-26
author: Todd Turner
categories: ['LeetCode', 'Python']
tags: ['leetcode', 'python']
slug: 'defanging-malicious-ip-addresses'
---

## How to Take the Bite Out Of Malicious Links

[Leetcode problem #1108](https://leetcode.com/problems/defanging-an-ip-address/) involved writing a quite method to _"defang"_ ip addresses. The problem was
simple enough (answer is further down), however I was intrigued to find out more about IP defanging.
I have been working in the technology sector for three years and I had never heard the term.
All due respect, I may have been under a rock?

I wasn't able to find too much on the topic, however, [some good documentation from
IBM](https://www.ibm.com/support/knowledgecenter/en/SSBRUQ_32.0.0/com.ibm.resilient.doc/install/resilient_install_defangURLs.htm)
answered my question.

Essentially, when handling artifacts (contents) from an email or just generally passing data blobs
which contain IP addresses, URLS or domains, we can "defang" them from accidental user-navigation by
obscuring the address by messing it up a bit. Messing the adddress will ensure automatic
click-through links don't action.

### What Are Some Defanging Methods?
The following are some accepted methods for defanging addresses:
* IP Addresses have brackets added to the dot separators: _8.8.8.8_ -> _8[.]8[.]8[.]8_
* Domains have brackets added to the dot separators: _www.toddtee.sh_ -> _www[.]toddtee[.]sh_
* _http_ / _https_ converted to _hxxp_ / _hxxps_
* _ftp_ converted to _fxp_

## How Could We Quickly Defang With Python
The leetcode question simply wants to take an input IP address and return it in a defanged format.

I first attempted this question without using any string methods. And _WOW_;
was it UGLY!!! But... you know what... it worked!

![You Ugly!](https://media.giphy.com/media/13O8lsCUU4jTuU/giphy.gif)

```python
class Solution:
  def defangIPaddr(self, address: str) -> str:
    split_ip_chars = []
    defanged_ip = ""
    for char in address:
      if char != ".":
        split_ip_chars.append(char)
      elif char == ".":
        split_ip_chars.append("[.]")

    for char in split_ip_chars:
      defanged_ip = defanged_ip+char

    return defanged_ip
```
### A Simple Way

Good software developers write as little code as possible; and when forced to, they keep the code
simple and clean. The simpler way to defang would be to use string methods `split()` and `join()`:

```python
class Solution:  
  def defangIPaddr(self, address: str) -> str:
    return "[.]".join(address.split("."))
```

So this is a much simpler way of solving the issue; first we split the address on the dot seperators
and then return the split array joined by the bracketed dots.

This is great, however I think we can write this even cleaner (and human friendly).

### A Human Way
I personally prefer solving this issue with the `replace()` method. It is simple and even easier to
read; so I am assuming 9/10 humans would prefer this way:

```python
class Solution:  
  def defangIPaddr(self, address: str) -> str:
    return address.replace(".", "[.]")
```

That is my preferred method... keep it reeeeeeal simple.

![Simple Math](https://media.giphy.com/media/hsC2oDP99cnJbxq5M5/giphy.gif)


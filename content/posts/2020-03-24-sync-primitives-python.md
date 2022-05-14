---
title: Synchronisation Primitives in Python
description: 'Managing Concurrency in Python'
date: 2020-03-24
author: Todd Turner
categories: ['LeetCode', 'Python']
tags: ['leetcode', 'python', 'concurrency']
slug: 'synchronization-primitives-in-python'
---

## Intent 
I am going to time-box writing everything I know about Python multi-threading Synchronisation.
Essentially when multi-threading, programs need a way to prevent race-conditions, especially when
shared resources are being referenced between the threads. All sorts of weird stuff can happen if we
don't synchronise our threads up.

## A Synchro-What?
A **_synchronisation primitive_** is a super fancy description for:

_"A thing you can use to prevent race conditions when multi-threading."_

Ahhh... I see...

![I see...](https://media.giphy.com/media/a5viI92PAF89q/giphy.gif)

Python probably has a bunch of these, however I will write about the ones I know about:

1. Locks (and RLocks)
2. Barriers
3. Semaphores
4. Events
5. Conditions

Here we go!

---
## Problem Definition

Let's say we have a random object that has three methods that print _"first"_, _"second"_ and
_"third"_ respectively:

```java
public class Foo {
  public void first() { print("first"); }
  public void second() { print("second"); }
  public void third() { print("third"); }
}
```
If the same object was passed to three threads, and each thread executed each thread in a random
order; how could we ensure that `first()` always executed first, followed by `second()` and
`third()` respectively?

Please reference the leetcode problem titled [#1114 - Print In
Order](https://leetcode.com/problems/print-in-order/). to get an idea of what I am talking about.

## Use Synchronisation Primitives (Duh?!)

We can tackle this problem using every primitive I mentioned in the above section.

### 1. Use a Lock

Locks work by essentially that... they lock things. 

#### To use a lock:

1. Create a lock object.
2. Lock the lock object with its `acquire()` method.
3. Release the lock with `release()`.

If any competing threads tries to _acquire_ this lock object; it automatically becomes blocked, until
such time that the lock is _released_. Let's see this in action:

```python
from threading import Lock

class Foo:
    def __init__(self):
      #create two locks
        self.locks = [Lock(), Lock()]
      #set both locks to the "locked" state
        for lock in self.locks:
          lock.acquire()
        
    def first(self, printFirst: 'Callable[[], None]') -> None:
      #no need to lock this bad-boy... we want this to be first to run  
        printFirst()
      #release the first lock so second() can now be unblocked
        self.locks[0].release()

    def second(self, printSecond: 'Callable[[], None]') -> None:
      with self.locks[0]:
        printSecond()
      #release the second lock so third() can now be unblocked
        self.locks[1].release()

    def third(self, printThird: 'Callable[[], None]') -> None:
      with self.locks[1]:
        printThird()
        self.locks[1].release() #not required for problem, but clean if this were real
```

Essentially, the methods aren't released until the required preceding method releases the lock.

One draw back to Locks is they are so dumb, it doesn't care which thread "owns" the lock; it will
block whoever tries to `acquire()` a locked-lock. EVEN ITSELF! 

![Spiderman pointing meme](/img/synchronization-primitives-in-python/spiderman-meme.png)

To prevent this, use a `RLock()` lock instead as this can be called aquired multiple times by the
same thread. I won't go into this, just trust me (or better yet the docs.)

### 2. Use a Barrier

Barriers are essentially counters... they block a thread until a certain number of `wait()` methods
have been called on that object.

Tackling our original problem again, we require that each barrier has `2` _waits_ called on it,
before unblocking the thread:

```python
from threading import Barrier

class Foo:
    def __init__(self):
        self.barrier1 = Barrier(2)
        self.barrier2 = Barrier(2)
        
    def first(self, printFirst: 'Callable[[], None]') -> None:
        
        printFirst()
        self.barrier1.wait()

    def second(self, printSecond: 'Callable[[], None]') -> None:
        
        self.barrier1.wait()
        printSecond()
        self.barrier2.wait()

    def third(self, printThird: 'Callable[[], None]') -> None:
        
        self.barrier2.wait()
        printThird()
```

### 3. Use a Semaphore
Semaphore is just a another form of counter; similar to barrier, except a bit smarter.
The semaphore object is created with a counter, which represents how many _acquires_ can be called
on it before it blocks. When the counter hits "0", it blocks. The semaphore keeps track of this
number, and even counts the running total upwards when _releases_ are called against it. 

For example, this semaphore will block after _acquire_ is called 3 times against it.
`my_semaphore = threading.Semaphore(3)`

These are great for rate setting or connection limiting applications.

In our problem, we can be tricky and set it to block at 0! This treats it essentially like a lock.

```python
from threading import Semaphore 

class Foo:
    def __init__(self):
      #create two locks
        self.semaphores = [Semaphore(0), Semaphore(0]

    def first(self, printFirst: 'Callable[[], None]') -> None:
        
        printFirst()
        self.semaphores[0].release()

    def second(self, printSecond: 'Callable[[], None]') -> None:
      
      with semaphores[0]:
        printSecond()
        self.locks[1].release()

    def third(self, printThird: 'Callable[[], None]') -> None:
      
      with self.semaphores[1]:
        printThird()
```

### 4. Use an Event
Yep, an event. This means that when an event occurs, any thread waiting for that event may now
proceed! An event has said to have "occured" once a `set()` method has been called on it.

```python
from threading import Event

class Foo:
    def __init__(self):
      #create two locks
        self.events = [Event(), Event()]

    def first(self, printFirst: 'Callable[[], None]') -> None:
        
        printFirst()
        self.event[0].set()

    def second(self, printSecond: 'Callable[[], None]') -> None:
      #wait for the first event to finish
      self.events[0].wait()
      
      printSecond()
      self.event[1].set()

    def third(self, printThird: 'Callable[[], None]') -> None:
      
      self.events[1].wait()
        printThird()
```

### 5. Use a Condition

Love locks? Love events? Which you could marry those two things together? Threadings got you fam!
Welcome to conditions! Combines both the goodness of locks with the power of events. 

Create a _Condition_ object which will can be aquired by all threads. When created, the _Condition_
object has an underlying _RLock_ attached.

Create a couple of conditions that we require to be `True` (in our example, has the Print been
called yet?) and have the threads wait for their corresponding condition:

```python
from threading import Condition

class Foo:
    def __init__(self):
      #create a Condition object
        self.the_condition = threading.condition()
      #create an int to track where the print is at
        self.order = 0
      # create two variables that return True once the print order changes
        self.first_done = lambda: self.order == 1
        self.second_done = lambda: self.order == 2

    def first(self, printFirst: 'Callable[[], None]') -> None:
      with self.the_condition:
        printFirst()
        self.order = 1
        self.the_condition.notify(2) #notify the two waiting threads to check their condition
      
    def second(self, printSecond: 'Callable[[], None]') -> None:
      with self.the_condition:
        self.the_condition.wait_for(self.first_done)
        printSecond()
        self.order = 2
        self.the_condition.notify() #notify the one other waiting thread to check the waiting status
      
    def third(self, printThird: 'Callable[[], None]') -> None:
      with self.the_condition:
        self.the_condition.wait_for(self.second_done)
        printThird()
```

## And There We Have It!

_Synchronisation Primitives_; scary name, not so scary concept when you step it out. 
Please reach out to me if you have any questions!

![Twisting Threads](https://media.giphy.com/media/xUOxeVqODu1FpVMJvq/giphy.gif)
# ZXKVStore

ZXKVStore is an Key-vlaue database written in Swift.The data stored on disk from FMDB.

[My homepage ](http://www.zhangxi.me)

## Features

- [√] key-value store
- [√] counter
- [√] switch


## Requirements

- iOS 7.0+ / Mac OS X 10.9+
- Xcode 6.4



## Installation

> To use ZXKVStore with a project targeting iOS 7, you must include FMDB in your project. 

1. Import FMDB (it is recommended to use Cocoapods.)
2. If you don't have an bridging header file,create one.(Because FMDB is writen in Objective-C.)
3. Drag the ZXKVStore.swift into your project
 


## Usage

### key-value store

```swift
println(ZXKV["homepage"]) //nil        
ZXKV["homepage"] = "http://www.zhangxi.me"  // store a value to the key
println(ZXKV["homepage"]) //http://www.zhangxi.me

let array = ["abc","123"]
ZXKV["array"] = array
println(ZXKV["array"])  //["abc","123"]

//any object which implemented NSCoding can be stored.
```

### Search
```swift

ZXKV.prefix("100") //Return Array<(key:String,value:AnyObject)> which key begins with prefix("100")

ZXKV.surfix("zx") //Return Array<(key:String,value:AnyObject)> which key ends with surfix("zx")

ZXKV.glob("*zx")  //Return Array<(key:String,value:AnyObject)> [GLOB](http://www.runoob.com/sqlite/sqlite-glob-clause.html)
ZXKV.like("%zx")  //Return Array<(key:String,value:AnyObject)> [LIKE](http://www.runoob.com/sqlite/sqlite-like-clause.html)


ZXKV.first()  //first inserted object
ZXKV.last()   //last inserted object

```
### Counter

```swift

println(ZXKV.count("key"))       //0
println(ZXKV.increase("key"))    //1
ZXKV.setCount("key", value: 10)  //10
println(ZXKV.count("key"))       //10
println(ZXKV.decrease("key"))    //9
println(ZXKV.count("key"))       //9

```

### Switch

```swift

println(ZXKV.switchState("key"))                   // nil
println(ZXKV.switchOn("key"))                      //true,means switch on sucess
println(ZXKV.switchState("key"))                   //true,the state is true
println(ZXKV.switchOff("key"))                     //true,means switch off success
println(ZXKV.switchState("key"))                   //false,means the state is false
println(ZXKV.setSwitchState("key", value: true))   //true,set the state to true,sucess
println(ZXKV.switchState("key"))                   //true,the state is true

```


* * *

## FAQ

### When should I use ZXKVStore?

If you're starting a new project in Swift, and just use swift in your old project.You may want to store some data.How? SQLite ? CoreData ? NSUserDefault ? All of this is ok.But you still have another choice , ZXKVStore.It's very light,just drag the ZXKVStore.swift to your project and ZXKV["key"] = value.



### When should I use ZXKVStore?

When you want to store data.

### What's the origin of the name ZXKVStore?

ZXKVStore mean ZhangXi Key-value store.I'm zhangxi.

* * *


## License

ZXKVStore is released under the MIT license. See LICENSE for details.

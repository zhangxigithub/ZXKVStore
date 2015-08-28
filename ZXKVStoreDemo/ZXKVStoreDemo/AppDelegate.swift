//
//  AppDelegate.swift
//  ZXKVStoreDemo
//
//  Created by zhangxi on 8/25/15.
//  Copyright (c) 2015 zhangxi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        
        ZXKV.clean() //clean all data
        
        
        //store string
        
        println(ZXKV["homepage"]) //nil
       
        ZXKV["homepage"] = "http://www.zhangxi.me"
        println(ZXKV["homepage"]) //http://www.zhangxi.me
        
        
        ZXKV["homepage"] = "https://github.com/zhangxigithub/ZXKVStore"
        println(ZXKV["homepage"]) //https://github.com/zhangxigithub/ZXKVStore
        

        ZXKV["homepage"] = nil
        println(ZXKV["homepage"]) //nil
        
        //store array
        
        let array = ["abc","123"]
        ZXKV["array"] = array
        println(ZXKV["array"])  //["abc","123"]
        
        
        //store object,the object must be implemented NSCoding
        
        let obj = Object(name: "ZXKVStore")
        ZXKV["obj"] = obj
        let newObj = ZXKV["obj"] as? Object
        println(newObj?.name)
        
        
        "dd".hasPrefix("")
        "dd".hasSuffix("")
        
        
        //search with prefix
        ZXKV["1001zx"] = "1"
        ZXKV["1002zx"] = "2"
        ZXKV["1003zx"] = "3"
        ZXKV["1001ZX"] = "4"
        ZXKV["1002ZX"] = "5"
        ZXKV["1003ZX"] = "6"

        println("ZXKV.prefix(\"100\")")
        for s in ZXKV.prefix("100")
        {
            println(s)
        }
        
        println("ZXKV.surfix(\"100\")")
        for s in ZXKV.surfix("zx")
        {
            println(s)
        }
        

        println("ZXKV.glob(\"*zx\")")
        for s in ZXKV.glob("*zx")
        {
            println(s)
        }
        
        println("ZXKV.like(\"%zx\")")
        for s in ZXKV.like("%zx")
        {
            println(s)
        }
        
        
        println(ZXKV.first())
        println(ZXKV.last())
        
        
        println("Counter ======================")
        println(ZXKV.count("zhangxi"))
        println(ZXKV.increase("zhangxi"))
        ZXKV.setCount("zhangxi", value: 10)
        println(ZXKV.count("zhangxi"))
        println(ZXKV.decrease("zhangxi"))
        println(ZXKV.count("zhangxi"))
        
        
        
        println("Switch======================")
        println(ZXKV.switchState("zhangxi"))
        println(ZXKV.setSwitchState("zhangxi", value: true))
        println(ZXKV.switchState("zhangxi"))
        
        
        println(ZXKV.switchOn("zhangxi"))
        println(ZXKV.switchState("zhangxi"))
        println(ZXKV.switchOff("zhangxi"))
        println(ZXKV.switchState("zhangxi"))
        println(ZXKV.setSwitchState("zhangxi", value: true))
        println(ZXKV.switchState("zhangxi"))

        
        return true
    }


}


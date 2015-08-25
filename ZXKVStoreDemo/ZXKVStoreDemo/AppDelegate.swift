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
        
        
        //store array
        
        let array = ["abc","123"]
        ZXKV["array"] = array
        println(ZXKV["array"])  //["abc","123"]
        
        
        //store object,the object must be implemented NSCoding
        
        let obj = Object(name: "ZXKVStore")
        ZXKV["obj"] = obj
        let newObj = ZXKV["obj"] as? Object
        println(newObj?.name)
        
        
        
        
        return true
    }


}


//
//  ZXKVStore.swift
//  
//
//  Created by zhangxi on 8/25/15.
//
//
/*
usage:

ZXKV["key"] = "value"
let string = ZXKV["key"]  //string = value

*/
import UIKit

let ZXKV = ZXKVStore.sharedStore

class ZXKVStore: NSObject {
 
    let db:FMDatabase!

    
    class var sharedStore: ZXKVStore {
        dispatch_once(&Inner.token) {
            Inner.instance = ZXKVStore()
        }
        return Inner.instance!
    }
    struct Inner {
        static var instance: ZXKVStore?
        static var token: dispatch_once_t = 0
    }
    
    override init() {
        
        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        var filePath = path.stringByAppendingPathComponent("ZXKVStore.db")
        db = FMDatabase(path: filePath)
        

        
        if db.open() == false
        {
            println(db.lastErrorMessage())
        }else
        {
            println("init ZXKVStore db....ok")
        }
        

        
        let creatTable = "create table ZXKVStore (id integer primary key autoincrement, k text,v blob);"
        if db.executeStatements(creatTable)
        {
            println("init ZXKVStore table....ok")
        }else
        {
            println(db.lastErrorMessage())
        }
        
    }
    
    func clean()
    {
        if db.executeStatements("truncate table ZXKVStore;")
        {
            println("truncate ....ok")
        }else
        {
            println(db.lastErrorMessage())
        }
    }
    
    
    subscript(key: String) -> AnyObject?
        {
        get
        {
            return getObject(key)
        }
        set(obj)
        {
            saveObject(obj, key: key)
        }
    }

    
    
    func saveObject(obj:AnyObject?,key:String) -> Bool
    {
        if obj == nil
        {
            println("obj is nil")
            return false
        }
        
        let rs = db.executeQuery("select * from ZXKVStore where k = ?;", withArgumentsInArray: [key])
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(obj!)
        
        if rs.next()
        {

            if db.executeUpdate("update ZXKVStore set v = ? where k = ?", withArgumentsInArray: [data,key]) == true
            {
                return true
            }else
            {
                println("store ....fail",db.lastErrorMessage())
                return false
            }
            
        }else
        {
            if db.executeUpdate("insert into ZXKVStore (k,v) values (?,?)", withArgumentsInArray: [key,data]) == true
            {
                return true
            }else
            {
                println("store ....fail",db.lastErrorMessage())
                return false
            }
        }
    }
    func getObject(key:String) -> AnyObject?
    {
        if let rs = db.executeQuery("select * from ZXKVStore where k = ?;", withArgumentsInArray: [key])
        {
            let result = rs.next()
            
            if result == true
            {
                let data: AnyObject? = rs.dataForColumn("v")
                return NSKeyedUnarchiver.unarchiveObjectWithData(data! as! NSData)

            }else
            {
                println(db.lastErrorMessage())
                return nil
            }
            
        }else
        {
            println(db.lastErrorMessage())
            return nil
        }
    }
    
    
    
}

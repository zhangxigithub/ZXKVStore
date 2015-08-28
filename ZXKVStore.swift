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


import Foundation


let ZXKV = ZXKVStore.sharedStore

enum ZXKVType
{
    case KeyValue
    case Counter
    case Switch
    
    
    func creatSQL() -> String
    {
        switch self
        {
        case .KeyValue: return "CREATE TABLE IF NOT EXISTS ZXKVStore (id integer primary key autoincrement, k text,v blob);"
        case .Counter : return "CREATE TABLE IF NOT EXISTS ZXKVCounter (id integer primary key autoincrement, k text,v INTEGER);"
        case .Switch  : return "CREATE TABLE IF NOT EXISTS ZXKVSwitch (id integer primary key autoincrement, k text,v INTEGER);"
        }
    }
    func cleanSQL() -> String
    {
        switch self
        {
        case .KeyValue: return "delete from ZXKVStore;"
        case .Counter : return "delete from ZXKVCounter;"
        case .Switch  : return "delete from ZXKVSwitch;"
        }
    }
}

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
            println("init   ZXKVStore db ....... ok")
        }
        
        
        for item in [ZXKVType.KeyValue,ZXKVType.Counter,ZXKVType.Switch]
        {
            if db.executeStatements(item.creatSQL())
            {
                println("\(item.creatSQL()).... ok")
            }else
            {
                println(db.lastErrorMessage())
            }
        }
    }
    
    func clean(type:ZXKVType = ZXKVType.KeyValue)
    {
        if db.executeStatements(type.cleanSQL())
        {
            println("\(type.cleanSQL()) .......... ok")
        }else
        {
            println(db.lastErrorMessage())
        }
    }
    
    
    //MARK: - Key-value store
    func prefix(prefix:String) -> Array<(key:String,value:AnyObject)>
    {
        return glob("\(prefix)*")
    }
    func surfix(surfix:String) -> Array<(key:String,value:AnyObject)>
    {
        return glob("*\(surfix)")
    }
    func first() -> (key:String,value:AnyObject)?
    {
        let sql = String(format:"select * from ZXKVStore order by id limit 1;", arguments: [])
        let array = search(sql)
        if array.count == 1
        {
            return array.first
        }
        return nil
    }
    func last() -> (key:String,value:AnyObject)?
    {
        let sql = String(format:"select * from ZXKVStore order by id desc limit 1;", arguments: [])
        let array = search(sql)
        if array.count == 1
        {
            return array.first
        }
        return nil
    }
    func glob(s:String) -> Array<(key:String,value:AnyObject)>
    {
        let sql = String(format:"select * from ZXKVStore where k GLOB '%@';", arguments: [s])
        return search(sql)
    }
    
    func like(s:String) -> Array<(key:String,value:AnyObject)>
    {
        let sql = String(format:"select * from ZXKVStore where k LIKE '%@';", arguments: [s])
        return search(sql)
    }
    
    func search(sql:String) -> Array<(key:String,value:AnyObject)>
    {
        var result:[(key:String,value:AnyObject)] = []
        
        let rs = db.executeQuery(sql, withArgumentsInArray: [])
        
        while rs.next()
        {
            let data: AnyObject? = rs.dataForColumn("v")
            if data != nil
            {
                let obj: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data! as! NSData)
                if obj != nil
                {
                    result.append((key:rs.stringForColumn("k")!,value:obj!))
                }
            }
        }
        return result
    }
    
    
    
    func saveObject(obj:AnyObject?,key:String) -> Bool
    {
        if obj == nil
        {
           return db.executeUpdate("delete from ZXKVStore where k = ?;", withArgumentsInArray: [key])
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
        if let rs = db.executeQuery("select * from ZXKVStore where k = ? limit 1;", withArgumentsInArray: [key])
        {
            let result = rs.next()
            
            if result == true
            {
                let data: AnyObject? = rs.dataForColumn("v")
                return NSKeyedUnarchiver.unarchiveObjectWithData(data! as! NSData)
                
            }else
            {
                return nil
            }
            
        }else
        {
            return nil
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
    
    
    
    
    
    
    
    
    //MARK: - counter
    func count(key:String) -> Int
    {
        let k = "ZXKVCounter.\(key)"
        if let rs = db.executeQuery("select * from ZXKVCounter where k = ? limit 1;", withArgumentsInArray: [k])
        {
            let result = rs.next()
            
            if result == true
            {
                return Int(rs.intForColumn("v"))
            }else
            {
                return 0
            }
            
        }else
        {
            return 0
        }
    }
    func setCount(key:String,value:Int) -> Bool
    {
        let k = "ZXKVCounter.\(key)"
        
        let rs = db.executeQuery("select * from ZXKVCounter where k = ?;", withArgumentsInArray: [k])
        
        if rs.next()
        {
            if db.executeUpdate("update ZXKVCounter set v = ? where k = ?", withArgumentsInArray: [value,k]) == true
            {
                return true
            }else
            {
                println("store ....fail",db.lastErrorMessage())
                return false
            }
            
        }else
        {
            if db.executeUpdate("insert into ZXKVCounter (k,v) values (?,?)", withArgumentsInArray: [k,value]) == true
            {
                return true
            }else
            {
                println("store ....fail",db.lastErrorMessage())
                return false
            }
        }
    }
    
    func increase(key:String) -> Int
    {
        var v = count(key)
        v++
        setCount(key, value: v)
        return v
    }
    func decrease(key:String) -> Int
    {
        var v = count(key)
        v--
        setCount(key, value: v)
        return v
    }
    
    
    
    //MARK: - switch
    
    func switchState(key:String) -> Bool?
    {
        let k = "ZXKVSwitch.\(key)"
        if let rs = db.executeQuery("select * from ZXKVSwitch where k = ? limit 1;", withArgumentsInArray: [k])
        {
            let result = rs.next()
            
            if result == true
            {
                return Bool(rs.boolForColumn("v"))
            }else
            {
                return nil
            }
        }else
        {
            return nil
        }
    }
    func setSwitchState(key:String,value:Bool?) -> Bool
    {
        let k = "ZXKVSwitch.\(key)"
        
        if value == nil
        {
            return db.executeUpdate("delete from ZXKVSwitch where k = ?;", withArgumentsInArray: [key])
        }
        
        
        let rs = db.executeQuery("select * from ZXKVSwitch where k = ?;", withArgumentsInArray: [k])
        
        if rs.next()
        {
            if db.executeUpdate("update ZXKVSwitch set v = ? where k = ?", withArgumentsInArray: [value!,k]) == true
            {
                return true
            }else
            {
                println("store ....fail",db.lastErrorMessage())
                return false
            }
            
        }else
        {
            if db.executeUpdate("insert into ZXKVSwitch (k,v) values (?,?)", withArgumentsInArray: [k,value!]) == true
            {
                return true
            }else
            {
                println("store ....fail",db.lastErrorMessage())
                return false
            }
        }
    }
    func switchOn(key:String) -> Bool
    {
       return setSwitchState(key, value: true)
    }
    func switchOff(key:String) -> Bool
    {
        return setSwitchState(key, value: false)
    }
}

//
//  PlanItem.swift
//  
//
//  Created by zhangxi on 8/25/15.
//
//

import UIKit



class Object: NSObject,NSCoding {
    
    var name:String!

    convenience init(name:String)
    {
        self.init()
        self.name  = name
    }

    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(name, forKey: "name")
    }
    
    convenience required init(coder aDecoder: NSCoder)
    {
        self.init()
        self.name = aDecoder.decodeObjectForKey("name") as! String
    }
 
}




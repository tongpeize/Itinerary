//
//  Storage.swift
//  Itinerary
//
//  Created by 佟 佩泽 on 16/8/1.
//  Copyright © 2016年 佟佩泽. All rights reserved.
//

import UIKit
import RealmSwift


class Destination: Object {
    dynamic var order = 0
    dynamic var city : City?
    dynamic var departTime : NSDate? = nil
    dynamic var transport = 0 //0:飞机 1:火车
    dynamic var hotel : Hotel?
    
    override static func primaryKey() -> String? {
        return "order"
    }
}

class Hotel: Object {
    dynamic var name = ""
    dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class City: Object {
    dynamic var name = ""
    dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Destination {
    var nextCity : City? {
        switch self.order {
        case -1:
            return nil
        case store.objects(Destination).max("order")!:
            return store.objectForPrimaryKey(Destination.self, key: -1)?.city
        default:
            let objs = store.objects(Destination).sorted("order")
            let index = objs.indexOf(self)
            return objs[index! + 1].city
        }
    }
    
    var arriveTime : NSDate? {
        if let des = store.objectForPrimaryKey(Destination.self, key: self.order - 1) {
            return des.departTime
        }else {
            return nil
        }
    }
}
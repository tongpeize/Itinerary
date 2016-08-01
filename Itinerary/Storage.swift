//
//  Storage.swift
//  Itinerary
//
//  Created by 佟 佩泽 on 16/8/1.
//  Copyright © 2016年 佟佩泽. All rights reserved.
//

import UIKit
import RealmSwift

class Route: Object {
    let destinations = List<Destination>()
    dynamic var final : City?
}

class Destination: Object {
    dynamic var order = 0
    dynamic var city : City?
    let route = LinkingObjects(fromType: Route.self, property: "destinations")
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
    var lastCity : City? {
        if self.order == 0 {
            return nil
        }else {
            return self.route.first!.destinations[self.order - 1].city
        }
    }
    
    var nextCity : City? {
        let c = self.route.first!.destinations.count
        if self.order == c-1 {
            return self.route.first!.final
        }else {
            return self.route.first!.destinations[self.order + 1].city
        }
    }
    
    var arriveTime : NSDate? {
        if self.order == 0 {
            return nil
        }else {
            return self.route.first!.destinations[self.order - 1].departTime
        }
    }
}
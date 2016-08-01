//
//  AppDelegate.swift
//  Itinerary
//
//  Created by 佟佩泽 on 16/7/29.
//  Copyright © 2016年 佟佩泽. All rights reserved.
//

import UIKit
import RealmSwift

let store = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //let cities = ["北京", "上海", "广州", "深圳", "呼和浩特", "长沙", "厦门", "苏州", "杭州"]
        //let hotels = ["手撕牛肉大酒店", "乡村爱情主题情侣酒店", "Pokemon Go主题酒店", "如家快捷酒店", "魔兽世界点卡改月卡大酒店"]
        
        
//        try! store.write {
//            store.deleteAll()
//            
//            for (index,name) in cities.enumerate() {
//                let city = City()
//                city.name = name
//                city.id = index
//                store.add(city, update: true)
//            }
//            
//            for (index,name) in hotels.enumerate() {
//                let hotel = Hotel()
//                hotel.name = name
//                hotel.id = index
//                store.add(hotel, update: true)
//            }
//        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


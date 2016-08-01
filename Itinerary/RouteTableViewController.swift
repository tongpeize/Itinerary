//
//  RouteTableViewController.swift
//  Itinerary
//
//  Created by 佟佩泽 on 16/8/1.
//  Copyright © 2016年 佟佩泽. All rights reserved.
//

import UIKit
import RealmSwift

class RouteTableViewController: UITableViewController {
    
    var token: NotificationToken?
    var route = store.objects(Route).first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if route == nil {
            print("nnnnnn")
            let org = Destination()
            org.order = 0
            org.city = store.objects(City).first
            let r = Route()
            r.destinations.append(org)
            r.final = store.objects(City).first
            try! store.write {
                store.add(r)
            }
        }
        
        token = store.addNotificationBlock{ _ in
            self.tableView.reloadData()
        }
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (route?.destinations.count ?? 1) + 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case tableView.numberOfSections - 1:
            return 2
        case 0:
            return tableView.numberOfSections == 2 ? 1 : 2
        default:
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("CityCell") as! CityCell
            cell.cityName.text = route?.final?.name ?? "请选择城市"
            cell.bgIMG.image = UIImage(named: "origin")
            return cell
        case (0..<(tableView.numberOfSections - 1), 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("CityCell") as! CityCell
            cell.cityName.text = route?.final?.name ?? "请选择城市"
            return cell
        case (tableView.numberOfSections - 1, 1):
            let cell = tableView.dequeueReusableCellWithIdentifier("CityCell") as! CityCell
            cell.cityName.text = route?.final?.name ?? "请选择城市"
            cell.bgIMG.image = UIImage(named: "final")
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCellWithIdentifier("FlightCell") as! FlightCell
            cell.destination = route?.destinations[0]
            return cell
        case (_, 2):
            let cell = tableView.dequeueReusableCellWithIdentifier("FlightCell") as! FlightCell
            cell.destination = route?.destinations[indexPath.section]
            return cell
        case (tableView.numberOfSections - 1, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("AddCell") as! AddCell
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("HotelCell") as! HotelCell
            cell.hotel = route?.destinations[indexPath.section].hotel
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 18 : 0.1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }

}

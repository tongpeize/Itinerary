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
    var route = store.objects(Destination).sorted("order")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = route.addNotificationBlock{ changes in
            self.tableView.reloadData()
        }
        
        if route.count == 0 {
            setupRoute()
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return route.count ?? 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case tableView.numberOfSections - 1:
            return 2
        case 0:
            return tableView.numberOfSections > 2 ? 2 : 1
        default:
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("CityCell") as! CityCell
            cell.destination = route[1] //0
            return cell
        case (0..<(tableView.numberOfSections - 1), 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("CityCell") as! CityCell
            cell.destination = route[indexPath.section + 1]
            return cell
        case (tableView.numberOfSections - 1, 1):
            let cell = tableView.dequeueReusableCellWithIdentifier("CityCell") as! CityCell
            cell.destination = route[0] //-1
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCellWithIdentifier("FlightCell") as! FlightCell
            cell.destination = route[indexPath.section + 1]
            cell.dateButtonPressed = {self.selectDate { date in
                try! store.write {
                    self.route[indexPath.section + 1].departTime = date
                }
            }}
            return cell
        case (_, 2):
            let cell = tableView.dequeueReusableCellWithIdentifier("FlightCell") as! FlightCell
            cell.destination = route[indexPath.section + 1]
            cell.dateButtonPressed = {self.selectDate { date in
                try! store.write {
                    self.route[indexPath.section + 1].departTime = date
                }
            }}
            return cell
        case (tableView.numberOfSections - 1, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("AddCell") as! AddCell
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("HotelCell") as! HotelCell
            cell.destination = route[indexPath.section + 1]
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        switch (indexPath.section, indexPath.row) {
        case (0..<(tableView.numberOfSections - 1), 0):
            changeCity(route[indexPath.section + 1])
        case (tableView.numberOfSections - 1, 1):
            changeCity(route[indexPath.section + 1]) //final
        case (0, 1):
            updateFlightInfo(route[indexPath.section + 1])
        case (_, 2):
            updateFlightInfo(route[indexPath.section + 1])
        case (tableView.numberOfSections - 1, 0):
            addDestination()
        default:
            updateHotelInfo(route[indexPath.section + 1])
        }
    }
    
    func changeCity(destination: Destination?) {
        print("change city")
        selectCity { city in
            try! store.write {
                destination?.city = city
            }
        }
    }
    
    func changeFinalCity(destination: Destination?) {
        print("change final city")
        selectCity { city in
            try! store.write {
                destination?.city = city
            }
        }
    }
    
    func updateFlightInfo(destination: Destination?) {
        //nil
    }
    
    func addDestination() {
        selectCity { city in
            try! store.write {
                let destination = Destination()
                destination.city = city
                destination.order = self.route.max("order")! + 1
                store.add(destination)
            }
        }
    }
    
    func updateHotelInfo(destination: Destination?) {
        print("update hotel info")
        selectHotel { hotel in
            try! store.write {
                destination!.hotel = hotel
            }
        }
    }
    
    func selectCity(block: ((City) -> Void)) {
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CityViewController") as! CityViewController
        nav.didSelectCity = { city in
            block(city)
        }
        navigationController?.pushViewController(nav, animated: true)
    }
    
    func selectDate(block: ((NSDate) -> Void)) {
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DatePickViewController") as! DatePickViewController
        nav.didSelectDate = { date in
            block(date)
        }
        navigationController?.pushViewController(nav, animated: true)
    }
    
    func selectHotel(block: ((Hotel) -> Void)) {
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HotelViewController") as! HotelViewController
        nav.didSelectHotel = { hotel in
            block(hotel)
        }
        navigationController?.pushViewController(nav, animated: true)
    }
    
    
    func setupRoute() {
        try! store.write {
            let origin = Destination()
            origin.order = 0
            origin.city = store.objects(City).first
            store.add(origin)
            let final = Destination()
            final.order = -1
            final.city = store.objects(City).first
            store.add(final)
        }
    }
}

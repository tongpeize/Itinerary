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
    var route = store.objects(Route)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = store.addNotificationBlock{ _ in
            self.tableView.reloadData()
        }
        
        if route.count == 0 {
            try! store.write {
                let org = Destination()
                org.order = 0
                org.city = store.objects(City).first
                store.add(org)
                let r = Route()
                r.destinations.append(org)
                r.final = store.objects(City).first
                store.add(r)
            }
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (route.first?.destinations.count ?? 0) + 1
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
            cell.cityName.text = route.first?.destinations[indexPath.section].city?.name ?? "请选择城市"
            cell.bgIMG.image = UIImage(named: "origin")
            cell.deletable = false
            return cell
        case (0..<(tableView.numberOfSections - 1), 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("CityCell") as! CityCell
            cell.cityName.text = route.first?.destinations[indexPath.section].city?.name ?? "请选择城市"
            cell.bgIMG.image = UIImage(named: "destination")
            cell.deletable = true
            cell.deleteBlock = {
                try! store.write {
                    self.route.first?.destinations.removeAtIndex(indexPath.section)
                    store.delete(store.objectForPrimaryKey(Destination.self, key: indexPath.section)!)
                }
            }
            return cell
        case (tableView.numberOfSections - 1, 1):
            let cell = tableView.dequeueReusableCellWithIdentifier("CityCell") as! CityCell
            cell.cityName.text = route.first?.final?.name ?? "请选择城市"
            cell.bgIMG.image = UIImage(named: "final")
            cell.deletable = false
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCellWithIdentifier("FlightCell") as! FlightCell
            cell.destination = route.first?.destinations[0]
            cell.dateButtonPressed = {self.selectDate { date in
                try! store.write {
                    self.route.first?.destinations[0].departTime = date
                }
            }}
            return cell
        case (_, 2):
            let cell = tableView.dequeueReusableCellWithIdentifier("FlightCell") as! FlightCell
            cell.destination = route.first?.destinations[indexPath.section]
            cell.dateButtonPressed = {self.selectDate { date in
                try! store.write {
                    self.route.first?.destinations[indexPath.section].departTime = date
                }
            }}
            return cell
        case (tableView.numberOfSections - 1, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("AddCell") as! AddCell
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("HotelCell") as! HotelCell
            cell.destination = route.first?.destinations[indexPath.section]
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
            changeCity(route.first?.destinations[indexPath.section])
        case (tableView.numberOfSections - 1, 1):
            changeFinalCity(route.first)
        case (0, 1):
            updateFlightInfo(route.first?.destinations[indexPath.section])
        case (_, 2):
            updateFlightInfo(route.first?.destinations[indexPath.section])
        case (tableView.numberOfSections - 1, 0):
            addDestination(route.first)
        default:
            updateHotelInfo(route.first?.destinations[indexPath.section])
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
    
    func changeFinalCity(route: Route?) {
        print("change final city")
        selectCity { city in
            try! store.write {
                route?.final = city
            }
        }
    }
    
    func updateFlightInfo(destination: Destination?) {
        print("update flight info")
        guard destination != nil else {
            fatalError("error: destination nil (flight)")
        }
        
        
    }
    
    func addDestination(route: Route?) {
        print("add destination")
        guard route != nil else {
            fatalError("error: route nil (add destination)")
        }
        selectCity { city in
            try! store.write {
                let destination = Destination()
                destination.city = city
                destination.order = route!.destinations.count
                route!.destinations.append(destination)
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

}

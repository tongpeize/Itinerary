//
//  CityViewController.swift
//  Itinerary
//
//  Created by 佟 佩泽 on 16/8/2.
//  Copyright © 2016年 佟佩泽. All rights reserved.
//

import UIKit
import RealmSwift

class CitySelectCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
}

class CityViewController: UITableViewController {
    
    var token: NotificationToken?
    var cities = store.objects(City)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = store.addNotificationBlock{ _ in
            self.tableView.reloadData()
        }
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CitySelectCell") as! CitySelectCell
        cell.name.text = cities[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        try! store.write {
            let destination = Destination()
            destination.city = cities[indexPath.row]
            destination.order = (store.objects(Route).first?.destinations.count)!
            store.objects(Route).first?.destinations.append(destination)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}

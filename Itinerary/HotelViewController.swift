//
//  HotelViewController.swift
//  Itinerary
//
//  Created by 佟佩泽 on 16/8/2.
//  Copyright © 2016年 佟佩泽. All rights reserved.
//

import UIKit
import RealmSwift

typealias hotelBlock = (Hotel) -> ()

class HotelSelectCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
}

class HotelViewController: UITableViewController {
    
    var didSelectHotel : hotelBlock?
    var token: NotificationToken?
    var hotels = store.objects(Hotel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = store.addNotificationBlock{ _ in
            self.tableView.reloadData()
        }
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HotelSelectCell") as! HotelSelectCell
        cell.name.text = hotels[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        didSelectHotel!(hotels[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
}

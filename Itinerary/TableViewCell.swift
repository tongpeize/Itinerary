//
//  TableViewCell.swift
//  Itinerary
//
//  Created by 佟佩泽 on 16/8/1.
//  Copyright © 2016年 佟佩泽. All rights reserved.
//

import UIKit

typealias cellBlock = () -> ()

class CityCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var bgIMG: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var destination : Destination? {
        didSet {
            guard destination != nil else {
                fatalError("flight cell error: destination nil")
            }
            switch destination!.order {
            case 0:
                //出发
                self.bgIMG.image = UIImage(named: "origin")
                deleteButton.hidden = true
            case -1:
                //到达
                self.bgIMG.image = UIImage(named: "final")
                deleteButton.hidden = true
            default:
                //目的地
                self.bgIMG.image = UIImage(named: "destination")
                deleteButton.hidden = false
            }
            self.cityName.text = destination!.city?.name ?? "请选择城市"
        }
    }
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        try! store.write {
            store.delete(self.destination!)
        }
    }
}


class FlightCell: UITableViewCell {
    
    var dateButtonPressed : cellBlock?
    
    var destination : Destination? {
        didSet {
            guard destination != nil else {
                fatalError("flight cell error: destination nil")
            }
            timeLabel.text = destination?.departTime?.string ?? "选择日期"
            preCity.text = destination?.city?.name
            nextCity.text = destination?.nextCity?.name
            transportIcon.image = UIImage(named: destination?.transport == 0 ? "plane" : "train")
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var preCity: UILabel!
    @IBOutlet weak var nextCity: UILabel!
    @IBOutlet weak var transportIcon: UIImageView!
    
    

    @IBAction func switchTransportType(sender: AnyObject) {
        try! store.write {
            destination?.transport = destination?.transport == 0 ? 1 : 0
        }
    }
    
    @IBAction func changeDate(sender: AnyObject) {
        if dateButtonPressed != nil {
            dateButtonPressed!()
        }
    }
    
}


class HotelCell: UITableViewCell {
    

    @IBOutlet weak var nameLabelOffset: NSLayoutConstraint!
    
    var destination : Destination? {
        didSet {
            if destination != nil {
                if destination!.hotel == nil {
                    self.bgIMG.image = UIImage(named: "hotel_blank")
                    self.hotelName.hidden = true
                    self.arrowIcon.hidden = true
                    self.timeRange.hidden = true
                    self.hotelIcon.hidden = false
                    self.noticeLabel.hidden = false
                }else {
                    self.bgIMG.image = UIImage(named: "hotel")
                    self.hotelName.hidden = false
                    self.arrowIcon.hidden = false
                    self.timeRange.hidden = false
                    self.hotelIcon.hidden = true
                    self.noticeLabel.hidden = true
                }
                self.hotelName.text = destination!.hotel?.name ?? ""
                if destination!.arriveTime != nil && destination!.departTime != nil {
                    self.timeRange.text = "\(destination!.arriveTime!.string) - \(destination!.departTime!.string)"
                    self.nameLabelOffset.constant = -5
                }else {
                    self.timeRange.text = ""
                    self.nameLabelOffset.constant = 0
                }
            }
            
            
        }
    }
    
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var timeRange: UILabel!
    @IBOutlet weak var bgIMG: UIImageView!
    @IBOutlet weak var hotelIcon: UIImageView!
    @IBOutlet weak var noticeLabel: UILabel!
    
}


class AddCell: UITableViewCell {
    
}

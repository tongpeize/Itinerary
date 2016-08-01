//
//  TableViewCell.swift
//  Itinerary
//
//  Created by 佟佩泽 on 16/8/1.
//  Copyright © 2016年 佟佩泽. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var bgIMG: UIImageView!
    
}


class FlightCell: UITableViewCell {
    
    var destination : Destination?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //TODO
    }
    
}


class HotelCell: UITableViewCell {
    
    var hotel : Hotel? {
        didSet {
            if hotel == nil {
                self.bgIMG.image = UIImage(named: "hotel")
                self.hotelName.hidden = true
                self.timeRange.hidden = true
                self.hotelIcon.hidden = false
                self.noticeLabel.hidden = false
            }else {
                self.bgIMG.image = UIImage(named: "hotel")
                self.hotelName.hidden = false
                self.timeRange.hidden = false
                self.hotelIcon.hidden = true
                self.noticeLabel.hidden = true
            }
        }
    }
    
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var timeRange: UILabel!
    @IBOutlet weak var bgIMG: UIImageView!
    @IBOutlet weak var hotelIcon: UIImageView!
    @IBOutlet weak var noticeLabel: UILabel!
    
}


class AddCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //TODO
    }
    
}

//
//  DatePickViewController.swift
//  Itinerary
//
//  Created by 佟佩泽 on 16/8/2.
//  Copyright © 2016年 佟佩泽. All rights reserved.
//

import UIKit

typealias dateBlock = (NSDate) -> ()

class DatePickViewController: UIViewController {
    
    var didSelectDate : dateBlock?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func confirm(sender: AnyObject) {
        if didSelectDate != nil {
            didSelectDate!(datePicker.date)
        }
        navigationController?.popViewControllerAnimated(true)
    }
}

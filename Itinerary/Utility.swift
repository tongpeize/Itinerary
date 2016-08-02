//
//  Utility.swift
//  Itinerary
//
//  Created by 佟佩泽 on 16/8/2.
//  Copyright © 2016年 佟佩泽. All rights reserved.
//

import UIKit

extension NSDate {
    var string : String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM月dd日"
        return dateFormatter.stringFromDate(self)
    }
}

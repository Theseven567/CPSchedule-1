//
//  Activity.swift
//  DatabaseProject
//
//  Created by Anuar's mac on 26.11.16.
//  Copyright © 2016 Yegor's Mac. All rights reserved.
//

import Foundation
import UIKit

class Activity {
    
    var info: String
    var time: String
    var day: String
    
    init(info: String, time: String, day: String) {
        self.info = info
        self.time = time
        self.day = day
    }
}

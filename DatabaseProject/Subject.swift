//
//  Subject.swift
//  DatabaseProject
//
//  Created by Егор on 11/16/16.
//  Copyright © 2016 Yegor's Mac. All rights reserved.
//

import Foundation

class Subject: NSObject {
    
//    var type: String
//    var name: String
//    var start: String
//    var end: String
//    var room: String
//    var instructor: String
    
    var subject: String
    var day: String
    var time: String
    var type: String
    
    init(subject: String, day: String, time: String, type: String) {
        self.subject = subject
        self.day = day
        self.time = time
        self.type = type
    }
}

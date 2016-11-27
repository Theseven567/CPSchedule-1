//
//  Student.swift
//  DatabaseProject
//
//  Created by Anuar's mac on 22.11.16.
//  Copyright © 2016 Yegor's Mac. All rights reserved.
//

import Foundation

class Student: NSObject {
    
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

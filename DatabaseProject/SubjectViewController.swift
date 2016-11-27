//
//  SubjectViewController.swift
//  DatabaseProject
//
//  Created by Егор on 11/16/16.
//  Copyright © 2016 Yegor's Mac. All rights reserved.
//

import UIKit

class SubjectViewController: UIViewController {

    @IBOutlet weak var instructorLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    var type: String = ""
    var name: String = ""
    var start: String = ""
    var end: String = ""
    var room: String = ""
    var instructor: String = ""
    var day:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.instructorLabel.text = instructor
        self.roomLabel.text = room
        self.endLabel.text = end
        self.startLabel.text = start
        self.dayLabel.text = day
        self.nameLabel.text = name
        self.typeLabel.text = type
    }
 
    @IBAction func goBack(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
    }
  
    


}

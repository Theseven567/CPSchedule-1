//
//  addViewController.swift
//  DatabaseProject
//
//  Created by Anuar's mac on 26.11.16.
//  Copyright © 2016 Yegor's Mac. All rights reserved.
//

import UIKit
import Alamofire

class addViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var dayPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    var days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var selectedDay = 0
    var studentId = ""
    var scheduleVC: ScheduleViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dayPicker.dataSource = self
        self.dayPicker.delegate = self
        
        saveButton.layer.cornerRadius = 5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        print(studentId)
        print(infoTextField.text!)
        print(timeTextField.text!)
        print(days[selectedDay])
        
        let url = "http://localhost:8080/insertActivity?id=\(studentId)&info=\(infoTextField.text!)&time=\(timeTextField.text!)&day=\(days[selectedDay])"
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(encodedUrl!)
        insertActivity(encodedUrl!)
        
        let activity = Subject(subject: infoTextField.text!, day: days[selectedDay], time: timeTextField.text!, type: "Activity")
        scheduleVC?.subjects.append(activity)
        print(activity.subject)
        print(activity.day)
        print(activity.time)
        scheduleVC?.classTable.resignFirstResponder()
        scheduleVC?.classTable.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return days[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDay = row
    }
    
    func insertActivity(_ url: String) {
        Alamofire.request(url)
    }
}

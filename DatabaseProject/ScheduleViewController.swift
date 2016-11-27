//
//  ScheduleViewController.swift
//  DatabaseProject
//
//  Created by Егор on 11/16/16.
//  Copyright © 2016 Yegor's Mac. All rights reserved.
//

import UIKit
import Alamofire

class ScheduleViewController: UIViewController,AKPickerViewDataSource, AKPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {

    let titles = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let selectionSpacing  = CGFloat(40)
    
    var student = Student(id: "", name: "")
    var subjects: [Subject] = []
    var subjectsThatDay: [Subject] = []
    
    @IBOutlet weak var classTable: UITableView!
    @IBOutlet weak var pickerView: AKPickerView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.pickerView.interitemSpacing = selectionSpacing
        self.pickerView.pickerViewStyle = AKPickerViewStyle.wheel
        self.pickerView.reloadData()
        
        self.classTable.delegate = self
        self.classTable.dataSource = self 
        
        print("The student picked:")
        print(student.id)
        print(student.name)
        
        let subjectUrl = "http://localhost:8080/getSubjectsById?id=\(student.id)"
        downloadSubjectById(subjectUrl)
        let activityUrl = "http://localhost:8080/getActivitiesById?id=\(student.id)"
        downloadActivityById(activityUrl)
        
        let addImage = UIImage(named: "Add Filled-75")
        let addButton = UIButton()
        addButton.frame = CGRect(x: self.view.frame.size.width - 100, y: self.view.frame.size.height - 100, width: 75, height: 75)
        addButton.setImage(addImage, for: .normal)
        addButton.addTarget(self, action: #selector(addActivity), for: .touchUpInside)
        self.view.addSubview(addButton)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        let item = pickerView.selectedItem
        
        self.subjectsThatDay = []
        for index in 0..<subjects.count {
            if subjects[index].day == titles[item] {
                self.subjectsThatDay.append(subjects[index])
            }
        }
        
        classTable.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        subjectsThatDay = []
    }
    
    func addActivity() {
        self.performSegue(withIdentifier: "addActivity", sender: self)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return subjectsThatDay.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ClassesViewCell = self.classTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ClassesViewCell
        
        cell.timeLabel?.text = subjectsThatDay[indexPath.row].time
        cell.classLabel?.text = subjectsThatDay[indexPath.row].subject
        cell.typeImage.image = UIImage(named: "student-2")
        
        return cell
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        
        self.subjectsThatDay = []
        for index in 0..<subjects.count {
            if subjects[index].day == titles[item] {
                self.subjectsThatDay.append(subjects[index])
            }
        }
        
        classTable.reloadData()
    }
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return 6
    }
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        
        return titles[item]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let index = indexPath.row
        let info = subjectsThatDay[index].subject
        let time = subjectsThatDay[index].time
        let day = subjectsThatDay[index].day
        let type = subjectsThatDay[index].type
        if type == "Activity" {
            if editingStyle == .delete {
                deleteActivityAlert(info: info, time: time, day: day, indexPath: indexPath, index: index)
            }
        } else {
            deleteSubjectAlert()
        }
    }
    
    func deleteActivityAlert(info: String, time: String, day: String, indexPath: IndexPath, index: Int) {
        
        let url = "http://localhost:8080/deleteActivity?id=\(student.id)&info=\(info)&time=\(time)&day=\(day)"
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let alertController = UIAlertController(title: "Delete", message: "Are you sure that you want to delete this activity?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {(UIAlertAction) in
            self.deleteActivity(encodedUrl!)
            var subjectsCount = self.subjects.count
            for i in 0..<subjectsCount {
                if self.subjects[i].subject == info && self.subjects[i].time == time && self.subjects[i].day == day {
                    subjectsCount -= 1
                    self.subjects.remove(at: i)
                    self.subjectsThatDay.remove(at: index)
                    break
                }
            }
            self.classTable.deleteRows(at: [indexPath], with: .automatic)
        })
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteSubjectAlert() {
        let alertController = UIAlertController(title: "Error", message: "You can not delete subjects. You can only delete your own created activities.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSubject" {
            let subject = segue.destination as! SubjectViewController
            subject.name = sender as! String
        }
        if segue.identifier == "addActivity" {
            let activity = segue.destination as! addViewController
            activity.studentId = student.id
            activity.scheduleVC = self
        }
    }
    
    func downloadSubjectById(_ url: String) {
        
        Alamofire.request(url).responseJSON { response in
            
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print(response.result.error!)
                
                return
            }
            
            // make sure we got JSON and it's an array of dictionaries
            guard let json = response.result.value as? [[String: AnyObject]] else {
                print("didn't get objects as JSON from API")
                
                return
            }
            print(json)
            
            // turn each item in JSON in to Todo object
            self.subjects = []
            for element in json {
                let Name = element["Subject"] as! String
                let Day = element["Day"] as! String
                let Time = element["Time"] as! String
                let subject = Subject(subject: Name, day: Day, time: Time, type: "Subject")
                print(subject.subject)
                print(subject.day)
                print(subject.time)
                self.subjects.append(subject)
            }
            
            self.classTable.reloadData()
        }
    }
    
    func downloadActivityById(_ url: String) {
        Alamofire.request(url).responseJSON { response in
            
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print(response.result.error!)
                
                return
            }
            
            // make sure we got JSON and it's an array of dictionaries
            guard let json = response.result.value as? [[String: AnyObject]] else {
                print("didn't get objects as JSON from API")
                
                return
            }
            print(json)
            
            // turn each item in JSON in to Todo object
            self.subjects = []
            for element in json {
                let info = element["info"] as! String
                let time = element["time"] as! String
                let day = element["day"] as! String
                let activity = Subject(subject: info, day: day, time: time, type: "Activity")
                print(activity.subject)
                print(activity.time)
                print(activity.day)
                self.subjects.append(activity)
            }
            
            self.classTable.reloadData()
        }
    }
    
    func deleteActivity(_ url: String) {
        Alamofire.request(url)
    }
}

//
//  ViewController.swift
//  DatabaseProject
//
//  Created by Егор on 11/16/16.
//  Copyright © 2016 Yegor's Mac. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    var students:[Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 10
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        self.view.addGestureRecognizer(tapGesture)
    }
    
    func dismissKeyboard() {
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.text = ""
        students = []
        tableView.reloadData()
    }
    
    // MARK: -Actions
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        let url = "http://localhost:8080/getStudentsByName?name=\(textField.text!)"
        downloadStudentByName(url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Student" {
            let scheduleVC = segue.destination as! ScheduleViewController
            let index = (sender as! NSIndexPath).row
            
            scheduleVC.student = students[index]
        }
    }
    
    
    // MARK: -TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StudentViewCell
        cell.idLabel?.text = students[indexPath.row].id
        cell.nameLabel?.text = students[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "Student", sender: indexPath)
    }

    
    // MARK: -Backend
    
    func downloadStudentByName(_ url: String) {
        
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
            //print(json)
            
            // turn each item in JSON in to Todo object
            self.students = []
            for element in json {
                let id = element["id"] as! String
                let name = element["name"] as! String
                let student = Student(id: id, name: name)
                print(student.id)
                print(student.name)
                self.students.append(student)
            }
            
            self.tableView.reloadData()
        }
    }
}


//
//  AddEmployeeViewController.swift
//  SwiftRealmDate
//
//  Created by Rakesh Kumar on 18/01/19.
//  Copyright © 2019 Rakesh Kumar. All rights reserved.
//

import UIKit


import UIKit
import RealmSwift

class AddEmployeeViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var textName: UITextField!
    
    @IBOutlet weak var textDate: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showDatePicker(){
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolBar = UIToolbar().ToolbarPiker(doneSelector: #selector(AddEmployeeViewController.donedatePicker), cancelSelector:#selector(AddEmployeeViewController.cancelDatePicker) )
     
        textDate.inputAccessoryView = toolBar
        textDate.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @IBAction func save(_ sender: Any) {
        
        guard let name = textName.text , name.count > 0 else {
            self.showAlert(message: "Name field can not be empty")
            return
        }
        guard let doj = textDate.text , name.count > 0 else {
            self.showAlert(message: "Date of joining field can not be empty")
            return
        }
        
        let employee = Employee()
        employee.name = name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.date(from: doj)
        employee.doj = date
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(employee)
        }
        
        textName.text = nil
        textDate.text = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cancelDatePicker()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showDatePicker()
    }
    func showAlert(message: String) -> Void{
        Utility.showAlert(message: message, title: "Error", actions: nil, controller: self, preferredStyle: .alert)
    }
}

//
//  MasterViewController.swift
//  SwiftRealmDate
//
//  Created by Rakesh Kumar on 18/01/19.
//  Copyright © 2019 Rakesh Kumar. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var employees = [Employee]()
    let filterDatePicker: UIDatePicker = UIDatePicker()
    
    var filteredDate : Date?
    let datePickerContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filterButton = UIBarButtonItem(title: "Filter", style: .done, target: self, action:#selector(filter(_:)))
        navigationItem.leftBarButtonItem = filterButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        filterDatePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        filterDatePicker.timeZone = NSTimeZone.local
        filterDatePicker.backgroundColor = UIColor.white
        filterDatePicker.datePickerMode = .date
        filterDatePicker.addTarget(self, action:#selector(datePickerValueChanged(_:)) , for: .valueChanged)
        
        let toolBar = UIToolbar().ToolbarPiker(doneSelector: #selector(MasterViewController.dismissPicker), cancelSelector:#selector(MasterViewController.resetFilter) )
        
        datePickerContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 500)
        datePickerContainer.addSubview(toolBar)
        datePickerContainer.addSubview(filterDatePicker)
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        reloadData()
        
    }
    
    func reloadData() -> Void {
        let realm = try! Realm()
        var predicate:NSPredicate? = nil
        if let filterDate = filteredDate{
            let date = self.reomveTimeFrom(date: filterDate)
            predicate = NSPredicate(format: "doj == %@",date as CVarArg)
        }
        let result = (predicate != nil) ? realm.objects(Employee.self).filter( predicate! ) : realm.objects(Employee.self)
        employees = Array(result)
        tableView.reloadData()
    }
    
    func reomveTimeFrom(date: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier:"AddEmployeeViewController" ){
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc
    func filter(_ sender: Any) {
        
        filteredDate = Date()
        self.view.addSubview(datePickerContainer)
        self.view.bringSubviewToFront(datePickerContainer)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        filteredDate = sender.date
    }
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let employee = employees[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.employee = employee
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    @objc func dismissPicker() {
        
        datePickerContainer.removeFromSuperview()
        reloadData()
    }
    @objc func resetFilter() {
        
        datePickerContainer.removeFromSuperview()
        filteredDate = nil
        reloadData()
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let employee = employees[indexPath.row]
        cell.textLabel!.text = employee.name
        return cell
    }
}

extension UIToolbar {
    
    func ToolbarPiker(doneSelector : Selector, cancelSelector : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: doneSelector)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Reset", style: UIBarButtonItem.Style.plain, target: self, action: cancelSelector)
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}

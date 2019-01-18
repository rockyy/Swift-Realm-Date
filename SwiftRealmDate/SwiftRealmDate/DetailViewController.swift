//
//  DetailViewController.swift
//  SwiftRealmDate
//
//  Created by Rakesh Kumar on 18/01/19.
//  Copyright © 2019 Rakesh Kumar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let employee = employee {
            if let label = detailDescriptionLabel {
                label.numberOfLines = 0
                label.textAlignment = .left
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                let doj = formatter.string(from: employee.doj)
                label.text = "Name      :" + employee.name + "\n" + "Doj          :" + doj
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    var employee: Employee? {
        didSet {
            // Update the view.
            configureView()
        }
    }
}


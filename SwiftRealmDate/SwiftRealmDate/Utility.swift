//
//  Utility.swift
//  SwiftRealmDate
//
//  Created by Rakesh Kumar on 18/01/19.
//  Copyright © 2019 Rakesh Kumar. All rights reserved.
//

import Foundation
import UIKit

class Utility {

    class func showAlert(message: String?, title: String?, actions: [UIAlertAction]?, controller: UIViewController!, preferredStyle: UIAlertController.Style) {
        
        DispatchQueue.main.async( execute: {
            var displayTitle: String? = title

            if title == nil{
                displayTitle = "Demo"
            }
            let alertController = UIAlertController(title: displayTitle, message: message, preferredStyle: preferredStyle)
            
            
            if (actions != nil){
                for action in actions!{
                    alertController.addAction(action)
                    
                }
            }else{
                let text = NSLocalizedString("OK", comment: "")
                let defaultAction =  UIAlertAction(title: text, style: .destructive) { (UIAlertAction) in
                    
                }
                alertController.addAction(defaultAction)
                
            }
            controller.present(alertController, animated: true, completion: nil)
        })
    }
}

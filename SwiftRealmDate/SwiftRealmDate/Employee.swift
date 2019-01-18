//
//  Employee.swift
//  SwiftRealmDate
//
//  Created by Rakesh Kumar on 18/01/19.
//  Copyright © 2019 Rakesh Kumar. All rights reserved.
//

import Foundation
import RealmSwift

class Employee : Object{
    @objc dynamic var name = ""
    @objc dynamic var doj : Date!
}

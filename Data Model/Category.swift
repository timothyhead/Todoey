//
//  Category.swift
//  Todoey
//
//  Created by Timothy Head on 02/07/2019.
//  Copyright © 2019 Timothy Head. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
   @objc dynamic var name: String = ""
    let items = List<Item>()
}

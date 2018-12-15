//
//  Category.swift
//  TodoList
//
//  Created by Adi on 12/15/18.
//  Copyright © 2018 Aditya. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

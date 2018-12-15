//
//  Item.swift
//  TodoList
//
//  Created by Adi on 12/15/18.
//  Copyright © 2018 Aditya. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreatedAt: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

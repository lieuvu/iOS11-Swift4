//
//  Category.swift
//  Todoey
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var hexColorStr: String = ""
    let items = List<Item>()
}

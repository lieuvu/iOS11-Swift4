//
//  Category.swift
//  Todoey
//
//  Created by Lieu Vu on 2/3/18.
//  Copyright © 2018 Lieu Vu. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var hexColorStr: String = ""
    let items = List<Item>()
}

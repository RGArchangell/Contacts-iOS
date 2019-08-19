//
//  Name.swift
//  Contacts iOS
//
//  Created by Archangel on 15/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation

struct Name {
    
    var id: Int
    var first: String
    var last: String
    
    init(id: Int, _ firstName: String, _ lastName: String) {
        self.id = id
        self.first = firstName
        self.last = lastName
    }
    
    init() {
        self.id = -1
        self.first = ""
        self.last = ""
    }
    
}

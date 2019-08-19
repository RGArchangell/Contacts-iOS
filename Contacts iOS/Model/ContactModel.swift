//
//  ContactModel.swift
//  Contacts iOS
//
//  Created by Archangel on 09/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class Contact: Object {
    
    @objc private(set) dynamic var id = 0
    @objc private(set) dynamic var firstName = ""
    @objc private(set) dynamic var lastName = ""
    @objc private(set) dynamic var phone = ""
    @objc private(set) dynamic var notes = ""
    @objc private(set) dynamic var ringtone = ""
    @objc private(set) dynamic var avatar = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int,
                     firstName: String,
                     lastName: String,
                     phone: String,
                     notes: String,
                     ringtone: String,
                     avatar: String) {
        self.init()
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.notes = notes
        self.ringtone = ringtone
        self.avatar = avatar
    }
    
}

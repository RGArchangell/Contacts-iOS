//
//  ContactInfoViewModel.swift
//  Contacts iOS
//
//  Created by Archangel on 16/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

class ContactInfoViewModel {
    
    private var contactID: Int
    private let realmManager: RealmManager
    
    private(set) var name: String?
    private(set) var phone: String?
    private(set) var notes: String?
    private(set) var ringtone: String?
    private(set) var avatar: UIImage?
    
    init(contactID: Int, realmManager: RealmManager) {
        self.realmManager = realmManager
        self.contactID = contactID
        loadData()
    }
    
    func loadData() {
        let loadedContact = realmManager.getObjectByID(contactID, type: Contact.self) ?? Contact()
        self.name = loadedContact.firstName.trimmingCharacters(in: .whitespaces) +
            " " + loadedContact.lastName.trimmingCharacters(in: .whitespaces)
        
        self.phone = loadedContact.phone
        self.ringtone = loadedContact.ringtone
        self.notes = loadedContact.notes
        
        let avatar = FileManager.default.getImage(imageName: "\(loadedContact.id)_avatar.jpg")
        self.avatar = avatar
    }
    
}

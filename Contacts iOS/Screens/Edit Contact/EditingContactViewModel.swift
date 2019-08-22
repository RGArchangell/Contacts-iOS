//
//  EditingContactViewModel.swift
//  Contacts iOS
//
//  Created by Archangel on 12/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import UIKit

class EditingContactViewModel {
    private let realmManager: RealmManager
    private var preloadedContact: Contact?
    private var id: Int
    private var avatarDidChanged = false
    private var type: EditorType
    
    private (set) var firstName: String?
    private (set) var lastName: String?
    private (set) var phone: String?
    private (set) var ringtone: String?
    private (set) var notes: String?
    private (set) var avatar: UIImage?
    
    init(id: Int, type: EditorType, realmManager: RealmManager) {
        self.realmManager = realmManager
        self.id = id
        self.type = type
        
        if let objects = realmManager.getObjects(type: Contact.self) {
            for element in objects {
                if let contact = element as? Contact, contact.id == id {
                    self.preloadedContact = contact
                }
            }
        }
        
        if type == .edit {
            self.getContactData()
        }
    }
    
    private func getContactData() {
        guard let avatarName = preloadedContact?.avatar else { return }
        
        self.firstName = preloadedContact?.firstName
        self.lastName = preloadedContact?.lastName
        self.phone = preloadedContact?.phone
        self.ringtone = preloadedContact?.ringtone
        self.notes = preloadedContact?.notes
        self.avatar = getImage(imageName: avatarName)
    }
    
    func saveContactData(newContact: NewContact) {
        print("saving")
        
        let imageName = "\(id)_avatar.jpg"
        let avatar = newContact.avatar
        
        let contact = Contact(id: id,
                              firstName: newContact.firstName,
                              lastName: newContact.lastName,
                              phone: newContact.phone,
                              notes: newContact.notes,
                              ringtone: newContact.ringtone,
                              avatar: imageName)
        
        switch type {
        case .new:
            saveImageDocumentDirectory(avatar, name: imageName)
            realmManager.saveObjects(objs: contact)
            
        case .edit:
            if avatarDidChanged {
                removeImage(imageName: imageName)
                saveImageDocumentDirectory(avatar, name: imageName)
            }
            realmManager.editObjects(objs: contact)
        }
    }
    
    func avatarHasUpdated() {
        avatarDidChanged = true
    }
    
    func deleteContactFromDatabase() {
        guard let contact = preloadedContact else { return }
        realmManager.deleteObject(objs: contact)
    }
    
}

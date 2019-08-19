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

protocol EditingContactViewModelDelegate: class {
    func didRequestImagePicker(_ requestedView: UIView)
}

class EditingContactViewModel {
    private let realm = try? Realm()
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
    
    weak var delegate: EditingContactViewModelDelegate?
    
    init(id: Int, type: EditorType) {
        self.realmManager = RealmManager()
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
    
    func saveContactData(contact: [String: Any]) {
        guard
            let firstName = contact["firstName"] as? String,
            let lastName = contact["lastName"] as? String,
            let phone = contact["phone"] as? String,
            let ringtone = contact["ringtone"] as? String,
            let notes = contact["notes"] as? String,
            let avatar = contact["avatar"] as? UIImage
        else
        { return }
        
        print("saving")
        
        let imageName = "\(id)_avatar.jpg"
        
        let contact = Contact(id: id,
                              firstName: firstName,
                              lastName: lastName,
                              phone: phone,
                              notes: notes,
                              ringtone: ringtone,
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
    
    func requestImagePicker(_ requestedView: UIView) {
        delegate?.didRequestImagePicker(requestedView)
    }
    
    func deleteContactFromDatabase() {
        guard let contact = preloadedContact else { return }
        realmManager.deleteObject(objs: contact)
    }
    
}

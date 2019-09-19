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

class EditingContactViewModel: NSObject {
    private let realmManager: RealmManager
    private let numberRegex = NSRegularExpression("^[+|0-9][0-9]{4}[0-9]*")
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
        super.init()
        
        if type == .edit {
            self.preloadedContact = realmManager.getObjectByID(id, type: Contact.self)
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
        self.avatar = FileManager.default.getImage(imageName: avatarName)
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
            FileManager.default.saveImageDocumentDirectory(avatar, name: imageName)
            realmManager.saveObjects(objs: contact)
            
        case .edit:
            if avatarDidChanged {
                FileManager.default.removeImage(imageName: imageName)
                FileManager.default.saveImageDocumentDirectory(avatar, name: imageName)
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
    
    func checkFields(firstName: String?, lastName: String?, phone: String?) -> Bool {
        if firstName.isEmptyOrNil || lastName.isEmptyOrNil || phone.isEmptyOrNil {
            return false
        }
        
        guard let number = phone else { return false }
        let range = NSRange(location: 0, length: number.utf16.count)
        
        if numberRegex.firstMatch(in: number, options: [], range: range) == nil {
            return false
        }
        
        if number.count > 15 { return false }
        
        return true
    }
    
    func checkEnter(_ text: String) -> Bool {
        if text == "\n" { return true }
        return false
    }
    
    func checkTextForReplacing(textView: UITextView, range: NSRange, text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 2000    // Limit Value
    }
    
}

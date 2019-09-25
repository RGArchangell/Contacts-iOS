//
//  ContactsTableViewModel.swift
//  Contacts iOS
//
//  Created by Archangel on 09/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol ContactsTableViewModelDelegate: class {
    func didRequestContactInfo(_ viewModel: ContactsTableViewModel, contactID: Int)
}

class ContactsTableViewModel {
    
    private let realmManager: RealmManager
    private var contactList: [Contact]
    private (set) var contactsDictionary = [String: [Name]]()
    private (set) var tableContactsDictionary = [String: [Name]]()
    private (set) var contactsSectionTitles = [String]()
    
    weak var delegate: ContactsTableViewModelDelegate?
    var names: [Name]
    
    init(realmManager: RealmManager) {
        self.realmManager = realmManager
        
        self.contactList = []
        self.names = []
        
        loadContacts()
    }
    
    func loadContacts() {
        tableContactsDictionary.removeAll()
        contactsDictionary.removeAll()
        
        contactList = []
        guard let objects = realmManager.getObjects(type: Contact.self) else {
            return
        }
        let contacts = Array(objects)
        
        self.contactList = contacts
    }
    
    func loadNames(completion: @escaping () -> Void) {
        names = []
        
        for contact in contactList {
            let id = contact.id
            let firstName = contact.firstName
            let lastName = contact.lastName
            
            self.names.append(Name(id: id, firstName, lastName))
        }
        
        completion()
    }
    
    func getNewId() -> Int {
        return realmManager.incrementID()
    }
    
    func requestContactInfo(contactID: Int?) {
        guard let id = contactID else { return }
        delegate?.didRequestContactInfo(self, contactID: id)
    }
    
    func deleteContactFromDatabase(contactID: Int?) {
        guard let id = contactID else { return }
        
        for contact in contactList where contact.id == id {
            realmManager.deleteObject(objs: contact)
        }
    }
    
    func deleteFromDictionary(_ key: String, _ num: Int) {
        tableContactsDictionary[key]?.remove(at: num)
    }
    
    func clearSection(_ key: String, _ indexPath: IndexPath) {
        tableContactsDictionary.removeValue(forKey: key)
        contactsSectionTitles.remove(at: indexPath.section)
    }
    
    func updateModelData() {
        contactsDictionary.removeAll()
        contactsSectionTitles.removeAll()
        
        for name in names {
            let contactKey = String(name.last.prefix(1))
            
            if var contactValues = contactsDictionary[contactKey] {
                contactValues.append(name)
                contactsDictionary[contactKey] = contactValues
            } else {
                contactsDictionary[contactKey] = [name]
            }
        }
        
        tableContactsDictionary = contactsDictionary
        updateHeaders()
    }
    
    private func updateHeaders() {
        contactsSectionTitles = tableContactsDictionary.keys.sorted()
    }
    
    func performSearch(_ text: String?, completion: @escaping () -> Void) {
        guard !text.isEmptyOrNil else {
            tableContactsDictionary = contactsDictionary
            updateHeaders()
            completion()
            return
        }
        
        var array = [Name]()
        for contact in contactsDictionary {
            for value in contact.value {
                array.append(value)
            }
        }
        
        let filtered = array.filter { contact -> Bool in
            guard let text = text else { return false }
            let fullName = (contact.first + contact.last).lowercased()
            
            return fullName.contains(text.lowercased())
        }
        
        tableContactsDictionary.removeAll()
        for name in filtered {
            guard let keyChar = name.last.first else { continue }
            let key = String(keyChar)
            
            if var contactValues = tableContactsDictionary[key] {
                contactValues.append(name)
                tableContactsDictionary[key] = contactValues
            } else {
                tableContactsDictionary[key] = [name]
            }
        }
        
        updateHeaders()

        completion()
    }
    
}

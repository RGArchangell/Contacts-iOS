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
    func didRequestContactInfo(_ contact: Contact)
}

class ContactsTableViewModel {
    
    private let realm = try? Realm()
    private let realmManager: RealmManager
    private var contactList: [Contact]
    
    weak var delegate: ContactsTableViewModelDelegate?
    var names: [Name]
    
    init() {
        self.realmManager = RealmManager()
        
        self.contactList = []
        self.names = []
        
        loadContacts()
    }
    
    func loadContacts() {
        contactList = []
        var contacts = [Contact]()
        
        if let objects = realmManager.getObjects(type: Contact.self) {
            for element in objects {
                if let contact = element as? Contact {
                    contacts.append(contact)
                }
            }
        }
        
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
        
        for contact in contactList where contact.id == id {
            delegate?.didRequestContactInfo(contact)
        }
    }
    
    func deleteContactFromDatabase(contactID: Int?) {
        guard let id = contactID else { return }
        
        for contact in contactList where contact.id == id {
            realmManager.deleteObject(objs: contact)
        }
        loadContacts()
    }
    
}

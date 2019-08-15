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

class ContactsTableViewModel {
    
    private let dataProvider: DataProvider
    private let realm = try? Realm()
    private let realmManager: RealmManager
    private var contactList: [Contact]
    
    var firstNames: [String]
    var lastNames: [String]
    
    init() {
        self.dataProvider = DataProvider()
        self.realmManager = RealmManager()
        
        self.contactList = []
        self.firstNames = []
        self.lastNames = []
        
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
        firstNames = []
        lastNames = []
        
        for contact in contactList {
            self.firstNames.append(contact.firstName)
            self.lastNames.append(contact.lastName)
        }
        
        completion()
    }
    
    func getNewId() -> Int {
        return self.firstNames.count + 1
    }
    
}

//
//  ContactInfoViewModel.swift
//  Contacts iOS
//
//  Created by Archangel on 12/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import UIKit

protocol ContactInfoViewModelDelegate: class {
    func didRequestImagePicker(_ requestedView: UIView)
}

class ContactInfoViewModel {
    private let realm = try? Realm()
    private let realmManager: RealmManager
    private var id: Int
    
    weak var delegate: ContactInfoViewModelDelegate?
    
    init(id: Int) {
        self.realmManager = RealmManager()
        self.id = id
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
        
        let contact = Contact(id: id,
                              firstName: firstName,
                              lastName: lastName,
                              phone: phone,
                              notes: notes,
                              ringtone: ringtone,
                              avatar: avatar)
        
        realmManager.saveObjects(objs: contact)
    }
    
    func requestImagePicker(_ requestedView: UIView) {
        delegate?.didRequestImagePicker(requestedView)
    }
    
}

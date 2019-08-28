//
//  RealmManager.swift
//  Contacts iOS
//
//  Created by Archangel on 09/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    lazy var realm = getRealm()
    
    private func getRealm() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        } catch _ {
            fatalError()
        }
    }
    
    private func checkRealm(action: () -> Void) {
        do {
            try realm?.write {
                action()
            }
        } catch _ {
            fatalError()
        }
    }
    
    // delete table
    func deleteDatabase() {
        checkRealm {
            realm?.deleteAll()
        }
    }
    
    // delete particular object
    func deleteObject(objs: Object) {
        checkRealm {
            realm?.delete(objs)
        }
    }
    
    //Save array of objects to database
    func saveObjects(objs: Object) {
        checkRealm {
            realm?.add(objs, update: false)
        }
    }
    
    // editing the object
    func editObjects(objs: Object) {
        checkRealm {
            // If update = true, objects that are already in the Realm will be
            // updated instead of added a new.
            realm?.add(objs, update: true)
        }
    }
    
    //Returs an array as Results<object>?
    func getObjects<T: Object>(type: T.Type) -> Results<T>? {
        return realm?.objects(type)
    }
    
    func getObjectByID<T: Object>(_ id: Int, type: T.Type) -> T? {
        let objects = realm?.objects(type)
        return objects?[id - 1]
    }
    
    func incrementID() -> Int {
        return (realm?.objects(Contact.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
}

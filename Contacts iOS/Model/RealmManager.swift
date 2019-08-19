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
    var realm = try? Realm()
    
    // delete table
    func deleteDatabase() {
        try? realm?.write {
            realm?.deleteAll()
        }
    }
    
    // delete particular object
    func deleteObject(objs: Object) {
        try? realm?.write {
            realm?.delete(objs)
        }
    }
    
    //Save array of objects to database
    func saveObjects(objs: Object) {
        try? realm?.write {
            // If update = false, adds the object
            realm?.add(objs, update: false)
        }
    }
    
    // editing the object
    func editObjects(objs: Object) {
        try? realm?.write {
            // If update = true, objects that are already in the Realm will be
            // updated instead of added a new.
            realm?.add(objs, update: true)
        }
    }
    
    //Returs an array as Results<object>?
    func getObjects(type: Object.Type) -> Results<Object>? {
        return realm?.objects(type)
    }
    
    func getObjectByID(_ id: Int, type: Object.Type) -> Object? {
        let objects = getObjects(type: type)
        
        return objects?[id]
    }
    
    func incrementID() -> Int {
        return (realm?.objects(Contact.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
}

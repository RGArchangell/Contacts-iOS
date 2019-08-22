//
//  PublicFunctions.swift
//  Contacts iOS
//
//  Created by Archangel on 16/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Save Image At Document Directory

public func saveImageDocumentDirectory(_ image: UIImage, name: String) {
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        as NSString).appendingPathComponent(name)
    
    print(paths)
    
    let imageData = image.jpegData(compressionQuality: 0.5)
    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
}

// MARK: - Get Document Directory Path

public func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

// MARK: - Get Image from Document Directory

public func getImage(imageName: String) -> UIImage {
    let fileManager = FileManager.default
    let imagePath = (getDirectoryPath() as NSString).appendingPathComponent(imageName)
    
    if fileManager.fileExists(atPath: imagePath) {
        return UIImage(contentsOfFile: imagePath) ?? #imageLiteral(resourceName: "avatarPlaceholder")
    } else {
        print("Image with name \(imageName) doesn't exist. Replacing with placeholder image")
        return #imageLiteral(resourceName: "avatarPlaceholder")
    }
}

// MARK: - Remove image from Document Directory

public func removeImage(imageName: String) {
    let fileManager = FileManager.default
    let imagePath = (getDirectoryPath() as NSString).appendingPathComponent(imageName)
    
    if fileManager.fileExists(atPath: imagePath) {
        do {
            try fileManager.removeItem(atPath: imagePath)
        } catch let error {
            print(error)
        }
    } else {
        print("Image with name \(imageName) doesn't exist, or already had been deleted")
    }
}

// MARK: - Call to the phone number

public func callNumber(phoneNumber: String) {
    guard let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") else { return }
        
    let application: UIApplication = UIApplication.shared
    if application.canOpenURL(phoneCallURL) {
        application.open(phoneCallURL, options: [:], completionHandler: nil)
    }
}

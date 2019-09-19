//
//  FileManagerExtensions.swift
//  Contacts iOS
//
//  Created by Archangel on 18/09/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

public extension FileManager {
    
    // MARK: - Save Image At Document Directory
    
    func saveImageDocumentDirectory(_ image: UIImage, name: String) {
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            as NSString).appendingPathComponent(name)
        
        print(paths)
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        self.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
 
    // MARK: - Get Document Directory Path
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // MARK: - Get Image from Document Directory
    
    func getImage(imageName: String) -> UIImage {
        let imagePath = (getDirectoryPath() as NSString).appendingPathComponent(imageName)
        
        if self.fileExists(atPath: imagePath) {
            return UIImage(contentsOfFile: imagePath) ?? #imageLiteral(resourceName: "avatarPlaceholder")
        } else {
            print("Image with name \(imageName) doesn't exist. Replacing with placeholder image")
            return #imageLiteral(resourceName: "avatarPlaceholder")
        }
    }
    
    // MARK: - Remove image from Document Directory
    
    func removeImage(imageName: String) {
        let imagePath = (getDirectoryPath() as NSString).appendingPathComponent(imageName)
        
        if self.fileExists(atPath: imagePath) {
            do {
                try self.removeItem(atPath: imagePath)
            } catch let error {
                print(error)
            }
        } else {
            print("Image with name \(imageName) doesn't exist, or already had been deleted")
        }
    }
    
}

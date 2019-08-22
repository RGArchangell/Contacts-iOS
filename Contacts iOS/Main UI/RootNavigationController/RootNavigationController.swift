//
//  RootNavigationController.swift
//  Contacts iOS
//
//  Created by Archangel on 15/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

protocol RootNavigationControllerDelegate: class {
    func avatarImageHasUpdated(_ newImage: UIImage)
}

class RootNavigationController: UINavigationController {
    weak var imagePickerDelegate: RootNavigationControllerDelegate?
}

extension RootNavigationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print("image picked")
        
        guard let pickedImage = info[.originalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        guard let image = pickedImage.circleMasked else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        imagePickerDelegate?.avatarImageHasUpdated(image)
        dismiss(animated: true, completion: nil)
    }
    
}

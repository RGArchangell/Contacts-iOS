//
//  ImagePickerCoordinator.swift
//  Contacts iOS
//
//  Created by Archangel on 14/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

protocol ImagePickerCoordinatorDelegate: class {
    func сoordinatorDidFinish(_ сoordinator: Coordinator)
    func imagePicked(_ coordinator: ImagePickerCoordinator, image: UIImage)
}

class ImagePickerCoordinator: Coordinator {
    
    private let rootViewController: UINavigationController
    
    weak var delegate: ImagePickerCoordinatorDelegate?
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    override func start() {
        showImageActionSheet()
    }
    
    private func showImageActionSheet() {
        let imagePicker = UIImagePickerController()
        
        let actionSheet = UIAlertController(title: "Upload image",
                                            message: "Please, select the source",
                                            preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: UIAlertAction.Style.default) { (_: UIAlertAction) -> Void in
                                                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                                                imagePicker.delegate = self
                                                self.rootViewController.present(imagePicker, animated: true, completion: nil)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: UIAlertAction.Style.default) { (_: UIAlertAction) -> Void in
                                                
                                                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                                                imagePicker.delegate = self
                                                self.rootViewController.present(imagePicker, animated: true, completion: nil)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        rootViewController.present(actionSheet, animated: true, completion: nil)
    }
    
}

extension ImagePickerCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print("image picked")
        
        guard let pickedImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        guard let image = pickedImage.circleMasked else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        delegate?.imagePicked(self, image: image)
        picker.dismiss(animated: true, completion: nil)
        delegate?.сoordinatorDidFinish(self)
    }
    
}

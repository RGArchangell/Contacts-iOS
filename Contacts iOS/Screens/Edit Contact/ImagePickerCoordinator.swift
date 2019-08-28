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
}

class ImagePickerCoordinator: Coordinator {
    
    private let rootViewController: RootNavigationController
    
    weak var delegate: ImagePickerCoordinatorDelegate?
    weak var requestedView: NewContactView?
    
    init(rootViewController: RootNavigationController, _ requestedView: UIView) {
        self.rootViewController = rootViewController
        self.requestedView = requestedView as? NewContactView
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
                                                imagePicker.delegate = self.rootViewController
                                                self.rootViewController.present(imagePicker, animated: true, completion: nil)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: UIAlertAction.Style.default) { (_: UIAlertAction) -> Void in
                                                
                                                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                                                imagePicker.delegate = self.rootViewController
                                                self.rootViewController.present(imagePicker, animated: true, completion: nil)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        rootViewController.imagePickerDelegate = self
        rootViewController.present(actionSheet, animated: true, completion: nil)
    }
    
}

extension ImagePickerCoordinator: RootNavigationControllerDelegate {
    
    func avatarImageHasUpdated(_ newImage: UIImage) {
        requestedView?.avatarImageHasUpdated(newImage)
        delegate?.сoordinatorDidFinish(self)
    }
    
}

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
    weak var requestedView: UIView?
    
    init(rootViewController: RootNavigationController, _ requestedView: UIView) {
        self.rootViewController = rootViewController
        self.requestedView = requestedView
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
                                                self.rootViewController.present(imagePicker, animated: true, completion: nil)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: UIAlertAction.Style.default) { (_: UIAlertAction) -> Void in
                                                
                                                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                                                self.rootViewController.present(imagePicker, animated: true, completion: nil)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        guard let requestedView = requestedView as? NewContactView else { return }
        rootViewController.imagePickerDelegate = requestedView
        rootViewController.present(actionSheet, animated: true, completion: nil)
        
        delegate?.сoordinatorDidFinish(self)
    }
    
}

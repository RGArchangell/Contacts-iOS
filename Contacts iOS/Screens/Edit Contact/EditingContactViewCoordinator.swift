//
//  NewContactViewCoordinator.swift
//  Contacts iOS
//
//  Created by Archangel on 12/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

protocol EditingContactViewCoordinatorDelegate: class {
    func сoordinatorDidFinish(_ сoordinator: Coordinator)
}

class EditingContactViewCoordinator: Coordinator {
    
    private let rootViewController: RootNavigationController
    private var id: Int
    private var type: EditorType
    
    weak var delegate: EditingContactViewCoordinatorDelegate?
    
    lazy var newContactViewController = EditingContactViewController(viewModel: newContactViewModel, type: type)
    lazy var newContactViewModel = EditingContactViewModel(id: id, type: type, realmManager: RealmManager())
    
    init(rootViewController: RootNavigationController, id: Int, type: EditorType) {
        self.rootViewController = rootViewController
        self.id = id
        self.type = type
    }
    
    override func start() {
        loadScreen()
    }
    
    private func loadScreen() {
        newContactViewController.delegate = self
        
        rootViewController.pushViewController(newContactViewController, animated: true)
    }
    
    private func setNavigationBarPreferences() {
        rootViewController.navigationBar.prefersLargeTitles = false
        createButtons()
    }
    
    private func createButtons() {
        createCancelButton()
        createDoneButton()
    }
    
    private func createCancelButton() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(goBack))
        newContactViewController.navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func createDoneButton() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveContact))
        doneButton.isEnabled = false
        newContactViewController.navigationItem.rightBarButtonItem = doneButton
    }
    
    private func coordinatorDidFinish() {
        delegate?.сoordinatorDidFinish(self)
    }
    
    @objc private func saveContact() {
        let contact = newContactViewController.getInfoFromFields()
        newContactViewModel.saveContactData(newContact: contact)
        
        goBack()
    }
    
    @objc private func goBack() {
        rootViewController.popViewController(animated: true)
        coordinatorDidFinish()
    }
    
    private func goBackAfterDeletion() {
        rootViewController.popViewController(animated: false)
        rootViewController.popViewController(animated: false)
        coordinatorDidFinish()
    }
    
}

extension EditingContactViewCoordinator: EditingContactViewControllerDelegate {
    
    func imagePickerView(_ requestedView: UIView) {
        let imagePickerCoordinator = ImagePickerCoordinator(rootViewController: rootViewController, requestedView)
        
        imagePickerCoordinator.delegate = self
        addChildCoordinator(imagePickerCoordinator)
        imagePickerCoordinator.start()
    }
    
    func contactDeleted() {
        goBackAfterDeletion()
    }
    
    func creatingAvaliable() {
        newContactViewController.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func creatingIsNotAvaliable() {
        newContactViewController.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func viewWillAppear() {
        setNavigationBarPreferences()
    }
    
}

extension EditingContactViewCoordinator: ImagePickerCoordinatorDelegate {
    
    func сoordinatorDidFinish(_ сoordinator: Coordinator) {
        self.removeChildCoordinator(сoordinator)
    }
    
}

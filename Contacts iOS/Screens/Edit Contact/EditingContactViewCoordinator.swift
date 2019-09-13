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
    
    private let rootViewController: UINavigationController
    private var contactId: Int
    private var type: EditorType
    
    weak var delegate: EditingContactViewCoordinatorDelegate?
    
    private var updateCreateButtonEnabledState: ((Bool) -> Void)?
    
    init(rootViewController: UINavigationController, id: Int, type: EditorType) {
        self.rootViewController = rootViewController
        self.contactId = id
        self.type = type
    }
    
    override func start() {
        loadScreen()
    }
    
    private func loadScreen() {
        let newContactViewModel = EditingContactViewModel(id: contactId, type: type, realmManager: RealmManager())
        let newContactViewController = EditingContactViewController(viewModel: newContactViewModel, type: type)
        newContactViewController.delegate = self
        
        updateCreateButtonEnabledState = { [weak newContactViewController] isEnabled in
            newContactViewController?.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
        }
        
        rootViewController.pushViewController(newContactViewController, animated: true)
    }
    
    private func setNavigationBarPreferences(_ viewController: EditingContactViewController) {
        rootViewController.navigationBar.prefersLargeTitles = false
        viewController.navigationItem.leftBarButtonItem = createCancelButton()
        viewController.navigationItem.rightBarButtonItem = createDoneButton(viewController)
    }
    
    private func createCancelButton() -> UIBarButtonItem {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(goBack))
        return cancelButton
    }
    
    private func createDoneButton(_ viewController: EditingContactViewController) -> UIBarButtonItem {
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: viewController,
                                         action: #selector(viewController.saveContact))
        doneButton.isEnabled = false
        return doneButton
    }
    
    private func coordinatorDidFinish() {
        delegate?.сoordinatorDidFinish(self)
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
    
    func contactSaved() {
        goBack()
    }
    
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
        updateCreateButtonEnabledState?(true)
    }
    
    func creatingIsNotAvaliable() {
        updateCreateButtonEnabledState?(false)
    }
    
    func viewWillAppear(_ viewController: EditingContactViewController) {
        setNavigationBarPreferences(viewController)
    }
    
}

extension EditingContactViewCoordinator: ImagePickerCoordinatorDelegate {
    
    func сoordinatorDidFinish(_ сoordinator: Coordinator) {
        self.removeChildCoordinator(сoordinator)
    }
    
}

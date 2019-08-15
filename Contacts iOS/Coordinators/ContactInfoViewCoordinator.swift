//
//  ContactInfoViewCoordinator.swift
//  Contacts iOS
//
//  Created by Archangel on 12/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

protocol ContactInfoViewCoordinatorDelegate: class {
    func сoordinatorDidFinish(_ сoordinator: Coordinator)
}

class ContactInfoViewCoordinator: Coordinator {
    
    private let rootViewController: RootNavigationController
    private var id: Int
    
    weak var delegate: ContactInfoViewCoordinatorDelegate?
    
    lazy var contactInfoViewController = ContactInfoViewController(viewModel: contactInfoViewModel)
    lazy var contactInfoViewModel = ContactInfoViewModel(id: id)
    
    init(rootViewController: RootNavigationController, id: Int) {
        self.rootViewController = rootViewController
        self.id = id
    }
    
    override func start() {
        loadScreen()
    }
    
    private func loadScreen() {
        contactInfoViewModel.delegate = self
        contactInfoViewController.delegate = self
        
        rootViewController.pushViewController(contactInfoViewController, animated: true)
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
        contactInfoViewController.navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func createDoneButton() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveContact))
        contactInfoViewController.navigationItem.rightBarButtonItem = doneButton
    }
    
    private func coordinatorDidFinish() {
        delegate?.сoordinatorDidFinish(self)
    }
    
    @objc private func saveContact() {
        let contact = contactInfoViewController.getInfoFromFields()
        contactInfoViewModel.saveContactData(contact: contact)
        
        goBack()
    }
    
    @objc private func goBack() {
        rootViewController.popViewController(animated: true)
        coordinatorDidFinish()
    }
    
}

extension ContactInfoViewCoordinator: ContactInfoViewControllerDelegate {
    
    func viewWillAppear() {
        setNavigationBarPreferences()
    }
    
    func viewDidDisappear() {
        //coordinatorDidFinish()
    }
    
}

extension ContactInfoViewCoordinator: ContactInfoViewModelDelegate {

    func didRequestImagePicker(_ requestedView: UIView) {
        let imagePickerCoordinator = ImagePickerCoordinator(rootViewController: rootViewController, requestedView)
        
        imagePickerCoordinator.delegate = self
        addChildCoordinator(imagePickerCoordinator)
        imagePickerCoordinator.start()
    }
    
}

extension ContactInfoViewCoordinator: ImagePickerCoordinatorDelegate {
    
    func сoordinatorDidFinish(_ сoordinator: Coordinator) {
        self.removeChildCoordinator(сoordinator)
    }
    
}

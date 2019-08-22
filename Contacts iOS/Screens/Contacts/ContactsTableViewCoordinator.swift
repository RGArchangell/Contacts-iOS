//
//  ContactsTableViewCoordinator.swift
//  Contacts iOS
//
//  Created by Archangel on 09/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

class ContactsTableViewCoordinator: Coordinator {
    
    private let rootViewController: RootNavigationController
    lazy var contactsTableViewController = ContactsTableViewController(viewModel: contactsTableViewModel)
    lazy var contactsTableViewModel = ContactsTableViewModel(realmManager: RealmManager())
    
    init(rootViewController: RootNavigationController) {
        self.rootViewController = rootViewController
    }
    
    override func start() {
        contactsTableViewModel.delegate = self
        contactsTableViewController.delegate = self
        
        rootViewController.setViewControllers([contactsTableViewController], animated: false)
    }
    
    private func setNavigationBarPreferences() {
        rootViewController.navigationBar.topItem?.title = "Contacts"
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.largeTitleDisplayMode = .never
        rootViewController.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        rootViewController.navigationBar.shadowImage = UIImage()
        rootViewController.navigationBar.isTranslucent = false
        
        createPlusButton()
    }
    
    private func createPlusButton() {
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .done, target: self, action: #selector(goToAddScreen))
        contactsTableViewController.navigationItem.rightBarButtonItem = addButton
    }
    
    private func removeCoordinatorChild(childCoordinator: Coordinator) {
        self.removeChildCoordinator(childCoordinator)
    }
    
    @objc private func goToAddScreen() {
        let id = contactsTableViewModel.getNewId()
        let newContactViewCoordinator = EditingContactViewCoordinator(rootViewController: rootViewController,
                                                                      id: id,
                                                                      type: .new)
        newContactViewCoordinator.delegate = self
        
        addChildCoordinator(newContactViewCoordinator)
        newContactViewCoordinator.start()
    }
    
    private func goToContactScreen(contact: Contact) {
        let contactInfoViewCoordinator = ContactInfoViewCoordinator(rootViewController: rootViewController,
                                                                    contact.id)
        
        contactInfoViewCoordinator.delegate = self
        
        addChildCoordinator(contactInfoViewCoordinator)
        contactInfoViewCoordinator.start()
    }
    
}

extension ContactsTableViewCoordinator: ContactsTableViewControllerDelegate {
    
    func viewWillAppear() {
        setNavigationBarPreferences()
    }
    
}

extension ContactsTableViewCoordinator: ContactsTableViewModelDelegate {
    
    func didRequestContactInfo(_ contact: Contact) {
        goToContactScreen(contact: contact)
    }
    
}

extension ContactsTableViewCoordinator: EditingContactViewCoordinatorDelegate, ContactInfoViewCoordinatorDelegate {
    
    func сoordinatorDidFinish(_ сoordinator: Coordinator) {
        removeChildCoordinator(сoordinator)
    }
    
}

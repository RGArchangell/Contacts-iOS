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
    
    private let rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    override func start() {
        let contactsTableViewModel = ContactsTableViewModel(realmManager: RealmManager())
        let contactsTableViewController = ContactsTableViewController(viewModel: contactsTableViewModel)
        
        contactsTableViewModel.delegate = self
        contactsTableViewController.delegate = self
        
        rootViewController.setViewControllers([contactsTableViewController], animated: false)
    }
    
    private func setNavigationBarPreferences(viewController: ContactsTableViewController) {
        rootViewController.navigationBar.topItem?.title = "Contacts"
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.largeTitleDisplayMode = .never
        rootViewController.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        rootViewController.navigationBar.shadowImage = UIImage()
        rootViewController.navigationBar.isTranslucent = false
        
        viewController.navigationItem.rightBarButtonItem = createPlusButton(viewController)
    }
    
    private func createPlusButton(_ viewController: ContactsTableViewController) -> UIBarButtonItem {
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add"),
                                        style: .done,
                                        target: viewController,
                                        action: #selector(viewController.requestGoToAddScreen))
        return addButton
    }
    
    private func removeCoordinatorChild(childCoordinator: Coordinator) {
        self.removeChildCoordinator(childCoordinator)
    }
    
    private func goToAddScreen(_ id: Int) {
        
        let newContactViewCoordinator = EditingContactViewCoordinator(rootViewController: rootViewController,
                                                                      id: id,
                                                                      type: .new)
        newContactViewCoordinator.delegate = self
        
        addChildCoordinator(newContactViewCoordinator)
        newContactViewCoordinator.start()
    }
    
    private func goToContactScreen(contactID: Int) {
        let contactInfoViewCoordinator = ContactInfoViewCoordinator(rootViewController: rootViewController,
                                                                    contactID)
        
        contactInfoViewCoordinator.delegate = self
        
        addChildCoordinator(contactInfoViewCoordinator)
        contactInfoViewCoordinator.start()
    }
    
}

extension ContactsTableViewCoordinator: ContactsTableViewControllerDelegate {
    
    func didRequestGoToAddScreen(newContactID: Int) {
        goToAddScreen(newContactID)
    }
    
    func viewWillAppear(sender viewController: ContactsTableViewController) {
        setNavigationBarPreferences(viewController: viewController)
    }
    
}

extension ContactsTableViewCoordinator: ContactsTableViewModelDelegate {
    
    func didRequestContactInfo(_ contactID: Int) {
        goToContactScreen(contactID: contactID)
    }
    
}

extension ContactsTableViewCoordinator: EditingContactViewCoordinatorDelegate, ContactInfoViewCoordinatorDelegate {
    
    func сoordinatorDidFinish(_ сoordinator: Coordinator) {
        removeChildCoordinator(сoordinator)
    }
    
}

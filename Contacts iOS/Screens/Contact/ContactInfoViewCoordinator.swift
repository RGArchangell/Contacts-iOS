//
//  ContactInfoViewCoordinator.swift
//  Contacts iOS
//
//  Created by Archangel on 16/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

protocol ContactInfoViewCoordinatorDelegate: class {
    func сoordinatorDidFinish(_ сoordinator: Coordinator)
}

class ContactInfoViewCoordinator: Coordinator {
    
    private let rootViewController: UINavigationController
    private var contactID: Int
    
    weak var delegate: ContactInfoViewCoordinatorDelegate?
    
    //lazy var contactInfoViewController = ContactInfoViewController(viewModel: contactInfoViewModel)
    //lazy var contactInfoViewModel = ContactInfoViewModel(contactID: contactID, realmManager: RealmManager())
    
    init(rootViewController: UINavigationController, _ contactID: Int) {
        self.rootViewController = rootViewController
        self.contactID = contactID
    }
    
    override func start() {
        loadScreen()
    }
    
    private func loadScreen() {
        let contactInfoViewModel = ContactInfoViewModel(contactID: contactID, realmManager: RealmManager())
        let contactInfoViewController = ContactInfoViewController(viewModel: contactInfoViewModel)
        contactInfoViewController.delegate = self
        
        rootViewController.pushViewController(contactInfoViewController, animated: true)
    }
    
    private func setNavigationBarPreferences(_ sender: ContactInfoViewController) {
        rootViewController.navigationBar.prefersLargeTitles = false
        sender.navigationItem.rightBarButtonItem = createEditButton()
    }
    
    private func createEditButton() -> UIBarButtonItem {
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(goToEditScreen))
        return editButton
    }
    
    @objc private func goToEditScreen() {
        let editContactViewCoordinator = EditingContactViewCoordinator(rootViewController: rootViewController,
                                                                       id: contactID,
                                                                       type: .edit)
        editContactViewCoordinator.delegate = self
        
        addChildCoordinator(editContactViewCoordinator)
        editContactViewCoordinator.start()
    }
    
}

extension ContactInfoViewCoordinator: ContactInfoViewControllerDelegate {
    
    func viewWillAppear(_ sender: ContactInfoViewController) {
        setNavigationBarPreferences(sender)
    }
    
}

extension ContactInfoViewCoordinator: EditingContactViewCoordinatorDelegate {
    
    func сoordinatorDidFinish(_ сoordinator: Coordinator) {
        self.removeChildCoordinator(сoordinator)
    }
    
}

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
    
    private let rootViewController: RootNavigationController
    private var contactID: Int
    
    weak var delegate: ContactInfoViewCoordinatorDelegate?
    
    lazy var contactInfoViewController = ContactInfoViewController(viewModel: contactInfoViewModel)
    lazy var contactInfoViewModel = ContactInfoViewModel(contactID: contactID, realmManager: RealmManager())
    
    init(rootViewController: RootNavigationController, _ contactID: Int) {
        self.rootViewController = rootViewController
        self.contactID = contactID
    }
    
    override func start() {
        loadScreen()
    }
    
    private func loadScreen() {
        contactInfoViewController.delegate = self
        
        rootViewController.pushViewController(contactInfoViewController, animated: true)
    }
    
    private func setNavigationBarPreferences() {
        rootViewController.navigationBar.prefersLargeTitles = false
        createButtons()
    }
    
    private func createButtons() {
        createEditButton()
    }
    
    private func createEditButton() {
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(goToEditScreen))
        contactInfoViewController.navigationItem.rightBarButtonItem = editButton
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
    
    func viewWillAppear() {
        setNavigationBarPreferences()
    }
    
}

extension ContactInfoViewCoordinator: EditingContactViewCoordinatorDelegate {
    
    func сoordinatorDidFinish(_ сoordinator: Coordinator) {
        self.removeChildCoordinator(сoordinator)
    }
    
}

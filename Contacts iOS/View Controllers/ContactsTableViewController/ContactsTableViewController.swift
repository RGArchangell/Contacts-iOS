//
//  ContactsTableViewController.swift
//  Contacts iOS
//
//  Created by Archangel on 09/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit

protocol ContactsTableViewControllerDelegate: class {
    func viewWillAppear()
}

class ContactsTableViewController: UIViewController {

    @IBOutlet weak var contactsTableView: ContactsTableView!
    
    weak var delegate: ContactsTableViewControllerDelegate?
    private var viewModel: ContactsTableViewModel
    
    init(viewModel: ContactsTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ContactsTableViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadContacts()
        delegate?.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.loadNames() {
            self.contactsTableView.setViewModel(viewModel: self.viewModel)
            self.contactsTableView.reloadTable()
        }
    }
    
}

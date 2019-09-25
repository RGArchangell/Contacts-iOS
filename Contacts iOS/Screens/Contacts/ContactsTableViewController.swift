//
//  ContactsTableViewController.swift
//  Contacts iOS
//
//  Created by Archangel on 09/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit

protocol ContactsTableViewControllerDelegate: class {
    func viewWillAppear(_ viewController: ContactsTableViewController)
    func didRequestGoToAddScreen(newContactID: Int)
}

class ContactsTableViewController: UIViewController {

    @IBOutlet private weak var contactsTableView: ContactsTableView!
    
    weak var delegate: ContactsTableViewControllerDelegate?
    private var viewModel: ContactsTableViewModel
    private let cellReuseIdentifier = "ContactCell"
    
    init(viewModel: ContactsTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ContactsTableViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadContacts()
        contactsTableView.setTableViewDataSource(viewController: self)
        delegate?.viewWillAppear(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.loadNames {
            self.contactsTableView.setViewModel(viewModel: self.viewModel)
            self.contactsTableView.reloadTable()
        }
    }
    
    @objc func requestGoToAddScreen() {
        let id = viewModel.getNewId()
        delegate?.didRequestGoToAddScreen(newContactID: id)
    }
    
}

extension ContactsTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.contactsSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contactKey = viewModel.contactsSectionTitles[section]
        
        guard let contactValues = viewModel.tableContactsDictionary[contactKey] else { return 0 }
        return contactValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contactCell: ContactsTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseIdentifier) as? ContactsTableViewCell else { return UITableViewCell() }
        
        let contactKey = viewModel.contactsSectionTitles[indexPath.section]
        guard let contactValues = viewModel.tableContactsDictionary[contactKey] else { return UITableViewCell() }
        
        let firstName = contactValues[indexPath.row].first
        let lastName = contactValues[indexPath.row].last
        
        contactCell.loadNames(firstName: firstName, lastName: lastName)
        return contactCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.contactsSectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.contactsSectionTitles
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let sectionTitle = viewModel.contactsSectionTitles[indexPath.section]
        let id = viewModel.tableContactsDictionary[sectionTitle]?[indexPath.row].id
        
        viewModel.deleteFromDictionary(sectionTitle, indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        viewModel.deleteContactFromDatabase(contactID: id)
        
        if viewModel.tableContactsDictionary[sectionTitle]?.isEmpty ?? false {
            viewModel.clearSection(sectionTitle, indexPath)
            tableView.reloadData()
        }
    }
    
}

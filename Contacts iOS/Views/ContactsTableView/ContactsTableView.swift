//
//  ContactsTableView.swift
//  Contacts iOS
//
//  Created by Archangel on 09/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

class ContactsTableView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var contactsSearch: UISearchBar!
    @IBOutlet private weak var contactsTable: UITableView!
    
    private let cellReuseIdentifier = "ContactCell"
    private var viewModel = ContactsTableViewModel()
    private var contactsDictionary = [String: [Name]]()
    private var contactsSectionTitles = [String]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "ContactsTableView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        setSearchBarShadow()
        setTableViewPreferences()
    }
    
    private func setTableViewPreferences() {
        let tableCell = UINib(nibName: "ContactsTableViewCell", bundle: nil)
        contactsTable.register(tableCell, forCellReuseIdentifier: cellReuseIdentifier)
        contactsTable.delegate = self
        contactsTable.dataSource = self
    }
    
    private func updateDataFromModel() {
        contactsDictionary.removeAll()
        contactsSectionTitles.removeAll()
        
        for name in viewModel.names {
            let contactKey = String(name.last.prefix(1))
            
            if var contactValues = contactsDictionary[contactKey] {
                contactValues.append(name)
                contactsDictionary[contactKey] = contactValues
            } else {
                contactsDictionary[contactKey] = [name]
            }
        }
        
        contactsSectionTitles = contactsDictionary.keys.sorted()
    }
    
    func setViewModel(viewModel: ContactsTableViewModel) {
        self.viewModel = viewModel
        updateDataFromModel()
    }
    
    func viewWillAppear() {
        contactsDictionary.removeAll()
    }
    
    func reloadTable() {
        contactsTable.reloadData()
        print("table did reload. num of cells: \(viewModel.names.count)")
    }
    
}

extension ContactsTableView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactsSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contactKey = contactsSectionTitles[section]
        
        guard let contactValues = contactsDictionary[contactKey] else { return 0 }
        return contactValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contactCell: ContactsTableViewCell = self.contactsTable.dequeueReusableCell(
            withIdentifier: cellReuseIdentifier) as? ContactsTableViewCell else { return UITableViewCell() }
        
        let contactKey = contactsSectionTitles[indexPath.section]
        guard let contactValues = contactsDictionary[contactKey] else { return UITableViewCell() }
        
        let firstName = contactValues[indexPath.row].first
        let lastName = contactValues[indexPath.row].last
        
        contactCell.loadNames(firstName: firstName, lastName: lastName)
        return contactCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactsSectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactsSectionTitles
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactInfo = contactsDictionary[contactsSectionTitles[indexPath.section]]
        let contactID = contactInfo?[indexPath.row].id
        viewModel.requestContactInfo(contactID: contactID)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let contactInfo = contactsDictionary[contactsSectionTitles[indexPath.section]]
        let contactID = contactInfo?[indexPath.row].id
        viewModel.deleteContactFromDatabase(contactID: contactID)
        
        self.updateDataFromModel()
    }
    
}

extension ContactsTableView: UISearchControllerDelegate {
    
}

extension ContactsTableView {
    
    private func setSearchBarShadow() {
        contactsSearch.layer.shadowColor = UIColor.darkGray.cgColor
        contactsSearch.layer.shadowOffset = .zero
        contactsSearch.layer.shadowOpacity = 1
        contactsSearch.layer.shadowRadius = 1
        
        let rectangle = CGRect(x: 0,
                               y: contactsSearch.frame.height,
                               width: self.frame.width,
                               height: 1)
        
        contactsSearch.layer.shadowPath = UIBezierPath(rect: rectangle).cgPath
    }
    
}

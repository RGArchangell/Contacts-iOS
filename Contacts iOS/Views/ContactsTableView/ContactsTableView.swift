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
    private var numOfCells: Int = 0
    
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
    
    func setViewModel(viewModel: ContactsTableViewModel) {
        self.viewModel = viewModel
        self.numOfCells = viewModel.firstNames.count
    }
    
    func reloadTable() {
        contactsTable.reloadData()
        print("table did reload. num of cells: \(numOfCells)")
    }
    
}

extension ContactsTableView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactCell: ContactsTableViewCell = self.contactsTable.dequeueReusableCell(
            withIdentifier: cellReuseIdentifier) as! ContactsTableViewCell
        
        let firstName = viewModel.firstNames[indexPath.row]
        let lastName = viewModel.lastNames[indexPath.row]
        contactCell.loadNames(firstName: firstName, lastName: lastName)
        return contactCell
    }
    
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

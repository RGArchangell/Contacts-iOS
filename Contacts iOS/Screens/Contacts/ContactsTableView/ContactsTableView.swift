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
    
    private var viewModel: ContactsTableViewModel?
    private var workItemForSearch: DispatchWorkItem?
    private let cellReuseIdentifier = "ContactCell"
    
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
        setSearchBarPreferences()
    }
    
    private func setTableViewPreferences() {
        let tableCell = UINib(nibName: "ContactsTableViewCell", bundle: nil)
        contactsTable.register(tableCell, forCellReuseIdentifier: cellReuseIdentifier)
        contactsTable.delegate = self
    }
    
    private func setSearchBarPreferences() {
        contactsSearch.delegate = self
    }
    
    func setTableViewDataSource(viewController: ContactsTableViewController) {
        contactsTable.dataSource = viewController
    }
    
    func setViewModel(viewModel: ContactsTableViewModel) {
        self.viewModel = viewModel
        self.viewModel?.updateModelData()
    }
    
    func reloadTable() {
        contactsTable.reloadData()
        print("table did reload. num of cells: \(String(describing: viewModel?.names.count))")
    }
    
}

extension ContactsTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.endEditing(true)
        
        guard let sectionTitle = viewModel?.contactsSectionTitles[indexPath.section] else { return }
        let contactInfo = viewModel?.tableContactsDictionary[sectionTitle]
        let contactID = contactInfo?[indexPath.row].id
        viewModel?.requestContactInfo(contactID: contactID)
    }
    
}

extension ContactsTableView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.endEditing(true)
        contactsSearch.isLoading = true
        viewModel?.performSearch(searchBar.text) {
            self.reloadTable()
            self.contactsSearch.isLoading = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        contactsSearch.isLoading = true
        self.workItemForSearch?.cancel()
        
        guard let text = searchBar.text else { return }
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.viewModel?.performSearch(text) {
                self?.reloadTable()
                self?.contactsSearch.isLoading = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        self.workItemForSearch = workItem
        
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

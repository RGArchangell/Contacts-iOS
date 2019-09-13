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
    @IBOutlet private weak var contactsSearchBar: UISearchBar!
    @IBOutlet private weak var contactsTableView: UITableView!
    
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
        contactsTableView.register(tableCell, forCellReuseIdentifier: cellReuseIdentifier)
        contactsTableView.delegate = self
    }
    
    private func setSearchBarPreferences() {
        contactsSearchBar.delegate = self
    }
    
    func setTableViewDataSource(viewController: ContactsTableViewController) {
        contactsTableView.dataSource = viewController
    }
    
    func setViewModel(viewModel: ContactsTableViewModel) {
        self.viewModel = viewModel
        self.viewModel?.updateModelData()
    }
    
    func reloadTable() {
        contactsTableView.reloadData()
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
        contactsSearchBar.isLoading = true
        viewModel?.performSearch(searchBar.text) {
            self.reloadTable()
            self.contactsSearchBar.isLoading = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        contactsSearchBar.isLoading = true
        self.workItemForSearch?.cancel()
        
        guard let text = searchBar.text else { return }
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.viewModel?.performSearch(text) {
                self?.reloadTable()
                self?.contactsSearchBar.isLoading = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        self.workItemForSearch = workItem
        
    }
    
}

extension ContactsTableView {
    
    private func setSearchBarShadow() {
        contactsSearchBar.layer.shadowColor = UIColor.darkGray.cgColor
        contactsSearchBar.layer.shadowOffset = .zero
        contactsSearchBar.layer.shadowOpacity = 1
        contactsSearchBar.layer.shadowRadius = 1
        
        let rectangle = CGRect(x: 0,
                               y: contactsSearchBar.frame.height,
                               width: self.frame.width,
                               height: 1)
        
        contactsSearchBar.layer.shadowPath = UIBezierPath(rect: rectangle).cgPath
    }
    
}

//
//  ContactsTableViewCell.swift
//  Contacts iOS
//
//  Created by Archangel on 15/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var firstNameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    
    func loadNames(firstName: String, lastName: String) {
        self.firstNameLabel.text = firstName
        self.lastNameLabel.text = lastName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

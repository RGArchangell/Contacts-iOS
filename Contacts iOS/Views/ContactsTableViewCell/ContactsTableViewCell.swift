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
    
    @IBOutlet private weak var firstName: UILabel!
    @IBOutlet private weak var lastName: UILabel!
    
    func loadNames(firstName: String, lastName: String) {
        self.firstName.text = firstName
        self.lastName.text = lastName
        print("cell created and updated")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

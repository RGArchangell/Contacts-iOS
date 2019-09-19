//
//  UIViewControllerExtensions.swift
//  Contacts iOS
//
//  Created by Archangel on 18/09/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: - Call to the phone number

    func callNumber(phoneNumber: String) {
        guard let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") else { return }
        
        let application: UIApplication = UIApplication.shared
        if application.canOpenURL(phoneCallURL) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }

}

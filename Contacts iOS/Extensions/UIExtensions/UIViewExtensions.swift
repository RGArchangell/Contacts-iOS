//
//  UIViewExtensions.swift
//  Contacts iOS
//
//  Created by Archangel on 13/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addInputAccessoryForTextFields(textFields: [UITextField],
                                        nextTextField: UITextView,
                                        dismissable: Bool,
                                        previousNextable: Bool) {
        for textField in textFields {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                
                let nextButton = UIBarButtonItem(title: "Next",
                                                 style: .plain,
                                                 target: nil,
                                                 action: nil)
                nextButton.width = 30
                nextButton.target = nextTextField
                nextButton.action = #selector(UITextField.becomeFirstResponder)
                items.append(contentsOf: [nextButton])
            }
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
}

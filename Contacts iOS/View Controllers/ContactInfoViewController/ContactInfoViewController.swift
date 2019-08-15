//
//  ContactInfoViewController.swift
//  Contacts iOS
//
//  Created by Archangel on 12/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit

protocol ContactInfoViewControllerDelegate: class {
    func viewWillAppear()
    func viewDidDisappear()
}

class ContactInfoViewController: UIViewController {

    @IBOutlet private weak var newContactView: NewContactView! {
        didSet {
            newContactView.delegate = self
        }
    }
    
    weak var delegate: ContactInfoViewControllerDelegate?
    private var viewModel: ContactInfoViewModel
    
    init(viewModel: ContactInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ContactInfoViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        delegate?.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.viewDidDisappear()
    }
    
    func getInfoFromFields() -> [String: Any] {
        let info = newContactView.getInfoFromFields()
        return info
    }
    
}

extension ContactInfoViewController: NewContactViewDelegate {
    
    func didRequestImagePicker(_ requestedView: UIView) {
        viewModel.requestImagePicker(requestedView)
    }
    
}

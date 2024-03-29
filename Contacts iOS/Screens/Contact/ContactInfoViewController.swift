//
//  ContactInfoViewController.swift
//  Contacts iOS
//
//  Created by Archangel on 16/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit

protocol ContactInfoViewControllerDelegate: class {
    func viewWillAppear(_ viewController: ContactInfoViewController)
}

class ContactInfoViewController: UIViewController {
    
    @IBOutlet private weak var contactView: ContactView!
    
    private var viewModel: ContactInfoViewModel
    
    weak var delegate: ContactInfoViewControllerDelegate?
    
    init(viewModel: ContactInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ContactInfoViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        delegate?.viewWillAppear(self)
        viewModel.loadData()
        contactView.delegate = self
        contactView.loadModel(viewModel: viewModel)
    }
    
}

extension ContactInfoViewController: ContactViewDelegate {
    
    func phoneCallInitiated(_ view: ContactView, _ phone: String) {
        self.callNumber(phoneNumber: phone)
    }
    
}

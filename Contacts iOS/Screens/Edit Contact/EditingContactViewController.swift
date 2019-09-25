//
//  EditingContactViewController.swift
//  Contacts iOS
//
//  Created by Archangel on 12/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit

protocol EditingContactViewControllerDelegate: class {
    func viewWillAppear(_ viewController: EditingContactViewController)
    func creatingAvaliable(_ viewController: EditingContactViewController)
    func creatingIsNotAvaliable(_ viewController: EditingContactViewController)
    func contactDeleted(_ viewController: EditingContactViewController)
    func contactSaved(_ viewController: EditingContactViewController)
    func imagePickerView(_ viewController: EditingContactViewController)
}

class EditingContactViewController: UIViewController {

    @IBOutlet private weak var newContactView: NewContactView! {
        didSet {
            newContactView.delegate = self
            newContactView.loadModel(viewModel: viewModel)
            if type == .edit {
                newContactView.loadFieldsFromModel(viewModel: viewModel)
                newContactView.showDeleteField()
            } else {
                newContactView.setNotePlaceholder()
            }
        }
    }
    
    weak var delegate: EditingContactViewControllerDelegate?
    private var viewModel: EditingContactViewModel
    private var type: EditorType
    
    init(viewModel: EditingContactViewModel, type: EditorType) {
        self.viewModel = viewModel
        self.type = type
        super.init(nibName: "EditingContactViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        delegate?.viewWillAppear(self)
        newContactView.checkAvaliability()
    }
    
    func handleImageUpdated(image: UIImage) {
        newContactView.avatarImageHasUpdated(image)
    }
    
    @objc func saveContact() {
        let contact = getInfoFromFields()
        viewModel.saveContactData(newContact: contact)
        delegate?.contactSaved(self)
    }
    
    private func getInfoFromFields() -> NewContact {
        let info = newContactView.getInfoFromFields()
        return info
    }
    
}

extension EditingContactViewController: NewContactViewDelegate {
    
    func deleteRequested(_ view: NewContactView) {
        viewModel.deleteContactFromDatabase()
        delegate?.contactDeleted(self)
    }
    
    func createIsAvaliable(_ view: NewContactView) {
        delegate?.creatingAvaliable(self)
    }
    
    func createIsNotAvaliable(_ view: NewContactView) {
        delegate?.creatingIsNotAvaliable(self)
    }
    
    func imagePickerView(_ view: NewContactView) {
        delegate?.imagePickerView(self)
    }
    
    func imageHasUpdated(_ view: NewContactView) {
        viewModel.avatarHasUpdated()
    }
    
}

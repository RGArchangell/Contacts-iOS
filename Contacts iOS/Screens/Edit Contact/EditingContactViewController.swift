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
    func creatingAvaliable()
    func creatingIsNotAvaliable()
    func contactDeleted()
    func contactSaved()
    func imagePickerView(_ requestedView: UIView)
}

class EditingContactViewController: UIViewController {

    @IBOutlet private weak var newContactView: NewContactView! {
        didSet {
            newContactView.delegate = self
            newContactView.loadModel(viewModel: viewModel)
            if type == .edit {
                newContactView.loadFieldsFromModel(viewModel: viewModel)
                newContactView.showDeleteField()
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
    
    @objc func saveContact() {
        let contact = getInfoFromFields()
        viewModel.saveContactData(newContact: contact)
    }
    
    private func getInfoFromFields() -> NewContact {
        let info = newContactView.getInfoFromFields()
        return info
    }
    
}

extension EditingContactViewController: NewContactViewDelegate {
    
    func deleteRequested() {
        viewModel.deleteContactFromDatabase()
        delegate?.contactDeleted()
    }
    
    func createIsAvaliable() {
        delegate?.creatingAvaliable()
    }
    
    func createIsNotAvaliable() {
        delegate?.creatingIsNotAvaliable()
    }
    
    func didRequestImagePicker(_ requestedView: UIView) {
        delegate?.imagePickerView(requestedView)
    }
    
    func imageHasUpdated() {
        viewModel.avatarHasUpdated()
    }
    
}

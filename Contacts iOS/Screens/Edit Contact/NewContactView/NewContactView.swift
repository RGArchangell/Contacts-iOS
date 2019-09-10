//
//  NewContactView.swift
//  Contacts iOS
//
//  Created by Archangel on 12/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit

public var pickedAvatar = UIImage()

private let ringtones = ["Default",
                         "Sunset",
                         "Normandy",
                         "Golden Wind",
                         "Darkside",
                         "Lose Yourself"]

protocol NewContactViewDelegate: class {
    func didRequestImagePicker(_ requestedView: UIView)
    func imageHasUpdated()
    func createIsAvaliable()
    func createIsNotAvaliable()
    func deleteRequested()
}

class NewContactView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var firstName: UITextField!
    @IBOutlet private weak var lastName: UITextField!
    @IBOutlet private weak var avatar: UIButton!
    @IBOutlet private weak var phone: UITextField!
    @IBOutlet private weak var ringtone: UIButton!
    @IBOutlet private weak var note: UITextView! {
        didSet { note.delegate = self }
    }
    @IBOutlet private weak var deleteField: UIStackView! {
        didSet { deleteField.isHidden = true }
    }
    @IBOutlet private weak var contactScrollView: UIScrollView!
    
    private var toolBar = UIToolbar()
    private var picker = UIPickerView()
    private var pickedRingtone = "Default"
    private var viewModel: EditingContactViewModel?
    
    weak var delegate: NewContactViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "NewContactView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        addInputAccessoryForTextFields(textFields: [phone], nextTextField: note, dismissable: false, previousNextable: true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        firstName.addTarget(lastName, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
        lastName.addTarget(phone, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
    }
    
    private func checkMainFields() -> Bool {
        let firstNameText = firstName.text
        let lastNameText = lastName.text
        let phoneText = phone.text
        
        guard let result = viewModel?.checkFields(firstName: firstNameText,
                                                  lastName: lastNameText,
                                                  phone: phoneText) else { return false }
        
        return result
    }
    
    private func checkContentSize() {
        if note.contentSize.height >= 200 {
            note.isScrollEnabled = true
        } else {
            note.frame.size.height = note.contentSize.height
            note.isScrollEnabled = false
        }
    }
    
    func checkAvaliability() {
        if checkMainFields() {
            delegate?.createIsAvaliable()
        } else {
            delegate?.createIsNotAvaliable()
        }
    }
    
    func getInfoFromFields() -> NewContact {
        
        var notes = note.text
        if note.text.isEmptyOrNil { notes = "-" }
        
        let contact = NewContact(
            firstName: firstName.text ?? "",
            lastName: lastName.text ?? "",
            phone: phone.text ?? "",
            ringtone: ringtone.titleLabel?.text ?? "",
            notes: notes ?? "",
            avatar: avatar.image(for: .normal) ?? UIImage())
        
        return contact
    }
    
    func loadModel(viewModel: EditingContactViewModel) {
        self.viewModel = viewModel
    }
    
    func loadFieldsFromModel(viewModel: EditingContactViewModel) {
        firstName.text = viewModel.firstName
        lastName.text = viewModel.lastName
        phone.text = viewModel.phone
        ringtone.setTitle(viewModel.ringtone, for: .normal)
        note.text = viewModel.notes
        avatar.setImage(viewModel.avatar?.circleMasked, for: .normal)
        
        checkContentSize()
    }
    
    func showDeleteField() {
        deleteField.isHidden = false
    }
    
    func avatarImageHasUpdated(_ newImage: UIImage) {
        self.avatar.contentMode = .scaleToFill
        self.avatar.setImage(newImage, for: .normal)
        delegate?.imageHasUpdated()
    }
    
    @IBAction private func changeRingtoneInitiated(_ sender: UIButton) {
        self.endEditing(true)
        createPicker()
    }
    
    @IBAction private func changeAvatarInitiated(_ sender: UIButton) {
        self.endEditing(true)
        delegate?.didRequestImagePicker(self)
    }
    
    @IBAction private func fieldsEditingChanged(_ sender: UITextField) {
        checkAvaliability()
    }
    
    @IBAction private func deleteButtonTapped(_ sender: UIButton) {
        delegate?.deleteRequested()
    }
    
}

extension NewContactView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    private func createPicker() {
        picker = UIPickerView()
        picker.delegate = self
        picker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .scaleToFill
        
        picker.frame = CGRect(x: 0.0,
                              y: self.frame.height - 217,
                              width: UIScreen.main.bounds.size.width,
                              height: 217)
        self.addSubview(picker)
        
        toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                          y: self.frame.height - 267,
                                          width: UIScreen.main.bounds.size.width,
                                          height: 50))
        toolBar.barStyle = .default
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))
        toolBar.items = [flexible, doneButton]
        self.addSubview(toolBar)
    }
    
    @objc func onDoneButtonTapped() {
        ringtone.titleLabel?.text = pickedRingtone
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ringtones.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ringtones[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedRingtone = ringtones[row]
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard var userInfo = notification.userInfo else { return }
        guard let keyboard = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        var keyboardFrame: CGRect = (keyboard).cgRectValue
        keyboardFrame = self.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = self.contactScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 100
        contactScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        contactScrollView.contentInset = contentInset
    }
    
}

extension NewContactView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let viewModel = viewModel else { return false }
        if viewModel.checkEnter(text) {
            textView.resignFirstResponder()
            return false
        }
        
        return viewModel.checkTextForReplacing(textView: textView, range: range, text: text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height >= 200 {
            textView.isScrollEnabled = true
        } else {
            textView.frame.size.height = textView.contentSize.height
            textView.isScrollEnabled = false 
        }
    }
    
}

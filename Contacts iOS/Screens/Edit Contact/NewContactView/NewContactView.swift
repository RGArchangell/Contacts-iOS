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
    func imagePickerView(_ view: NewContactView)
    func imageHasUpdated(_ view: NewContactView)
    func createIsAvaliable(_ view: NewContactView)
    func createIsNotAvaliable(_ view: NewContactView)
    func deleteRequested(_ view: NewContactView)
}

class NewContactView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var avatarButton: UIButton!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var ringtoneButton: UIButton!
    @IBOutlet private weak var noteTextView: UITextView! {
        didSet { noteTextView.delegate = self }
    }
    @IBOutlet private weak var deleteFieldStackView: UIStackView! {
        didSet { deleteFieldStackView.isHidden = true }
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
        
        addInputAccessoryForTextFields(textFields: [phoneTextField],
                                       nextTextField: noteTextView,
                                       dismissable: false,
                                       previousNextable: true)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        firstNameTextField.addTarget(lastNameTextField, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
        lastNameTextField.addTarget(phoneTextField, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
    }
    
    private func checkMainFields() -> Bool {
        let firstNameText = firstNameTextField.text
        let lastNameText = lastNameTextField.text
        let phoneText = phoneTextField.text
        
        guard let result = viewModel?.checkFields(firstName: firstNameText,
                                                  lastName: lastNameText,
                                                  phone: phoneText) else { return false }
        
        return result
    }
    
    private func checkContentSize() {
        if noteTextView.contentSize.height >= 200 {
            noteTextView.isScrollEnabled = true
        } else {
            noteTextView.frame.size.height = noteTextView.contentSize.height
            noteTextView.isScrollEnabled = false
        }
    }
    
    func checkAvaliability() {
        if checkMainFields() {
            delegate?.createIsAvaliable(self)
        } else {
            delegate?.createIsNotAvaliable(self)
        }
    }
    
    func setNotePlaceholder() {
        noteTextView.text = "-"
        noteTextView.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    func getInfoFromFields() -> NewContact {
        
        var notes = noteTextView.text
        if noteTextView.text.isEmptyOrNil { notes = "-" }
        
        let contact = NewContact(
            firstName: firstNameTextField.text ?? "",
            lastName: lastNameTextField.text ?? "",
            phone: phoneTextField.text ?? "",
            ringtone: pickedRingtone,
            notes: notes ?? "",
            avatar: avatarButton.image(for: .normal) ?? UIImage())
        
        return contact
    }
    
    func loadModel(viewModel: EditingContactViewModel) {
        self.viewModel = viewModel
    }
    
    func loadFieldsFromModel(viewModel: EditingContactViewModel) {
        firstNameTextField.text = viewModel.firstName
        lastNameTextField.text = viewModel.lastName
        phoneTextField.text = viewModel.phone
        ringtoneButton.setTitle(viewModel.ringtone, for: .normal)
        noteTextView.text = viewModel.notes
        avatarButton.setImage(viewModel.avatar?.circleMasked, for: .normal)
        
        if noteTextView.text == "-" { setNotePlaceholder() }
        checkContentSize()
    }
    
    func showDeleteField() {
        deleteFieldStackView.isHidden = false
    }
    
    func avatarImageHasUpdated(_ newImage: UIImage) {
        self.avatarButton.contentMode = .scaleToFill
        self.avatarButton.setImage(newImage, for: .normal)
        delegate?.imageHasUpdated(self)
    }
    
    @IBAction private func changeRingtoneInitiated(_ sender: UIButton) {
        self.endEditing(true)
        createPicker()
    }
    
    @IBAction private func changeAvatarInitiated(_ sender: UIButton) {
        self.endEditing(true)
        delegate?.imagePickerView(self)
    }
    
    @IBAction private func fieldsEditingChanged(_ sender: UITextField) {
        checkAvaliability()
    }
    
    @IBAction private func deleteButtonTapped(_ sender: UIButton) {
        delegate?.deleteRequested(self)
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
        ringtoneButton.setTitle(pickedRingtone, for: .normal)
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
        guard let userInfo = notification.userInfo else { return }
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) && textView.text == "-" else { return }
        textView.text = ""
        textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.isEmpty else { return }
        textView.text = "-"
        textView.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
}

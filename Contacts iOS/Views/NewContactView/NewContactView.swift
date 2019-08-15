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
}

class NewContactView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var firstName: UITextField!
    @IBOutlet private weak var lastName: UITextField!
    @IBOutlet private weak var avatar: UIButton!
    @IBOutlet private weak var phone: UITextField!
    @IBOutlet private weak var ringtone: UIButton!
    @IBOutlet private weak var note: UITextField!
    
    private var toolBar = UIToolbar()
    private var picker = UIPickerView()
    private var pickedRingtone = "Default"
    
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
    }
    
    func getInfoFromFields() -> [String: Any] {
        let data = ["firstName": firstName.text ?? "",
                    "lastName": lastName.text ?? "",
                    "phone": phone.text ?? "",
                    "ringtone": ringtone.titleLabel?.text ?? "",
                    "notes": note.text ?? "",
                    "avatar": avatar.image(for: .normal) ?? UIImage()] as [String : Any]
        
        return data
    }
    
    @IBAction private func changeRingtoneInitiated(_ sender: UIButton) {
        createPicker()
    }
    
    @IBAction private func changeAvatarInitiated(_ sender: UIButton) {
        delegate?.didRequestImagePicker(self)
    }
    
}

extension NewContactView: RootNavigationControllerDelegate {
    
    func avatarImageHasUpdated(_ newImage: UIImage) {
        self.avatar.contentMode = .scaleAspectFit
        self.avatar.setImage(newImage, for: .normal)
    }
    
}

extension NewContactView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    private func createPicker() {
        picker = UIPickerView()
        picker.delegate = self
        picker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        picker.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKey: "textColor")
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
    
}

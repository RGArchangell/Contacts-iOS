//
//  ContactView.swift
//  Contacts iOS
//
//  Created by Archangel on 14/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

protocol ContactViewDelegate: class {
    func phoneCallInitiated(_ phone: String)
}

class ContactView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var phoneButton: UIButton!
    @IBOutlet private weak var ringtoneLabel: UILabel!
    @IBOutlet private weak var noteTextView: UITextView!
    
    weak var delegate: ContactViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "ContactView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    private func checkContentSize() {
        if noteTextView.contentSize.height >= 200 {
            noteTextView.isScrollEnabled = true
        } else {
            noteTextView.frame.size.height = noteTextView.contentSize.height
            noteTextView.isScrollEnabled = false
        }
    }
    
    func loadModel(viewModel: ContactInfoViewModel) {
        nameLabel.text = viewModel.name
        phoneButton.setTitle(viewModel.phone, for: .normal)
        ringtoneLabel.text = viewModel.ringtone
        noteTextView.text = viewModel.notes
        avatarImageView.image = viewModel.avatar?.circleMasked
        checkContentSize()
    }

    @IBAction private func phoneButtonTouched(_ sender: UIButton) {
        guard let phoneNumber = phoneButton.title(for: .normal) else { return }
        delegate?.phoneCallInitiated(phoneNumber)
    }
    
}

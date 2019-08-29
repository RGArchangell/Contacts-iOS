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
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var phone: UIButton!
    @IBOutlet private weak var ringtone: UILabel!
    @IBOutlet private weak var note: UITextView!
    
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
        if note.contentSize.height >= 200 {
            note.isScrollEnabled = true
        } else {
            note.frame.size.height = note.contentSize.height
            note.isScrollEnabled = false
        }
    }
    
    func loadModel(viewModel: ContactInfoViewModel) {
        name.text = viewModel.name
        phone.setTitle(viewModel.phone, for: .normal)
        ringtone.text = viewModel.ringtone
        note.text = viewModel.notes
        avatar.image = viewModel.avatar?.circleMasked
        checkContentSize()
    }

    @IBAction private func phoneButtonTouched(_ sender: UIButton) {
        guard let phoneNumber = phone.title(for: .normal) else { return }
        delegate?.phoneCallInitiated(phoneNumber)
    }
    
}

//
//  ContactView.swift
//  Contacts iOS
//
//  Created by Archangel on 14/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation
import UIKit

class ContactView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var phone: UIButton!
    @IBOutlet private weak var ringtone: UILabel!
    @IBOutlet private weak var note: UILabel!
    
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
    
    func loadModel(viewModel: ContactInfoViewModel) {
        
    }
    
}

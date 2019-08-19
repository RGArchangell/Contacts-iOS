//
//  OptionalExtensions.swift
//  Contacts iOS
//
//  Created by Archangel on 18/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation

extension Optional where Wrapped: Collection {
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}

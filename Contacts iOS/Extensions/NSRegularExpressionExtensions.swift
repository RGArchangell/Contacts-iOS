//
//  NSRegularExpressionExtensions.swift
//  Contacts iOS
//
//  Created by Archangel on 28/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
}

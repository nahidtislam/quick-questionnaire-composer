//
//  String+NeatDecimal.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 11/03/2023.
//

import Foundation

extension String {
    init<Number: BinaryFloatingPoint>(neatDecimal decimal: Number) {
        let truncated = Int(decimal)
        if Number(truncated) == decimal {
            self = String(truncated)
        } else {
            self = "\(decimal)"
        }
    }
}


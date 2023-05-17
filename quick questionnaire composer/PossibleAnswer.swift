//
//  PossibleAnswer.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 14/05/2023.
//

import SwiftUI

struct PossibleAnswer: HierarchableData {
    var id = UUID()
    
    var name: String
    var symbol: String?
    
    static func validate(possibleAnswer: PossibleAnswer) -> Bool {
        if possibleAnswer.name == "" {
            return false
        } else if let symbol = possibleAnswer.symbol {
            return UIImage(systemName: symbol) != nil
        } else {
            return true
        }
    }
}

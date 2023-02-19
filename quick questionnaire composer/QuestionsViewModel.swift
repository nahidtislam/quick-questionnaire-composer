//
//  QuestionsViewModel.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

class QuestionsViewModel: ObservableObject {
    @Published var cards: [QuestionCard]
    
    init(cards: [QuestionCard]) {
        self.cards = cards
    }
}

extension Array: Codable where Element == QuestionCard {
    
}

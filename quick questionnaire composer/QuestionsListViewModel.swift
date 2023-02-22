//
//  QuestionsListViewModel.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

class QuestionsListViewModel: ObservableObject {
    
    @AppStorage("cards") var cards: [QuestionCard] = []
    
    @Published var editingAt: Int?
    
    func addQuestion() {
        let q = QuestionCard(title: "", possibleAnswers: [])
        cards.append(q)
    }
}

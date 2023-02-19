//
//  QuestionCard.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

struct QuestionCard: Identifiable {
    let id = UUID()
    
    let title: String
    let subtitle: String?
    
    let bgColor = Color(uiColor: .systemBackground)
    
    let possibleAnswers: [Answer]
    let allCorrectAnswersRequired = false
    
    var correctAnswersCount: Int {
        possibleAnswers.filter { $0.isCorrect }.count
    }
    
}

extension QuestionCard {
    struct Answer {
        let id = UUID()
        let name: String
        
        let color: SwiftUI.Color
        let shape: SwiftUI.Image
        
        let isCorrect: Bool
    }
}


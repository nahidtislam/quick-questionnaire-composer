//
//  QuestionCard.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

struct QuestionCard: Identifiable {
    var id = UUID()
    
    let title: String
    let subtitle: String?
    
    let marks: Double
    
//    let bgColor = Color(uiColor: .systemBackground)
    
    let possibleAnswers: [Answer]
    var allCorrectAnswersRequired = false
    
    var correctAnswersCount: Int {
        possibleAnswers.filter { $0.isCorrect }.count
    }
    
}

extension QuestionCard: Codable {
    struct Answer: Codable, Identifiable {
        var id = UUID()
        var name: String
        
        let style: StyleInfo?
        
        var isCorrect: Bool
        
        struct StyleInfo: Codable {
            let color: String
            let shape: String
        }
        
        var color: SwiftUI.Color {
            Color(hex: style?.color ?? "fail it lol") ?? .primary
        }
        
        var shape: SwiftUI.Image { Image(systemName: style?.shape ?? "circle.fill") }
    }
    
    init(title: String, subtitle: String? = nil, possibleAnswers: [Answer], allCorrectAnswersRequired: Bool = false) {
        self.id = UUID()
        
        self.title = title
        self.subtitle = subtitle
        self.marks = Double(possibleAnswers.count - 1)
        self.possibleAnswers = possibleAnswers
        self.allCorrectAnswersRequired = allCorrectAnswersRequired
    }
}



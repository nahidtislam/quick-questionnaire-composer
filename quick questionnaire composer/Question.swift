//
//  Question.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 14/05/2023.
//

import SwiftUI

struct Question: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var title: String
    var subtitle: String?
    
    var possibleAnswers: [PossibleAnswer]
    var correctAnswersID: Set<UUID>
    
    var marks: Double
    var allAnswersRequired: Bool
    
    static func validate(question: Question) -> Bool {
        question.title != "" &&
        (question.subtitle != nil && question.subtitle! != "") &&
        validate(possibleAnswers: question.possibleAnswers) &&
        question.correctAnswersID.count > 0 &&
        question.marks > 0
    }
    
    static func validate(possibleAnswers: [PossibleAnswer]) -> Bool {
//        !possibleAnswers.contains(where: { answer in
//            answer.name == "" || (answer.symbol != nil && UIImage(systemName: answer.symbol!) == nil)
//        })
        !possibleAnswers.contains(where: { !PossibleAnswer.validate(possibleAnswer: $0)})
    }
}

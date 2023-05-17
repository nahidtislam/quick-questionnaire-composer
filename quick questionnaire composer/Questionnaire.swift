//
//  Questionnaire.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 14/05/2023.
//

import SwiftUI

struct Questionnaire: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var name: String
    var description: String?
    var symbol: String?
    
    var questions: [Question]
    
    var completed = false
    
    static func validate(questionnaire: Questionnaire) -> Bool {
        questionnaire.name != "" &&
        (questionnaire.description != nil || questionnaire.description! != "") &&
        (questionnaire.symbol != nil && UIImage(systemName: questionnaire.symbol!) == nil) &&
        !questionnaire.questions.contains(where: { !Question.validate(question: $0)})
    }
}

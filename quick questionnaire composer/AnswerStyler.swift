//
//  AnswerStyler.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 03/03/2023.
//

import SwiftUI

struct AnswerStyler: Equatable {
    
    typealias Info = QuestionCard.Answer.StyleInfo
    
    var color = Color.clear
    var shape = ""
    var answerScheme: ColorScheme? = nil
    
    var staticInfo: Info {
        .init(color: color.hexValue!, shape: shape, accent: answerScheme?.schemeDesc)
    }
    
    var styleIsValid: Bool { color != .clear && color.hexValue != nil && shape != "" }
    
    func genrateInfo() -> Info? { styleIsValid ? staticInfo : nil }
    
    func update(answer: inout QuestionCard.Answer) {
        let updated = QuestionCard.Answer(id: answer.id, name: answer.name, style: genrateInfo(), isCorrect: answer.isCorrect)
        answer = updated
    }
    
    mutating func readStatic(style: QuestionCard.Answer.StyleInfo) {
        self.color = Color(hex: style.color, colorSpace: .displayP3)!
        self.shape = style.shape
        self.answerScheme = style.accentScheme
    }
}

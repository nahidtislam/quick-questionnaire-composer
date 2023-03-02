//
//  AnswerEditor+Model.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 02/03/2023.
//

import SwiftUI

extension AnswerEditor {
    func loadStyles() {
        if let style = answer.style {
            customShape = style.shape
            customColor = Color(hex: style.color, colorSpace: .displayP3)!
            answerScheme = style.accentScheme
        }
    }
    
    func addToStyle() {
        let colorHex: String? = {
            guard let colorComp = customColor.cgColor?.components else { return nil }
            guard customColor != .clear else { return nil }
            let colorR = Int(colorComp[0] * 255)
            let colorG = Int(colorComp[1] * 255)
            let colorB = Int(colorComp[2] * 255)
            
            return String(format:"#%02x%02x%02x", colorR, colorG, colorB)
        }()
        
        guard let colorHex, customShape != "" else { removeStyle(); return }
        
        let style = QuestionCard.Answer.StyleInfo(color: colorHex, shape: customShape)
        
        setStyle(style)
    }
    
    func setStyle(_ style: QuestionCard.Answer.StyleInfo) {
        answer = QuestionCard.Answer(id: answer.id,
                            name: answer.name,
                            style: style,
                            isCorrect: answer.isCorrect)
    }
    
    private func removeStyle() {
        answer = QuestionCard.Answer(id: answer.id,
                            name: answer.name,
                            style: nil,
                            isCorrect: answer.isCorrect)
    }
    
}

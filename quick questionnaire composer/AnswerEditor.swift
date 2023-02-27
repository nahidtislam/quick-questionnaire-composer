//
//  AnswerEditor.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 27/02/2023.
//

import SwiftUI

struct AnswerEditor: View {
    
    @Binding var answer: QuestionCard.Answer
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            HStack {
                answer.shape
                    .resizable()
                    .foregroundColor(answer.color)
                    .frame(width: 20, height: 20)
                TextField("answer name", text: $answer.name)
                    .font(.title2)
            }
            .transition(.move(edge: .bottom))
            Toggle("is correct", isOn: $answer.isCorrect)
        }
        .background(AnswerEditor.defaultColor(when: answer.isCorrect, colorScheme: colorScheme))
    }
    
    static func defaultColor(when correct: Bool, colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return correct ? Color(hex: "#228A44")! : Color(hex: "#AA1F1A")!
        case .light:
            return correct ? Color(hex: "#99EEBB")! : Color(hex: "#FAAAB5")!
        @unknown default:
            fatalError("new color dropped")
        }
    }
    
}


struct AnswerEditor_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AnswerEditor(answer: .constant(.init(name: "answer title", style: nil, isCorrect: true)))
        }
        .padding(20)
    }
}

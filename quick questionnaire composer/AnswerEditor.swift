//
//  AnswerEditor.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 27/02/2023.
//

import SwiftUI

struct AnswerEditor: View {
    
    @Binding var answer: QuestionCard.Answer
    @State var isStyling = false
    @State var customColor = Color.clear
    @State var customShape = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    var uniPadding: CGFloat = 0
    var styleTransition: Animation = .interactiveSpring()
    
    var body: some View {
        VStack {
            HStack {
                answer.shape
                    .resizable()
                    .foregroundColor(answer.color)
                    .frame(width: 20, height: 20)
                TextField("answer name", text: $answer.name)
                    .font(.title2)
                Button {
                    withAnimation(styleTransition) {
                        isStyling.toggle()
                    }
                } label: {
                    Image(systemName: isStyling ? "chevron.down.circle.fill" : "chevron.right.square")
                        .resizable()
                        .frame(width: 18, height: 18)
                }

            }
            .transition(.move(edge: .bottom))
            Toggle("is correct", isOn: $answer.isCorrect)
            
            if isStyling {
                HStack {
                    ColorPicker("answer color", selection: $customColor, supportsOpacity: false)
                    if customColor != .clear {
                        Button {
                            withAnimation { customColor = .clear }
                        } label: {
                            Image(systemName: "clear.fill")
                        }

                    }
                }
                TextField("glyth", text: $customShape)
            }
        }
        .padding(uniPadding)
        .background(bg)
        .onAppear {
            loadStyles()
        }
    }
    
    var bg: Color {
        Color(hex: answer.style?.color ?? "") ?? AnswerEditor.defaultColor(when: answer.isCorrect, colorScheme: colorScheme)
    }
    
    private func loadStyles() {
        if let style = answer.style {
            customShape = style.shape
            customColor = Color(hex: style.color)!
        }
    }
    
    private func addToStyle() {
        let colorHex: String? = {
            guard let colorComp = customColor.cgColor?.components else { return nil }
            let colorR = colorComp[0]
            let colorG = colorComp[1]
            let colorB = colorComp[2]
            return String(format:"#%02X%02X%02X", colorR, colorG, colorB)
        }()
        
        guard let colorHex, customShape != "" else { return }
        
        let style = QuestionCard.Answer.StyleInfo(color: colorHex, shape: customShape)
        
        answer = QuestionCard.Answer(id: answer.id,
                            name: answer.name,
                            style: style,
                            isCorrect: answer.isCorrect)
    }
    
    public func padding(_ value: CGFloat) -> Self {
        var new = self
        new.uniPadding = value
        
        return new
    }
    
    public func styleTransition(_ value: Animation) -> Self {
        var new = self
        new.styleTransition = value
        
        return new
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
            AnswerEditor(answer: .constant(.init(name: "default correct", style: nil, isCorrect: true)))
            AnswerEditor(answer: .constant(.init(name: "default incorrect", style: nil, isCorrect: false)))
            AnswerEditor(answer: .constant(.init(name: "styled", style: .init(color: "#3388ee", shape: "circle"), isCorrect: false)))
        }
        .padding(20)
    }
}

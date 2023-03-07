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
    @State var activeStyle = AnswerStyler()
    
    @Environment(\.colorScheme) var colorScheme
    
    var uniPadding: CGFloat = 0
    var styleTransition: Animation = .interactiveSpring()
    var stylerAction: ((Bool) -> Void) = { _ in }
    
    var body: some View {
        VStack {
            HStack {
                answer.shape
                    .resizable()
                    .frame(width: 20, height: 20)
                TextField("answer name", text: $answer.name)
                    .font(.title2)
                Button {
                    withAnimation(styleTransition) {
                        isStyling.toggle()
                    }
                    stylerAction(isStyling)
                } label: {
                    Image(systemName: isStyling ? "chevron.down.circle.fill" : "chevron.right.square")
                        .resizable()
                        .frame(width: 18, height: 18)
                }

            }
            .transition(.move(edge: .bottom))
            TickBox(title: "is correct", isOn: $answer.isCorrect, imagePair: [true : Image(systemName: "checkmark.circle.fill"), false : Image(systemName: "tag.slash")])
//            Toggle("is correct", isOn: $answer.isCorrect)
//                .toggleStyle(.button)
            
            if isStyling {
                BackgroundColorPicker(selection: $activeStyle.color, accentSchme: $activeStyle.answerScheme, name: answer.name, label: "answer background color")
                TextField("glyth", text: $activeStyle.shape)
            }
        }
        .padding(uniPadding)
        .foregroundColor(accentColor)
        .background(bg)
        .onAppear {
            if let style = answer.style { activeStyle.readStatic(style: style) }
//            vm.answer = self.answer
        }
        .onChange(of: activeStyle) { newValue in
            newValue.update(answer: &answer)
        }
    }
    
    private var bg: Color {
        Color(hex: answer.style?.bgInfo.color ?? "", colorSpace: .displayP3) ?? AnswerEditor.defaultColor(when: answer.isCorrect, colorScheme: colorScheme)
    }
    
    private var accentColor: Color {
        answer.style?.bgInfo.accentGraphic ?? .primary
//        guard let scheme = activeStyle.answerScheme, answer.style != nil else { return .primary }
//        return scheme == .dark ? .black : .white
    }
    
    static func defaultColor(when correct: Bool, colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return correct ? Color(hex: "#228A44", colorSpace: .displayP3)! : Color(hex: "#AA1F1A", colorSpace: .displayP3)!
        case .light:
            return correct ? Color(hex: "#99EEBB", colorSpace: .displayP3)! : Color(hex: "#FAAAB5", colorSpace: .displayP3)!
        @unknown default:
            fatalError("new color dropped")
        }
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
    
    public func styleTransitionCompetion(_ value: @escaping ((Bool) -> Void)) -> Self {
        var new = self
        new.stylerAction = value
        
        return new
    }
}


struct AnswerEditorView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AnswerEditor(answer: .constant(.init(name: "default correct", style: nil, isCorrect: true)))
            AnswerEditor(answer: .constant(.init(name: "default incorrect", style: nil, isCorrect: false)))
            AnswerEditor(answer: .constant(.init(name: "styled", style: .init(color: "#3388ee", shape: "circle"), isCorrect: false)))
        }
        .padding(20)
    }
}

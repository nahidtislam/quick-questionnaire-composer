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
                    if activeStyle.color != .clear {
                        Button {
                            withAnimation { activeStyle.color = .clear }
                        } label: {
//                            Image(systemName: "clear.fill")
                            Text("clear")
                                .font(.footnote.weight(.bold).width(.condensed))
                                .padding(.horizontal, 4)
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                                .cornerRadius(8)
                                .padding(.trailing, -6)
                        }
                    }
                    ColorPicker(selection: $activeStyle.color, supportsOpacity: false) {
                        ZStack{
                            // this is displayed to the actual picker
                            Text(answer.name)
                                .frame(width: 0, height: 0)
                                .opacity(0)
                                .foregroundColor(.clear)
                            // shown to user before invoking picker
                            Text("answer background color")
                                .font(.subheadline.width(.condensed))
                        }
                    }
                    Picker("content accent", selection: $activeStyle.answerScheme) {
                        Text("dark")
                            .tag(ColorScheme.dark)
                        Text("light")
                            .tag(ColorScheme.light)
                        Text("default")
                            .tag(Optional<ColorScheme>.none)
                    }
                    .pickerStyle(.automatic)
//                    .scaleEffect(x: 0.85)
                }
                TextField("glyth", text: $activeStyle.shape)
            }
        }
        .padding(uniPadding)
//        .foregroundColor(answerScheme ?? colorScheme == .dark ? .white : .black)
        .background(bg)
        .onAppear {
            if let style = answer.style { activeStyle.readStatic(style: style) }
//            vm.answer = self.answer
        }
        .onChange(of: activeStyle) { newValue in
            newValue.update(answer: &answer)
        }
    }
    
    var bg: Color {
        Color(hex: answer.style?.color ?? "", colorSpace: .displayP3) ?? AnswerEditor.defaultColor(when: answer.isCorrect, colorScheme: colorScheme)
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

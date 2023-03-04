//
//  QuestionView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 22/02/2023.
//

import SwiftUI

struct QuestionView: View {
    
    var question: QuestionCard
    
    var qSpace: Namespace.ID
    
    @State var showingAnswers = false
    var answerGridItem: [GridItem] {
        [
            .init(),
            .init()
        ]
    }
    
    static func defaultBG(scheme colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "#1E1E1E", colorSpace: .displayP3)! : Color(hex: "#EEEEEE", colorSpace: .displayP3)!
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(question.title)
                .matchedGeometryEffect(id: question.generateNamespace(for: .title), in: qSpace)
                .font(.title)
                .padding(.horizontal, 10)
            line
            if let desc = question.subtitle {
                Text(desc)
                    .matchedGeometryEffect(id: question.generateNamespace(for: .subtitle), in: qSpace)
                    .font(.title2)
                    .padding(.horizontal, 10)
            }
            HStack {
                Text("possible answers: ")
                    .matchedGeometryEffect(id: "q_card-\(question.id):possible_answers(text)", in: qSpace)
                    .onTapGesture {
                        showingAnswers.toggle()
                    }
                Spacer()
                Text("\(question.possibleAnswers.count)")
                    .matchedGeometryEffect(id: "q_card-\(question.id):possible_answers(value)", in: qSpace)
            }
            if question.possibleAnswers.count > 2 {
                HStack {
                    Text("all answers required: ")
                    Spacer()
                    Text("\(question.allCorrectAnswersRequired ? "yes" : "no")")
                }
                .matchedGeometryEffect(id: "q_card-\(question.id):all_answers_needed", in: qSpace)
            }
            if showingAnswers {
                LazyVGrid(columns: answerGridItem) {
                    ForEach(question.possibleAnswers) { answer in
                        HStack {
                            answer.shape
                            Text(answer.name)
                        }
                        .frame(width: 120, height: 90)
                        .foregroundColor((answer.style?.accentScheme == .dark ? .black : .white) ?? .primary)
                        .background(Color(hex: answer.style?.color ?? "black", colorSpace: .displayP3) ?? AnswerEditor.defaultColor(when: answer.isCorrect, colorScheme: colorScheme))
                        .cornerRadius(30)
                    }
                }
            }
        }
        .padding()
        .background(bg)
        .cornerRadius(16)
        .padding(12)
//        .background(bg.saturation(0.8).brightness(0.1))
        .background(bg.opacity(0.75))
        .cornerRadius(20)
        .padding(8)
//        .background(bg.saturation(0.6).brightness(0.2))
        .background(bg.opacity(0.5))
        .cornerRadius(24)
    }
    
    var line: some View {
        Rectangle()
            .frame(height: 3)
    }
    
    var bg: Color {
//        return .blue
        if let savedColor = Color(hex: question.bgColorHex ?? "fail it", colorSpace: .displayP3) {
            return savedColor
        } else {
            return QuestionView.defaultBG(scheme: colorScheme)
        }
    }
    
    private func makeNamespace(for field: QuestionCard.FieldIdentifier) -> String {
        //TODO: make this a protocol
        field.namespace(question: question)
    }
}

struct QuestionView_Previews: PreviewProvider {
    @Namespace static var previewNamespace
    
    static var previews: some View {
        QuestionView(question: QuestionCard(title: "test", subtitle: "the desc", possibleAnswers: [.init(name: "ans1", style: nil, isCorrect: true), .init(name: "ans2", style: .init(color: "#2080FF", shape: "arrow.up.and.down.square.fill"), isCorrect: false)], allCorrectAnswersRequired: true), qSpace: previewNamespace)
    }
}

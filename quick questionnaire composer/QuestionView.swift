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
                    .matchedGeometryEffect(id: "q_card-\(question.id):describing=answers_label", in: qSpace)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showingAnswers.toggle()
                        }
                    }
                Spacer()
                Text("\(question.possibleAnswers.count)")
                    .matchedGeometryEffect(id: "q_card-\(question.id):describing=answers_value", in: qSpace)
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
                                .frame(width: 80)
                        }
                        .frame(width: 145, height: 95)
                        .foregroundColor(answer.style?.bgInfo.accentGraphic ?? .primary)
                        .background(answer.style?.bgInfo.colorGraphic ?? AnswerEditor.defaultColor(when: answer.isCorrect, colorScheme: colorScheme))
                        .matchedGeometryEffect(id: "q_card-\(question.id):answer-\(answer.id)", in: qSpace)
                        .cornerRadius(30)
                    }
                }
                .transition(.scale.combined(with: .offset(y: -50 * min(4, CGFloat(question.possibleAnswers.count).rounded() / 2))))
            }
        }
        .padding()
        .background(bg.matchedGeometryEffect(id: "q_card-\(question.id):bg", in: qSpace))
        .cornerRadius(16)
        .padding(12)
        .background(bg.opacity(0.75).matchedGeometryEffect(id: "q_card-\(question.id):bg_outer_1", in: qSpace))
        .cornerRadius(20)
        .padding(8)
        .background(bg.opacity(0.5).transition(.scale(scale: 0.8)))
        .cornerRadius(24)
    }
    
    var line: some View {
        Rectangle()
            .frame(height: 3)
    }
    
    var bg: Color {
        question.bgStyle?.colorGraphic ?? QuestionView.defaultBG(scheme: colorScheme)
    }
    
    private func makeNamespace(for field: QuestionCard.FieldIdentifier) -> String {
        //TODO: make this a protocol
        field.namespace(question: question)
    }
}

struct QuestionView_Previews: PreviewProvider {
    @Namespace static var previewNamespace
    
    static var previews: some View {
        QuestionView(question: QuestionCard(title: "test", subtitle: "the desc", possibleAnswers: [.init(name: "ans1", style: nil, isCorrect: true), .init(name: "ans2", style: .init(color: "#2080FF", shape: "arrow.up.and.down.square.fill"), isCorrect: false), .init(name: "ans3", style: .init(shape: "arrow.up.forward.circle.fill", bgInfo: .init(color: "#881058", accent: ColorScheme.light.schemeDesc)), isCorrect: false)], allCorrectAnswersRequired: true), qSpace: previewNamespace)
    }
}

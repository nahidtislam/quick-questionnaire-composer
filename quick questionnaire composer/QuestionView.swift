//
//  QuestionView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 14/05/2023.
//

import SwiftUI

struct QuestionView: View {
    @State var question: Question
    
    @EnvironmentObject var navCoord: NavigationCoordinator
    @EnvironmentObject var provider: QuestionnaireListProvider
    
    var body: some View {
        List {
            Section("name") {
                TextField("title", text: $question.title)
                ConditionalTextBox(name: "subtitle", input: $question.subtitle)
            }
            
            Section("possible answers") {
                ForEach(question.possibleAnswers) { ans in
                    nav(answer: ans)
                }
            }
            
            Button("new answer") {
                let answer = PossibleAnswer(name: "")
                question.possibleAnswers.append(answer)
                navCoord.add(destination: .possibleAnswer(answer))
            }
            
            HStack {
                Text("marks:")
                Spacer()
                NumericTextField(title: String(Int(question.correctAnswersID.count)), number: $question.marks, appearWithZero: false).dontApeapearWithZeo()
                    .multilineTextAlignment(.trailing)
            }
        }
//        .navigationDestination(for: PossibleAnswer.self) { answer in
//            PossibleAnswerView(answer: answer)
//        }
        .navigationDestination(for: PathForView.self) { $0 }
        .onDisappear {
            if Question.validate(question: question) {
                try? provider.apply(question: question)
            }
        }

    }
    
    func nav(answer: PossibleAnswer) -> some View {
        NavigationLink(pfView: .possibleAnswer(answer)) {
            PossibleAnswerView.Cell(answer: answer, correct: question.correctAnswersID.contains(answer.id))
        }
//        Button {
//            navCoord.add(destination: .possibleAnswer(answer))
//            
//        } label: {
//            PossibleAnswerView.Cell(answer: answer, correct: question.correctAnswersID.contains(answer.id))
//        }
        .swipeActions(allowsFullSwipe: false) {
            Button(role: .destructive) {
                if let index = question.possibleAnswers.firstIndex(where: { $0.id == answer.id }) {
                    question.possibleAnswers.remove(at: index)
                }
            } label: {
                Label("delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                if !question.correctAnswersID.insert(answer.id).inserted {
                    question.correctAnswersID.remove(answer.id)
                }
            } label: {
                if question.correctAnswersID.contains(answer.id) {
                    Label("make incorrect", systemImage: "x.circle.fill")
                        .foregroundColor(.blue)
                } else {
                    Label("make correct", systemImage: "checkmark.circle")
                        .foregroundColor(.green)
                }
            }
        }

    }
}

struct QuestionView_Previews: PreviewProvider {
    private struct Interactive: View {
        @State private var question = Question(title: "", possibleAnswers: [], correctAnswersID: [], marks: 0, allAnswersRequired: false)
        
        var body: some View {
            QuestionView(question: question)
                .environmentObject(NavigationCoordinator())
                .environmentObject(QuestionnaireListProvider(questionnaire: [.init(name: "eg", questions: [question])]))
        }
    }
    
    static var previews: some View {
        Interactive()
    }
}

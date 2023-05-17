//
//  QuestionView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 14/05/2023.
//

import SwiftUI

struct QuestionView: View {
    @State var question: Question
    @State private var newAnswer = PossibleAnswer(name: "", symbol: "")
    @State private var showingNewAnswer = false
    
    @EnvironmentObject var navCoord: NavigationCoordinator
    
    var body: some View {
        NavigationStack {
            Form {
                Section("name") {
                    TextField("title", text: $question.title)
                    ConditionalTextBox(name: "subtitle", input: $question.subtitle)
                }
                
                Section("possible answers") {
                    ForEach($question.possibleAnswers) { ans in
                        nav(answer: ans)
                    }
                }
                
                Button("new answer") {
                    showingNewAnswer = true
                }
                
                HStack {
                    Text("marks:")
                    Spacer()
                    NumericTextField(title: String(Int(question.correctAnswersID.count)), number: $question.marks, appearWithZero: false).dontApeapearWithZeo()
                        .multilineTextAlignment(.trailing)
                }
            }
            .sheet(isPresented: $showingNewAnswer) {
                question.possibleAnswers.append(newAnswer)
                newAnswer = PossibleAnswer(name: "", symbol: "")
            } content: {
                PossibleAnswerView(answer: newAnswer)
            }
        }
        .navigationDestination(for: PossibleAnswer.self) { answer in
            PossibleAnswerView(answer: answer)
        }

    }
    
    func nav(answer: Binding<PossibleAnswer>) -> some View {
        Button {
//            PossibleAnswerView(answer: answer)
            
        } label: {
            PossibleAnswerView.Cell(answer: answer, correct: question.correctAnswersID.contains(answer.id))
        }
        .swipeActions(allowsFullSwipe: false) {
            Button(role: .destructive) {
                if let index = question.possibleAnswers.firstIndex(where: { $0.id == answer.wrappedValue.id }) {
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
        }
    }
    
    static var previews: some View {
        Interactive()
    }
}

//
//  QuetionsEditorView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

struct QuetionsEditorView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var question: QuestionCard
    
    @Namespace var someNS
    @StateObject var vm = ViewModel()
    
    var body: some View {
        VStack(alignment: .center) {
            TextField("title", text: $vm.titleInput)
                .font(.title)
            TextField("description", text: $vm.subtitleInput)
                .font(.headline)
            lineSeperator
            answerBox
            lineSeperator
            
            Toggle("all correct answers required to get points for this question", isOn: $vm.allCorrectAnswersRequired)
                .font(.caption)
            
            display("answers", value: vm.possibleAnswers.count)
            display("correct", value: vm.correctAnsCount)
            marksTextField
            
            HStack(spacing: 40) {
                Button("cancel") {}
                Button("add") {}
                    .disabled(!vm.isValid)
            }
        }.padding(.horizontal, 35)
    }
    
    private var answerAnimation: Animation {
        .spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.2)
    }
    
    private var lineSeperator: some View {
        Rectangle()
            .frame(height: 4)
            .foregroundColor(.init(hex: "#bbeebb"))
            .padding(.horizontal, -10)
    }
    
    private var marksTextField: some View {
        let placeholderValue = vm.correctAnsCount - 1
        let placeholder = String(max(0, placeholderValue))
        
        
        return HStack {
            Text("marks: ")
            Spacer()
            TextField(placeholder, text: $vm.availableMarksInput)
                .multilineTextAlignment(.trailing)
        }
    }
    
    private func display<Num: Numeric & CustomStringConvertible>(_ descripton: String, value: Num) -> some View {
        HStack {
            Text("\(descripton): ")
            Spacer()
            Text(value.description)
        }
    }
    
    var answerBox: some View {
        VStack {
            Button("add answer") {
                let ans = QuestionCard.Answer(name: "", style: nil, isCorrect: false)
                withAnimation(answerAnimation) {
                    vm.possibleAnswers.append(ans)
                }
            }
//            if vm.possibleAnswers.count == 0 {
//                Text("your answers are empty")
//                    .padding(.horizontal, 20)
//                    .padding(.top, 6)
//            }
            ScrollView {
                ForEach($vm.possibleAnswers) { item in
                    AnswerEditor(answer: item)
                        .id(item.id)
                        .padding(8)
                        .background(Color(hex: "#99EEBB"))
                        .cornerRadius(6)
                        .padding(2)
                }
            }
            .frame(height: 88 * CGFloat(min(4, vm.possibleAnswers.count)))
            Button("delete answer") {
                withAnimation(answerAnimation) {
                    _ = vm.possibleAnswers.removeLast()
                }
            }
            .disabled(vm.possibleAnswers.count == 0)
        }
        .padding()
        .background(Color(hex: "#A9DFFF"))
        .cornerRadius(20)
    }
}

struct QuetionsEditorView_Previews: PreviewProvider {
    static var previews: some View {
        QuetionsEditorView(question: .constant(QuestionCard(title: "test", possibleAnswers: [])))
    }
}

extension QuetionsEditorView {
    struct AnswerEditor: View {
        
        @Binding var answer: QuestionCard.Answer
        
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
        }
    }
    
    class ViewModel: ObservableObject {
        let questionUUID = UUID()
        
        @Published var titleInput = ""
        @Published var subtitleInput = ""
        
        @Published var availableMarksInput = ""
        
        @Published var subtitleIsEnabled = false
        @Published var allCorrectAnswersRequired = false
        
        @Published var possibleAnswers = [QuestionCard.Answer]()
        
        var subtitleOutput: String? {
            if subtitleIsEnabled && subtitleInput != "" {
                return subtitleInput
            }  else {
                return nil
            }
        }
        
        var availableMarksOutput: Double {
            .init(availableMarksInput) ?? -1
        }
        
        var correctAnsCount: Int {
            possibleAnswers.filter({ $0.isCorrect }).count
        }
        
        var isValid: Bool {
            correctAnsCount > 0 && availableMarksOutput > 0
        }
        
        var questionOutput: QuestionCard {
            .init(
                id: questionUUID,
                title: titleInput,
                subtitle: subtitleOutput,
                marks: availableMarksOutput,
                possibleAnswers: possibleAnswers,
                allCorrectAnswersRequired: allCorrectAnswersRequired
            )
        }
    }
}
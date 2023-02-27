//
//  QuestionEditorView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

struct QuestionEditorView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var question: QuestionCard
    
    var qSpace: Namespace.ID
    @StateObject var vm = ViewModel()
    
    var body: some View {
        VStack(alignment: .center) {
            TextField("title", text: $vm.titleInput)
                .matchedGeometryEffect(id: makeNamespace(for: .title), in: qSpace)
                .font(.title)
            HStack {
                TextField("description", text: $vm.subtitleInput)
                    .matchedGeometryEffect(id: makeNamespace(for: .subtitle), in: qSpace)
                    .disabled(!vm.subtitleIsEnabled)
                    .font(.headline)
                Toggle("", isOn: $vm.subtitleIsEnabled)
            }
            lineSeperator
            answerBox
                .transition(.push(from: .top))
            lineSeperator
            
            Toggle("all correct answers required to get points for this question", isOn: $vm.allCorrectAnswersRequired)
                .matchedGeometryEffect(id: question.generateNamespace(for: .allCorrectAnswersRequired), in: qSpace)
                .font(.caption)
            
            display("answers", value: vm.possibleAnswers.count)
                .matchedGeometryEffect(id: "q_card-\(question.id):possible_answers(text)", in: qSpace)
            display("correct", value: vm.correctAnsCount)
            marksTextField
            
            HStack(spacing: 40) {
                Button("cancel") {}
                Button("add") {
                    question = vm.questionOutput
                }
                .disabled(!vm.isValid)
            }
        }.padding(10)
            .background(bg)
            .cornerRadius(20)
            .padding(10)
            .background(bg.opacity(0.5))
            .cornerRadius(25)
            .onAppear {
                vm.titleInput = question.title
                if let descprition = question.subtitle {
                    vm.subtitleIsEnabled = true
                    vm.subtitleInput = descprition
                }
                if question.marks > 0 {
                    vm.availableMarksInput = "\(question.marks)"
                    
                }
                vm.possibleAnswers = question.possibleAnswers
                vm.allCorrectAnswersRequired = question.allCorrectAnswersRequired
                vm.questionUUID = question.id
            }
    }
    
    private var bg: Color {
        Color(hex: question.bgColorHex ?? "") ?? QuestionView.defaultBG(scheme: colorScheme)
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
        HStack {
            Text("marks: ")
            Spacer()
            TextField("\(vm.correctAnsCount)", text: $vm.availableMarksInput)
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
    
    private func makeNamespace(for field: QuestionCard.FieldIdentifier) -> String {
        //TODO: make this a protocol
        field.namespace(question: question)
    }
    
    var answerBox: some View {
        VStack {
            Button("add answer") {
                let ans = QuestionCard.Answer(name: "", style: nil, isCorrect: false)
                withAnimation(answerAnimation) {
                    vm.possibleAnswers.append(ans)
                }
            }
            ScrollView {
                ForEach($vm.possibleAnswers) { item in
                    AnswerEditor(answer: item)
                        .id(item.id)
                        .padding(8)
                        .background(Color(hex: item.wrappedValue.style?.color ?? "") ?? (item.wrappedValue.isCorrect ? defaultCorrectColorAnswer : defaultIncorrectColorForAnswer))
                        .animation(.easeIn(duration: 0.1), value: item.wrappedValue.isCorrect)
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
        .background(answerContainerColor)
        .cornerRadius(20)
    }
    
    private var answerContainerColor: Color? {
        colorScheme == .dark ? Color(hex: "#224477") : Color(hex: "#A9DFFF")
    }
    
    private var defaultCorrectColorAnswer: Color? {
        colorScheme == .dark ? Color(hex: "#228A44") : Color(hex: "#99EEBB")
    }
    
    private var defaultIncorrectColorForAnswer: Color? {
        colorScheme == .dark ? Color(hex: "#AA1F1A") : Color(hex: "#FAAAB5")
    }
}

struct QuetionsEditorView_Previews: PreviewProvider {
    @Namespace static var previewNamespace
    
    static var previews: some View {
        QuestionEditorView(question: .constant(QuestionCard(title: "test", possibleAnswers: [])), qSpace: previewNamespace)
    }
}

extension QuestionEditorView {
    class ViewModel: ObservableObject {
        var questionUUID = UUID()
        
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

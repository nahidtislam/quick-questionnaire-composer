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
    
    @State var ansOffset: [UUID:CGFloat] = [:]
    
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
            
            Toggle("all correct answers required to get marks", isOn: $vm.allCorrectAnswersRequired)
                .matchedGeometryEffect(id: question.generateNamespace(for: .allCorrectAnswersRequired), in: qSpace)
                .font(.caption.width(.condensed))
            
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
                    let mark: String
                    if question.marks == Double(Int(question.marks)) {
                        mark = "\(Int(question.marks))"
                    } else {
                        mark = "\(question.marks)"
                    }
                    
                    vm.availableMarksInput = mark
                    
                }
                vm.possibleAnswers = question.possibleAnswers
                vm.allCorrectAnswersRequired = question.allCorrectAnswersRequired
                vm.questionUUID = question.id
            }
    }
    
    private var bg: Color {
        Color(hex: question.bgColorHex ?? "", colorSpace: .displayP3) ?? QuestionView.defaultBG(scheme: colorScheme)
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
    
    var buttonActionStyle: Font {
        Font.title2.weight(.bold)
    }
    
    var answerScrollViewHeight: CGFloat {
        let cellSize: CGFloat = 76
        let stylerSize: CGFloat = 65 * min(CGFloat(vm.stylerIsShownForIndexes.count), 1)
        
        let maxCells: CGFloat = 3
        
        return cellSize * min(CGFloat(vm.possibleAnswers.count), maxCells) + stylerSize
    }
    
    var answerBox: some View {
        VStack {
            ScrollView {
                ForEach($vm.possibleAnswers) { item in
                    ZStack(alignment: .trailing) {
                        Button {
                            vm.delete(at: item.id)
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                        .font(.title2)
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(30)
                        .offset(x: 16 * ansOffset[item.id, default: 0] / 80)
                        AnswerEditor(answer: item)
                            .padding(8)
                            .styleTransition(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3))
                            .styleTransitionCompetion { appearing in
                                withAnimation {
                                    vm.answerStyler(isAppearing: appearing, for: item.id)
                                }
                            }
                            .id(item.id)
                            .animation(.easeIn(duration: 0.1), value: item.wrappedValue.isCorrect)
                            .cornerRadius(6)
                            .offset(x: ansOffset[item.id] ?? 0)
                            .gesture(
                                DragGesture()
                                    .onChanged{ v in
                                        ansOffset[item.id] = v.translation.width
                                    }
                                    .onEnded{ v in
                                        let threshold: CGFloat = -80
                                        let setPosition: CGFloat? = v.translation.width < threshold ? threshold : nil
                                        
                                        withAnimation {
                                            ansOffset[item.id] = setPosition
                                        }
                                    }
                        )
                    }
                }
                .onDelete { i in
                    vm.possibleAnswers.remove(atOffsets: i)
                }
                .onMove { i, target in
                    vm.possibleAnswers.move(fromOffsets: i, toOffset: target)
                }
            }
            .onChange(of: vm.questionOutput, perform: { newValue in
                if vm.isValid { question = newValue }
            })
            .frame(height: answerScrollViewHeight)
            .cornerRadius(16)
            answerListControls
        }
        .padding(10)
        .background(answerContainerColor)
        .cornerRadius(20)
    }
    
    private var answerListControls: some View {
        HStack(spacing: 20) {
            Button {
                withAnimation(answerAnimation) { vm.performUndo() }
            } label: {
                Image(systemName: "arrow.uturn.backward.circle")
                    .font(buttonActionStyle)
            }
            .disabled(vm.lastAction == .delete ? vm.deletedAnswers.count == 0 : vm.possibleAnswers.count == 0)
            if vm.possibleAnswers.count != 0 {
                Spacer()
            }
            Button(role: .destructive) {
                withAnimation(answerAnimation) { vm.deleteLastAnswer() }
            } label: {
                Image(systemName: "minus.rectangle.fill")
                    .font(buttonActionStyle)
            }
            .disabled(vm.possibleAnswers.count == 0)
            Button {
                withAnimation(answerAnimation) { vm.addBlankAnswer() }
            } label: {
                Image(systemName: "plus.rectangle.fill")
                    .font(buttonActionStyle)
            }
            
        }
    }
    
    private var answerContainerColor: Color? {
        colorScheme == .dark ? Color(hex: "#224477", colorSpace: .displayP3) : Color(hex: "#C9E8FF", colorSpace: .displayP3)
    }
}

struct QuetionsEditorView_Previews: PreviewProvider {
    @Namespace static var previewNamespace
    
    static var egAnswers: [QuestionCard.Answer] = [
        .init(name: "placeholder correct", style: nil, isCorrect: true),
        .init(name: "placeholder incorrect", style: nil, isCorrect: false),
        .init(name: "styled blueish", style: .init(color: "#11AAFF", shape: "01.square.fill"), isCorrect: false),
        .init(name: "styled marroon", style: .init(color: "#BB4588", shape: "aqi.medium", accent: ColorScheme.light.schemeDesc), isCorrect: true),
        .init(name: "lime??", style: .init(color: "#00EE82", shape: "allergens", accent: ColorScheme.dark.schemeDesc), isCorrect: true)
    ]
    
    static var previews: some View {
        QuestionEditorView(question: .constant(QuestionCard(title: "test", possibleAnswers: Self.egAnswers)), qSpace: previewNamespace)
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
        @Published var deletedAnswers = [QuestionCard.Answer]()
        
        var lastAction: DataAction = .delete
        @Published var stylerIsShownForIndexes = Set<Int>()
        
        var subtitleOutput: String? {
            if subtitleIsEnabled && subtitleInput != "" {
                return subtitleInput
            }  else {
                return nil
            }
        }
        
        func addBlankAnswer() {
            let ans = QuestionCard.Answer(name: "", style: nil, isCorrect: false)
            add(answer: ans)
        }
        
        func add(answer: QuestionCard.Answer) {
            possibleAnswers.append(answer)
            lastAction = .add
        }
        
        func deleteLastAnswer() {
            delete(at: possibleAnswers.count - 1)
        }
        
        func delete(at id: UUID) {
            let index = possibleAnswers.firstIndex(where: { $0.id == id})!
            delete(at: index)
        }
        
        func delete(at index: Int) {
            let deleted = possibleAnswers.remove(at: index)
            stylerIsShownForIndexes.remove(index)
            deletedAnswers.append(deleted)
            lastAction = .delete
        }
        
        func delete(atOffsets indexSet: IndexSet) {
            possibleAnswers.remove(atOffsets: indexSet)
//            stylerIsShownForIndexes.remove(at: Set<Int>.Index(indexSet))
            lastAction = .delete
        }
        
        func performUndo() {
            switch lastAction {
            case .add:
                deleteLastAnswer()
//                lastAction = .add
            case .delete:
                add(answer: deletedAnswers.removeLast())
//                lastAction = .delete
            }
        }
        
        func answerStyler(isAppearing: Bool, for uuid: UUID) {
            let index = possibleAnswers.firstIndex(where: { $0.id == uuid })!
            
            if isAppearing {
                stylerIsShownForIndexes.insert(index)
            } else {
                stylerIsShownForIndexes.remove(index)
            }
        }
        
        var availableMarksOutput: Double {
            .init(availableMarksInput) ?? -1
        }
        
        var correctAnsCount: Int {
            possibleAnswers.filter({ $0.isCorrect }).count
        }
        
        var containsEmptyAnsTitile: Bool {
            possibleAnswers.first { $0.name == "" } != nil
        }
        
        var isValid: Bool {
            correctAnsCount > 0 && availableMarksOutput > 0 && !containsEmptyAnsTitile
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
        
        enum DataAction {
        case delete, add
        }
    }
}

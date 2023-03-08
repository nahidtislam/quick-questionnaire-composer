//
//  QuestionEditorView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

struct QuestionEditorView: View {
    
    let maxAnswerOffset: CGFloat = 80
    
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var question: QuestionCard
    
    var qSpace: Namespace.ID
    @StateObject var vm = ViewModel()
    
    @State private var ansOffset: [UUID:CGFloat] = [:]
    @State private var autoScrollTo = -1
    
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
            answerInfo
            BackgroundColorPicker(selection: $vm.questionBgColorInput, accentSchme: $vm.questionBgAccentColorInput, name: vm.titleInput, label: "question background color")
            marksTextField
            
            HStack(spacing: 40) {
                Button("cancel") {}
                Button("<") {
//                    presentationMode.isPresented = false
                }
                .disabled(!vm.isValid)
            }
        }
        .foregroundColor(vm.questionOutput.bgStyle?.accentGraphic)
        .padding(10)
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
            vm.questionBgColorInput = Color(hex: question.bgStyle?.color ?? "", colorSpace: .displayP3) ?? .clear
        }
    }
    
    private var answerInfo:some View {
        VStack {
            display("answers", value: vm.possibleAnswers.count)
                .matchedGeometryEffect(id: "q_card-\(question.id):possible_answers(text)", in: qSpace)
            display("correct", value: vm.correctAnsCount)
        }
    }
    
    private var bg: Color {
        Color(hex: vm.questionBgColorOutput ?? "", colorSpace: .displayP3) ?? QuestionView.defaultBG(scheme: colorScheme)
    }
    
    private var answerAnimation: Animation {
        .spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.2)
    }
    
    private var lineSeperator: some View {
        Rectangle()
            .frame(height: 4)
            .padding(.horizontal, -10)
            .foregroundColor(.init(hex: vm.isValid ? "#bbeebb" : "#f1a5ad", colorSpace: .displayP3))
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
                ScrollViewReader { proxy in
                    ForEach($vm.possibleAnswers) { item in
                        populate(answer: item)
                    }
                    .onChange(of: autoScrollTo) { newValue in
                        guard newValue >= 0 else { return }
                        withAnimation {
                            proxy.scrollTo(vm.possibleAnswers[newValue].id)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            autoScrollTo = -1
                        }
                    }
                }
            }
            .onChange(of: vm.questionOutput, perform: update)
            .frame(height: answerScrollViewHeight)
            .cornerRadius(16)
            answerListControls
        }
        .padding(10)
        .background(answerContainerColor.opacity(vm.questionBgColorOutput == nil ? 1 : 0.6))
        .cornerRadius(20)
    }
    
    private func update(to newValue: QuestionCard) {
        if vm.isValid { question = newValue }
    }
    
    private var answerListControls: some View {
        HStack(spacing: 20) {
            Button {
                withAnimation(answerAnimation) { vm.performUndo() }
            } label: {
                Label("undo action", systemImage: "arrow.uturn.backward.circle")
                    .labelStyle(.iconOnly)
                    .font(buttonActionStyle)
            }
            .disabled(vm.lastAction == .delete ? vm.deletedAnswers.count == 0 : vm.possibleAnswers.count == 0)
            if vm.possibleAnswers.count != 0 {
                Button {
                    autoScrollTo = 0
                } label: {
                    Label("scroll answers to top", systemImage: "arrow.up.square.fill")
                        .labelStyle(.iconOnly)
                        .font(buttonActionStyle)
                }
                Spacer()
            }
            Button(role: .destructive) {
                withAnimation(answerAnimation) {
                    vm.deleteLastAnswer()
                    scrollAnswersToLast()
                }
            } label: {
                Label("delete answer", systemImage: "minus.rectangle.fill")
                    .labelStyle(.iconOnly)
                    .font(buttonActionStyle)
            }
            .disabled(vm.possibleAnswers.count == 0)
            Button {
                withAnimation(answerAnimation) {
                    vm.addBlankAnswer()
                    autoScrollTo = vm.possibleAnswers.endIndex - 1
                }
            } label: {
                Label("add answer", systemImage: "plus.rectangle.fill")
                    .labelStyle(.iconOnly)
                    .font(buttonActionStyle)
            }
            
        }
    }
    
    private func scrollAnswersToLast() {
        guard vm.possibleAnswers.count > 0 else { return }
        autoScrollTo = vm.possibleAnswers.endIndex - 1
    }
    
    private var answerContainerColor: Color? {
        colorScheme == .dark ? Color(hex: "#224477", colorSpace: .displayP3) : Color(hex: "#C9E8FF", colorSpace: .displayP3)
    }
    
    private func deleteButton(initialScale: CGFloat, with value: CGFloat, for maxDistance: CGFloat) -> CGSize {
        let compliment = 1 - initialScale // 1 - 0.8 = 0.2
        let inverse = maxDistance / compliment // 80 / 0.2 = 400
        
        // 0.8 + min(0.2, -ansOffset[item.id, default: 0] / 400)
        let len = initialScale + min(compliment, value / inverse)
        
        return .init(width: len, height: len)
    }
    
    private func populate(answer item: Binding<QuestionCard.Answer>) -> some View {
        ZStack(alignment: .trailing) {
            Button {
                withAnimation {
                    ansOffset[item.id] = nil
                    vm.delete(at: item.id)
                }
            } label: {
                Image(systemName: "trash.fill")
            }
            .font(.title2)
            .padding(10)
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(.infinity)
            .offset(x: 16 * ansOffset[item.id, default: 0] / 80)
            .scaleEffect(deleteButton(initialScale: 0.4, with: -ansOffset[item.id, default: 0], for: 80))
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
                .cornerRadius(8)
                .offset(x: ansOffset[item.id] ?? 0)
                .gesture(
                    DragGesture()
                        .onChanged{ v in
                            ansOffset[item.id] = v.translation.width
                            print("0.8 + min(0.2, \(-ansOffset[item.id, default: 0] / 400)) : \(-ansOffset[item.id, default: 0] > 80 ? "yes" : "no")")
                        }
                        .onEnded{ v in
                            let threshold: CGFloat = -maxAnswerOffset
                            let setPosition: CGFloat? = v.translation.width < threshold ? threshold : nil
                            
                            withAnimation {
                                ansOffset[item.id] = setPosition
                            }
                        }
            )
        }
    }
}

struct QuetionsEditorView_Previews: PreviewProvider {
    @Namespace static var previewNamespace
    
    static var egAnswers: [QuestionCard.Answer] = [
        .init(name: "placeholder correct", style: nil, isCorrect: true),
        .init(name: "placeholder incorrect", style: nil, isCorrect: false),
        .init(name: "styled blueish", style: .init(color: "#11AAFF", shape: "01.square.fill"), isCorrect: false),
        .init(name: "styled marroon", style: .init(shape: "aqi.medium", bgInfo: .init(color: "#BB4588", accent: ColorScheme.light.schemeDesc)), isCorrect: true),
        .init(name: "lime??", style: .init(shape: "allergens", bgInfo: .init(color: "#00EE82", accent: ColorScheme.dark.schemeDesc)), isCorrect: true)
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
        
        @Published var questionBgColorInput = Color.clear
        @Published var questionBgAccentColorInput: ColorScheme?
        
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
        
        var questionBgColorOutput: String? {
            guard questionBgColorInput != .clear else { return nil }
            return questionBgColorInput.hexValue
        }
        
        var questionBgAccentColorOutput: String? {
            questionBgAccentColorInput?.schemeDesc
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
        
        var styleOutput: QuestionCard.BGStyle? {
            guard let colorHex = questionBgColorOutput else { return nil }
            
                return .init(color: colorHex, accent: questionBgAccentColorOutput)
        }
        
        var questionOutput: QuestionCard {
            .init(
                id: questionUUID,
                title: titleInput,
                subtitle: subtitleOutput,
                marks: availableMarksOutput,
                bgStyle: styleOutput,
                possibleAnswers: possibleAnswers,
                allCorrectAnswersRequired: allCorrectAnswersRequired
            )
        }
        
        enum DataAction {
        case delete, add
        }
    }
}

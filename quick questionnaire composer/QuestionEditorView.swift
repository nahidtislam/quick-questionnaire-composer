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
            TextField("title", text: $vm.inputs.title)
                .font(.title)
            HStack {
                TextField("description", text: $vm.inputs.subtitle)
                    .disabled(!vm.inputs.subtitleIsEnabled)
                    .font(.headline)
                Toggle("", isOn: $vm.inputs.subtitleIsEnabled)
            }
            lineSeperator
            answerBox
            lineSeperator
            Toggle("all correct answers required to get marks", isOn: $vm.inputs.allCorrectAnswersRequired)
                .font(.caption.width(.condensed))
            answerInfo
            BackgroundColorPicker(selection: $vm.inputs.bgColor, accentSchme: $vm.inputs.bgAccent, name: vm.inputs.title, label: "question background color")
            marksTextField
            
            HStack(spacing: 40) {
                Button("cancel") {}
                Button("<") {
//                    presentationMode.isPresented = false
                }
                .disabled(!vm.isValid)
            }
        }
        .transition(.asymmetric(insertion: .push(from: .top), removal: .scale))
        .foregroundColor(vm.inputs.result.bgStyle?.accentGraphic)
        .padding(10)
        .background(bg.matchedGeometryEffect(id: "q_card-\(question.id):bg", in: qSpace))
        .cornerRadius(20)
        .padding(10)
        .background(bg.opacity(0.5).matchedGeometryEffect(id: "q_card-\(question.id):bg_outer_1", in: qSpace))
        .cornerRadius(25)
        .onAppear {
            vm.inputs = Inputs(questionCard: question)
        }
    }
    
    private var answerInfo:some View {
        VStack {
            display("answers", value: vm.inputs.answers.count)
            display("correct", value: vm.correctAnsCount)
        }
    }
    
    private var bg: Color {
        Color(hex: vm.inputs.bgStyle?.color ?? "", colorSpace: .displayP3) ?? QuestionView.defaultBG(scheme: colorScheme)
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
            TextField("\(vm.correctAnsCount)", text: $vm.inputs.marks)
                .multilineTextAlignment(.trailing)
        }
    }
    
    
    
    private func display<Num: Numeric & CustomStringConvertible>(_ descripton: String, value: Num) -> some View {
        HStack {
            Text("\(descripton): ")
//                .matchedGeometryEffect(id: "q_card-\(question.id):describing=\(descripton.replacingOccurrences(of: " ", with: "_"))_label", in: qSpace)
            Spacer()
            Text(value.description)
//                .matchedGeometryEffect(id: "q_card-\(question.id):describing=\(descripton.replacingOccurrences(of: " ", with: "_"))_value", in: qSpace)
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
        
        return cellSize * min(CGFloat(vm.inputs.answers.count), maxCells) + stylerSize
    }
    
    private var answerBox: some View {
        VStack {
            ScrollView {
                ScrollViewReader { proxy in
                    ForEach($vm.inputs.answers) { item in
                        populate(answer: item)
                    }
                    .onChange(of: autoScrollTo) { newValue in
                        guard newValue >= 0 else { return }
                        withAnimation {
                            proxy.scrollTo(vm.inputs.answers[newValue].id)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            autoScrollTo = -1
                        }
                    }
                }
            }
            .onChange(of: vm.inputs.result, perform: update)
            .frame(height: answerScrollViewHeight)
            .cornerRadius(16)
            answerListControls
        }
        .padding(10)
        .background(answerContainerColor.opacity(vm.inputs.bgStyle == nil ? 1 : 0.6))
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
            .disabled(vm.lastActions.isEmpty)
            if vm.inputs.answers.count != 0 {
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
            .disabled(vm.inputs.answers.count == 0)
            Button {
                withAnimation(answerAnimation) {
                    vm.addBlankAnswer()
                    autoScrollTo = vm.inputs.answers.endIndex - 1
                }
            } label: {
                Label("add answer", systemImage: "plus.rectangle.fill")
                    .labelStyle(.iconOnly)
                    .font(buttonActionStyle)
            }
            
        }
    }
    
    private func scrollAnswersToLast() {
        guard vm.inputs.answers.count > 0 else { return }
        autoScrollTo = vm.inputs.answers.endIndex - 1
    }
    
    private var answerContainerColor: Color? {
        colorScheme == .dark ? Color(hex: "#224477", colorSpace: .displayP3) : Color(hex: "#C9E8FF", colorSpace: .displayP3)
    }
    
    private func deleteButton(initialScale: CGFloat, with value: CGFloat, for maxDistance: CGFloat) -> CGSize {
        let compliment = 1 - initialScale // 1 - 0.8 = 0.2
        let inverse = maxDistance / compliment // 80 / 0.2 = 400
        
        // 0.8 + min(0.2, -ansOffset[item.id, default: 0] / 400)
        let len = initialScale + abs(min(compliment, value / inverse))
        
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
            .offset(x: ansOffset[item.id, default: 0] / 5)
            .scaleEffect(deleteButton(initialScale: 0.6, with: -ansOffset[item.id, default: 0], for: maxAnswerOffset))
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
                            let w: CGFloat = {
                                let width = v.translation.width
                                let absW = abs(width)
                                if absW <= maxAnswerOffset {
                                    return width
                                } else {
                                    let diff = absW - maxAnswerOffset
                                    var output = maxAnswerOffset + diff / 4
                                    if width < 0 { output *= -1 }
                                    
                                    return output
                                }
                            }()
                            withAnimation(abs(ansOffset[item.id, default: 0]) == maxAnswerOffset ? .default : .none) {
                                ansOffset[item.id] = w
                            }
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
        
        @Published var inputs = Inputs(id: UUID())
        
        var lastActions = [DataAction]()
        @Published var stylerIsShownForIndexes = Set<Int>()
        
        func addBlankAnswer() {
            let ans = QuestionCard.Answer(name: "", style: nil, isCorrect: false)
            add(answer: ans)
        }
        
        func add(answer: QuestionCard.Answer) {
            inputs.answers.append(answer)
            lastActions.append(.add)
        }
        
        func add(answer: QuestionCard.Answer, at index: Int) {
            inputs.answers.insert(answer, at: index)
            lastActions.append(.add)
        }
        
        func deleteLastAnswer() {
            delete(at: inputs.answers.count - 1)
        }
        
        func delete(at id: UUID) {
            let index = inputs.answers.firstIndex(where: { $0.id == id})!
            delete(at: index)
        }
        
        func delete(at index: Int) {
            let deleted = inputs.answers.remove(at: index)
            stylerIsShownForIndexes.remove(index)
            lastActions.append(.delete(deleted, index))
        }
        
        func delete(atOffsets indexSet: IndexSet) {
            inputs.answers.remove(atOffsets: indexSet)
//            stylerIsShownForIndexes.remove(at: Set<Int>.Index(indexSet))
            fatalError("not supported")
//            lastActions.append(.deleteBulk(indexSet))
        }
        
        func performUndo() {
            switch lastActions.last! {
            case .add:
                deleteLastAnswer()
//                lastAction = .add
                lastActions.removeLast()
            case .delete(let recoveredAnswer, let index):
                add(answer: recoveredAnswer, at: index)
                lastActions.removeLast()
//                lastAction = .delete
            case .deletedBulk(let indexSet): fatalError("not supported for anything with \(indexSet)")
                
            }
            lastActions.removeLast()
        }
        
        func answerStyler(isAppearing: Bool, for uuid: UUID) {
            let index = inputs.answers.firstIndex(where: { $0.id == uuid })!
            
            if isAppearing {
                stylerIsShownForIndexes.insert(index)
            } else {
                stylerIsShownForIndexes.remove(index)
            }
        }
        
        var correctAnsCount: Int {
            inputs.answers.filter({ $0.isCorrect }).count
        }
        
        var containsEmptyAnsTitile: Bool {
            inputs.answers.first { $0.name == "" } != nil
        }
        
        var isValid: Bool {
            correctAnsCount > 0 && Double(inputs.marks) ?? 0 > 0 && !containsEmptyAnsTitile
        }
        
        enum DataAction {
            case delete(QuestionCard.Answer, Int), deletedBulk([QuestionCard.Answer]), add
        }
    }
    
    struct Inputs {
        let id: UUID
        
        var title = ""
        var subtitle = ""
        
        var answers = [QuestionCard.Answer]()
        
        var marks = ""
        
        var subtitleIsEnabled = false
        var allCorrectAnswersRequired = false
        
        var bgColor = Color.clear
        var bgAccent: ColorScheme?
        
        var bgStyle: QuestionCard.BGStyle? {
            guard bgColor != .clear, let colorHex = bgColor.hexValue else { return nil }
            return .init(color: colorHex, accent: bgAccent?.schemeDesc)
        }
        
        var result: QuestionCard {
            .init(
                id: id,
                title: title,
                subtitle: subtitleIsEnabled && !subtitle.isEmpty ? subtitle : nil,
                marks: Double(marks) ?? -1,
                bgStyle: bgStyle,
                possibleAnswers: answers,
                allCorrectAnswersRequired: allCorrectAnswersRequired
            )
        }
    }
}

extension QuestionEditorView.Inputs {
    init(questionCard: QuestionCard) {
        self.id = questionCard.id
        self.title = questionCard.title
        self.subtitle = questionCard.subtitle ?? ""
        self.answers = questionCard.possibleAnswers
        self.marks = questionCard.marks < 0 ? "" : String(neatDecimal: questionCard.marks)
        self.subtitleIsEnabled = questionCard.subtitle != nil
        self.allCorrectAnswersRequired = questionCard.allCorrectAnswersRequired
        self.bgColor = Color(hex: questionCard.bgStyle?.color ?? "none", colorSpace: .displayP3) ?? .clear
        self.bgAccent = questionCard.bgStyle?.accentScheme
    }
}

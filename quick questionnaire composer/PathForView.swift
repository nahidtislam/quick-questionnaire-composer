//
//  PathForView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 16/05/2023.
//

import SwiftUI

enum PathForView: View, Hashable {
    case questionnaire(Questionnaire)
    case questionnaireList([Questionnaire])
    case question(Question)
//    case possibleAnswer(PossibleAnswer)
    
    var body: some View {
        switch self {
        case .questionnaire(let questionnaire):
            QuestionnaireView(questionnaire: questionnaire)
        case .questionnaireList(let questionnaires):
            QuestionnaireListView(questionnaires: questionnaires)
        case .question(let question):
            QuestionView(question: question)
//        case .possibleAnswer(let answer):
//            PossibleAnswerView(answer: answer)
        }
    }
    
    var uuidForContainingData: UUID {
        switch self {
        case .questionnaire(let questionnaire):
            return questionnaire.id
        case .questionnaireList(_):
            return UUID()
        case .question(let question):
            return question.id
//        case .possibleAnswer(let answer):
//            return answer.id
        }
    }
    
    func relatedIndex(under questionnaires: [Questionnaire]) -> Int {
        switch self {
        case .questionnaire(let questionnaire):
            return questionnaires.index(using: questionnaire)
        case .questionnaireList(_):
            fatalError("no")
        case .question(let question):
            let enclosing = questionnaires.first(where: { $0.questions.contains(question) })!
            return enclosing.questions.firstIndex(where: { $0 == question})!
//        case .possibleAnswer(let answer):
//            let enclosingQ = questionnaires.flatMap({ $0.questions }).first(where: {
//                $0.possibleAnswers.contains(answer.wrappedValue)
//            })!
//            return enclosingQ.possibleAnswers.index(using: answer.wrappedValue)
        }
    }
    
//    func disaperAction<Hierc: HierarchableData>(a: @escaping (Hierc) -> Void) -> Self {
//        switch self {
//        case .questionnaire(let questionnaire):
//            return self
//        case .questionnaireList(let array):
//            return self
//        case .question(let question):
//            return self
//        case .possibleAnswer(let possibleAnswer):
//            return
//        }
//    }
}

extension NavigationLink where Destination == Never {
    init(pfView: PathForView, @ViewBuilder label: () -> Label) {
        self = NavigationLink(value: pfView, label: label)
    }
    
    init<S: StringProtocol>(_ title: S, pfView: PathForView) where Label == Text {
        self = NavigationLink(title, value: pfView)
    }
}

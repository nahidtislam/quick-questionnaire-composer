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
    case possibleAnswer(PossibleAnswer)
    
    var body: some View {
        switch self {
        case .questionnaire(let questionnaire):
            QuestionnaireView(questionnaire: questionnaire)
        case .questionnaireList(let questionnaires):
            QuestionnaireListView(questionnaires: questionnaires)
        case .question(let question):
            QuestionView(question: question)
        case .possibleAnswer(let answer):
            PossibleAnswerView(answer: answer)
        }
    }
}

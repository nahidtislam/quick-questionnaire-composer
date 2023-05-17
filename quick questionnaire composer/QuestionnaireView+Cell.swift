//
//  QuestionnaireView+Cell.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 17/05/2023.
//

import SwiftUI

extension QuestionnaireView {
    struct Cell: View {
        let questionnaire: Questionnaire
        
        var body: some View {
            HStack {
                if let symbol = questionnaire.symbol {
                    Image(systemName: symbol)
                }
                VStack(alignment: .leading) {
                    Text(questionnaire.name)
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                    if let description = questionnaire.description {
                        Text(description)
                            .font(.caption2)
                    }
                    HStack {
                        Text("number of questions:")
                        let count = String(format: "%02d", questionnaire.questions.count)
                        Text(count)
                    }
                    .font(.footnote)
                }
                Spacer()
                VStack {
                    Text("total marks:")
                        .font(.footnote)
                    let marks = String(format: "%04.1f", questionnaire.questions.reduce(0) {$0 + $1.marks})
                    Text(marks)
                        .font(.title2)
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 4).stroke())
                }
                Image(systemName: questionnaire.completed ? "checkmark.square.fill" : "x.circle.fill")
            }
        }
    }
}

struct QuestionnaireView_Cell_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireView.Cell(questionnaire: ExampleUserData.oneQuestionnaire)
    }
}

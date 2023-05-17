//
//  QuestionView+Cell.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 17/05/2023.
//

import SwiftUI

extension QuestionView {
    struct Cell: View {
        let question: Question
        var body: some View {
            VStack {
                Text(question.title)
                    .font(.title2)
                if let subheading = question.subtitle {
                    Text(subheading)
                        .font(.subheadline)
                }
                HStack {
                    Text(String(question.correctAnswersID.count))
                    Text(String(question.possibleAnswers.count))
                }
            }
        }
    }
}

struct QuestionView_Cell_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView.Cell(question: .init(title: "example", possibleAnswers: [], correctAnswersID: [], marks: 0, allAnswersRequired: false))
    }
}

//
//  QuestionView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 22/02/2023.
//

import SwiftUI

struct QuestionView: View {
    
    var quetion: QuestionCard
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(quetion.title)
                .font(.largeTitle)
                .padding(.horizontal, 10)
            line
            if let desc = quetion.subtitle {
                Text(desc)
                    .font(.title)
                    .padding(.horizontal, 10)
            }
            HStack {
                Text("possible answers: ")
                Spacer()
                Text("\(quetion.possibleAnswers.count)")
            }
            if quetion.possibleAnswers.count > 2 {
                HStack {
                    Text("all answers required: ")
                    Spacer()
                    Text("\(quetion.allCorrectAnswersRequired ? "yes" : "no")")
                }
            }
        }
        .padding()
    }
    
    var line: some View {
        Rectangle()
            .frame(height: 3)
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(quetion: QuestionCard(title: "test", subtitle: "the desc", possibleAnswers: [], allCorrectAnswersRequired: true))
    }
}

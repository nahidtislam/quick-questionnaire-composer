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
            HStack {
                VStack(alignment: .leading) {
                    headings
//                    Divider()
//                        .padding(.vertical, -8)
                    totalAnswerDisplay
                        .font(.caption)
                    if question.allAnswersRequired {
                        Text("all correct answers must be ticked")
                            .font(.footnote)
                    }
                }
                Spacer()
                correctAnswerDisplay
            }
        }
        
        private var headings: some View {
            VStack(alignment: .leading) {
                Text(question.title)
                    .font(.title2)
                if let subheading = question.subtitle {
                    Text(subheading)
                        .font(.subheadline)
                }
            }
        }
        
        private var totalAnswerDisplay: some View {
            HStack {
                let count = String(format: "%02d", question.possibleAnswers.count)
                Text("number of questions:")
                Text(count)
            }
        }
        
        private var correctAnswerDisplay: some View {
            HStack(alignment: .center) {
                    VStack(alignment: .trailing) {
                        Text("correct ")
                        Text("answers:")
                    }
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                let count = String(format: "%02d", question.correctAnswersID.count)
                Text(count)
            }
        }
    }
}

struct QuestionView_Cell_Previews: PreviewProvider {
    
    private struct InteractiveContainer: View {
        @State private var questions: [Question] = [
            .init(title: "example", possibleAnswers: [], correctAnswersID: [], marks: 0, allAnswersRequired: false),
            .init(title: "nice example", subtitle: "to show off how nice it is", possibleAnswers: [
                .init(name: "it is nice"),
                .init(name: "maybe nicer", symbol: "square"),
                .init(id: UUID(uuidString: "84dad706-f48a-11ed-a05b-0242ac120009")!, name: "kinda correct")
            ], correctAnswersID: [.init(uuidString: "84dad706-f48a-11ed-a05b-0242ac120009")!], marks: 1, allAnswersRequired: false),
            .init(title: "strict", possibleAnswers: [
                .init(id: .init(uuidString: "49a19b3f-20a6-4aac-9a87-599fbdd752f4")!,name: "foo"),
                .init(id: .init(uuidString: "af32b495-0bb1-4d50-a39c-1682f145df8a")!,name: "bar"),
                .init(name: "hmmm")
            ], correctAnswersID: [
                .init(uuidString: "49a19b3f-20a6-4aac-9a87-599fbdd752f4")!,
                .init(uuidString: "af32b495-0bb1-4d50-a39c-1682f145df8a")!
            ], marks: 2, allAnswersRequired: true)
        ]
        
        var body: some View {
            NavigationView {
                List {
                    Section("questions") {
                        ForEach(questions) { question in
                            QuestionView.Cell(question: question)
                        }
                    }
                }
            }
        }
    }
    
    static var previews: some View {
        InteractiveContainer()
    }
}

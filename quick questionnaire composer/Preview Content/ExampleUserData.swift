//
//  ExampleUserData.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 17/05/2023.
//

import Foundation

enum ExampleUserData {
    static let oneQuestionnaire = Questionnaire(name: "hello", description: "world", symbol: "list.bullet.clipboard", questions: [
        .init(title: "what is p", possibleAnswers: [
            .init(id: UUID(uuidString: "31532b5d-032a-46e5-9757-155d4e16547d")!, name: "the 16th letter", symbol: "16.square.fill"),
            .init(name: "hhmmm"),
            .init(id: UUID(uuidString: "0de0ac1b-1e1e-4d99-88b9-9d59936bedd8")!, name: "it's what phone starts with")
        ], correctAnswersID: [
            UUID(uuidString: "0de0ac1b-1e1e-4d99-88b9-9d59936bedd8")!,
            UUID(uuidString: "31532b5d-032a-46e5-9757-155d4e16547d")!
        ], marks: 5, allAnswersRequired: false)
    ], completed: false)
//    static let listOfQuestionnaire: [Questionnaire] = [
//        .init(name: <#T##String#>, description: <#T##String?#>, symbol: <#T##String?#>, questions: <#T##[Question]#>, completed: <#T##Bool#>),
//        .init(name: <#T##String#>, description: <#T##String?#>, questions: <#T##[Question]#>, completed: <#T##Bool#>),
//        .init(name: <#T##String#>, symbol: <#T##String?#>, questions: <#T##[Question]#>, completed: <#T##Bool#>),
//        .init(name: <#T##String#>, description: <#T##String?#>, symbol: <#T##String?#>, questions: <#T##[Question]#>, completed: <#T##Bool#>),
//        .init(name: <#T##String#>, description: <#T##String?#>, questions: <#T##[Question]#>, completed: <#T##Bool#>),
//        .init(name: <#T##String#>, symbol: <#T##String?#>, questions: <#T##[Question]#>, completed: <#T##Bool#>),
//        .init(name: <#T##String#>, questions: <#T##[Question]#>, completed: <#T##Bool#>),
//        .init(name: <#T##String#>, questions: <#T##[Question]#>, completed: <#T##Bool#>),
//        .init(name: <#T##String#>, description: <#T##String?#>, symbol: <#T##String?#>, questions: <#T##[Question]#>, completed: <#T##Bool#>),
//        .init(name: <#T##String#>, description: <#T##String?#>, questions: <#T##[Question]#>, completed: <#T##Bool#>),
//        .init(name: <#T##String#>, symbol: <#T##String?#>, questions: <#T##[Question]#>, completed: <#T##Bool#>),
//        .init(name: <#T##String#>, symbol: <#T##String?#>, questions: <#T##[Question]#>, completed: <#T##Bool#>),
//        .init(name: <#T##String#>, description: <#T##String?#>, questions: <#T##[Question]#>, completed: <#T##Bool#>)
//        ]
}

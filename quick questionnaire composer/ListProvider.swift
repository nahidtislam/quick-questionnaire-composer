//
//  ListProvider.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 17/05/2023.
//

import Foundation

class ListProvider: ObservableObject {
    
    @Published var questionnaires: [Questionnaire]
    
    init(questionnaire: [Questionnaire]) {
        self.questionnaires = questionnaire
    }
    
    func checkValidity() -> Bool {
        !questionnaires.contains(where: { !Questionnaire.validate(questionnaire: $0) })
    }
    
    static var docFolder: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var questionnaireFolder: URL {
        ListProvider.docFolder
            .appending(path: "questionnaires", directoryHint: .isDirectory)
    }
    
    func save(questionnaire: Questionnaire) throws {
        let folder = questionnaireFolder
        let savePath = folder.appendingPathComponent(questionnaire.name, conformingTo: .json)
        let fm = FileManager.default
        
        if !fm.fileExists(atPath: folder.path(percentEncoded: false)) {
            try fm.createDirectory(at: folder, withIntermediateDirectories: false)
        }
        
        let data = try JSONEncoder().encode(questionnaire)
        try data.write(to: savePath, options: .completeFileProtection)
    }
    
    func rename(questionnaire: inout Questionnaire, to newName: String) throws {
        let fm = FileManager.default
        let oldName = questionnaire.name
        
        let oldNamePath = questionnaireFolder.appending(path: oldName)
        let newNamePath = questionnaireFolder.appending(path: newName)
        
        try fm.moveItem(at: oldNamePath, to: newNamePath)
        questionnaire.name = newName
    }
    
    func delete(questionnaire: Questionnaire) throws {
        let path = path(for: questionnaire)
        try FileManager.default.removeItem(at: path)
        questionnaires.remove(at: questionnaires.firstIndex(of: questionnaire)!)
    }
    
    func pull(uuid: UUID) -> (any HierarchableData)? {
        for questionnaire in questionnaires {
            if questionnaire.id == uuid {
                return questionnaire
            } else {
                for question in questionnaire.questions {
                    if question.id == uuid {
                        return question
                    } else {
                        for answer in question.possibleAnswers {
                            if answer.id == uuid {
                                return answer
                            }
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    @discardableResult
    func add(possibleAnswer: PossibleAnswer, to quetion: Question) -> (questionnaireIndex: Int, questionIndex: Int, possibleAnswer: Int)  {
        let questionnaireIndex = questionnaires.firstIndex(where: { $0.questions.contains(where: { $0.id == quetion.id}) })!
        let questionIndex = questionnaires[questionnaireIndex].questions.firstIndex(where: { $0.id == quetion.id })!
        
        questionnaires[questionnaireIndex].questions[questionIndex].possibleAnswers.append(possibleAnswer)
        
        let paCount = questionnaires[questionnaireIndex].questions[questionIndex].possibleAnswers.count - 1
        
        return (questionnaireIndex, questionIndex, paCount)
    }
    
    private func path(for questionnaire: Questionnaire) -> URL {
        questionnaireFolder
            .appendingPathComponent(questionnaire.name, conformingTo: .json)
    }
    
    func delete(atIndex index: Int) throws {
        let path = path(for: questionnaires[index])
        try FileManager.default.removeItem(at: path)
        questionnaires.remove(at: index)
    }
    
    func delete(indexSet: IndexSet) throws {
        let fm = FileManager.default
        indexSet.forEach { i in
            let p = questionnaireFolder.appendingPathComponent(questionnaires[i].name, conformingTo: .json)
            try? fm.removeItem(at: p)
        }
        questionnaires.remove(atOffsets: indexSet)
    }
    
    func apply(question: Question) throws {
        let (questionnaireIndex, questionIndex): (Int, Int) = {
            for (i, questionnaire) in questionnaires.enumerated() {
                for (j, lookingQuestion) in questionnaire.questions.enumerated() {
                    if lookingQuestion.id == question.id {
                        return (i, j)
                    }
                }
            }
            fatalError("wat")
        }()
        
        questionnaires[questionnaireIndex].questions[questionIndex] = question
        try save(questionnaire: questionnaires[questionnaireIndex])
    }
    
    func apply(possibleAnswer answer: PossibleAnswer) {
        let (questionnaireIndex, questionIndex, answerIndex): (Int, Int, Int) = {
            for (i, questionnaire) in questionnaires.enumerated() {
                for (j, lookingQuestion) in questionnaire.questions.enumerated() {
                    for (k, lookingAnswer) in lookingQuestion.possibleAnswers.enumerated() {
                        if lookingAnswer.id == answer.id {
                            return (i, j, k)
                        }
                    }
                }
            }
            fatalError("wat")
        }()
        questionnaires[questionnaireIndex].questions[questionIndex].possibleAnswers[answerIndex] = answer
    }
    
    func reload() throws {
        let fm = FileManager.default
        let path = questionnaireFolder.path(percentEncoded: false)
        
        var questionnaires = [Questionnaire]()
        
        let items = try fm.contentsOfDirectory(atPath: path)
        items.forEach { item in
            let fullpath = path + item
            guard let data = fm.contents(atPath: fullpath),
                  let decoded = try? JSONDecoder().decode(Questionnaire.self, from: data) else {
//                throw CocoaError(.fileReadCorruptFile)
                return
            }
            
            questionnaires.append(decoded)
        }
        
        self.questionnaires.removeAll()
        self.questionnaires = questionnaires
    }
    
    static func loadFromStorage() throws -> ListProvider {
        let ouput = ListProvider.blank()
        try ouput.reload()
        
        return ouput
    }
    
    static func blank() -> ListProvider {
        .init(questionnaire: [])
    }
}

protocol HierarchableData: Identifiable, Codable, Hashable {
    
}

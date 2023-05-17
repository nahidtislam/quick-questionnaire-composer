//
//  QuestionnaireListProvider.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 17/05/2023.
//

import Foundation

class QuestionnaireListProvider: ObservableObject {
    
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
        QuestionnaireListProvider.docFolder
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
        let index = questionnaires.index(using: questionnaire)
        let singularSet = IndexSet([index])
        
        try delete(indexSet: singularSet)
    }
    
    func delete(indexSet: IndexSet) throws {
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
    
    static func loadFromStorage() throws -> QuestionnaireListProvider {
        let ouput = QuestionnaireListProvider.blank()
        try ouput.reload()
        
        return ouput
    }
    
    static func blank() -> QuestionnaireListProvider {
        .init(questionnaire: [])
    }
}

protocol HierarchableData: Identifiable, Codable, Hashable {
    
}

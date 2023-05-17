//
//  QuestionnaireListProvider.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 17/05/2023.
//

import Foundation

class QuestionnaireListProvider: ObservableObject {
    
    @Published var questionnaire: [Questionnaire]
    
    init(questionnaire: [Questionnaire]) {
        self.questionnaire = questionnaire
    }
    
    func checkValidity() -> Bool {
        !questionnaire.contains(where: { !Questionnaire.validate(questionnaire: $0) })
    }
    
    static var docFolder: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func save(questionnaire: Questionnaire) {
        
    }
    
    func rename(questionnaire: Questionnaire, to newName: String) {
        
    }
    
    func delete(questionnaire: Questionnaire) {
        
    }
    
    func reload() {
        
    }
    
    static func loadFromStorage() throws -> QuestionnaireListProvider {
        let fm = FileManager.default
        let path = Self.docFolder.path(percentEncoded: false)
        
        var questionnaires = [Questionnaire]()
        
        let items = try fm.contentsOfDirectory(atPath: path).filter { item in
            item.contains("Document/questionnaire - ")
        }

        for item in items {
            do {
                guard let data = fm.contents(atPath: item) else { throw CocoaError(.fileReadCorruptFile) }
                let decoded = try JSONDecoder().decode(Questionnaire.self, from: data)
                
                questionnaires.append(decoded)
            }
        }
        
        return .init(questionnaire: questionnaires)
    }
    
    static func blank() -> QuestionnaireListProvider {
        .init(questionnaire: [])
    }
}

//
//  QuestionCard.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

struct QuestionCard: Identifiable {
    var id = UUID()
    
    let title: String
    let subtitle: String?
    
    let marks: Double
    
    var bgColorHex: String? = nil
    
    let possibleAnswers: [Answer]
    var allCorrectAnswersRequired = false
    
    var correctAnswersCount: Int {
        possibleAnswers.filter { $0.isCorrect }.count
    }
    
}

extension QuestionCard: Codable {
    struct Answer: Codable, Identifiable {
        var id = UUID()
        var name: String
        
        let style: StyleInfo?
        
        var isCorrect: Bool
        
        struct StyleInfo: Codable {
            let color: String
            let shape: String
            let accent: String?
            
            var accentScheme: ColorScheme? {
                switch accent {
                case .none: return nil
                case "dark": return .dark
                case "light": return .light
                default: return nil
                }
            }
        }
        
        var color: SwiftUI.Color {
            Color(hex: style?.color ?? "fail it lol", colorSpace: .displayP3) ?? .primary
        }
        
        var shape: SwiftUI.Image { Image(systemName: style?.shape ?? "circle.fill") }
    }
    
    init(title: String, subtitle: String? = nil, bgColorHex: String? = nil, possibleAnswers: [Answer], allCorrectAnswersRequired: Bool = false) {
        self.id = UUID()
        
        self.title = title
        self.subtitle = subtitle
        self.marks = Double(possibleAnswers.count - 1)
        self.bgColorHex = bgColorHex
        self.possibleAnswers = possibleAnswers
        self.allCorrectAnswersRequired = allCorrectAnswersRequired
    }
    
    enum FieldIdentifier {
        case title, subtitle, marks, bgColor, allCorrectAnswersRequired
        
        func namespace(question: QuestionCard) -> String {
            "q_card-\(question.id):\(self)"
        }
    }
    
    public func generateNamespace(for field: FieldIdentifier, tag: String? = nil) -> String {
        field.namespace(question: self) +
            (tag != nil ? "(\(tag!.replacingOccurrences(of: " ", with: "_")))" : "")
    }
}

extension ColorScheme {
    var schemeDesc: String {
        switch self {
        case .light:
            return "light"
        case .dark:
            return "dark"
        @unknown default:
            fatalError()
        }
    }
}

extension QuestionCard.Answer.StyleInfo {
    init(color: String, shape: String) {
        self.color = color
        self.shape = shape
        self.accent = nil
    }
}

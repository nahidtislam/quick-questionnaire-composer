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
    
    var bgStyle: BGStyle?
    
    let possibleAnswers: [Answer]
    var allCorrectAnswersRequired = false
    
    var correctAnswersCount: Int {
        possibleAnswers.filter { $0.isCorrect }.count
    }
    
    struct BGStyle: Codable {
        let color: String
        let accent: String?
        
        var colorGraphic: Color? { Color(hex: color, colorSpace: .displayP3) }
        var accentScheme: ColorScheme? {
            switch accent {
            case .none: return nil
            case "dark": return .dark
            case "light": return .light
            default: return nil
            }
        }
        var accentGraphic: Color {
            guard let scheme = accentScheme else { return .primary }
            return scheme == .dark ? .black : .white
        }
    }
}

extension QuestionCard: Codable, Equatable {
    struct Answer: Codable, Identifiable {
        var id = UUID()
        var name: String
        
        let style: StyleInfo?
        
        var isCorrect: Bool
        
        struct StyleInfo: Codable {
            let shape: String
            let bgInfo: BGStyle
        }
        
        var shape: SwiftUI.Image { Image(systemName: style?.shape ?? "circle.fill") }
    }
    
    init(title: String, subtitle: String? = nil, bgStyle: BGStyle? = nil, possibleAnswers: [Answer], allCorrectAnswersRequired: Bool = false) {
        self.id = UUID()
        
        self.title = title
        self.subtitle = subtitle
        self.marks = Double(possibleAnswers.count - 1)
        self.bgStyle = bgStyle
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
    
    static func == (lhs: QuestionCard, rhs: QuestionCard) -> Bool {
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle &&
        lhs.marks == rhs.marks &&
        lhs.possibleAnswers == rhs.possibleAnswers &&
        lhs.bgStyle == rhs.bgStyle
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

extension QuestionCard.BGStyle: Equatable {
    static func == (lhs: QuestionCard.BGStyle, rhs: QuestionCard.BGStyle) -> Bool {
        lhs.color == rhs.color && lhs.accent == rhs.accent
    }
}

extension QuestionCard.Answer.StyleInfo {
    init(color: String, shape: String) {
        self.bgInfo = .init(color: color, accent: nil)
        self.shape = shape
    }
}

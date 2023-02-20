//
//  Array+RawRepresentable.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import Foundation

extension Array: RawRepresentable where Element: Codable {
    // credit: https://stackoverflow.com/a/65598711
    
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

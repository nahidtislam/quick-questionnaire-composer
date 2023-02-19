//
//  Color+HexStringInit.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

extension Color {
    init?(hex: String) {
        let input =  hex.trimmingCharacters(in: .whitespaces)
        guard input.first == "#" && input.count == 7 else { return nil }
        
        func hexi(section: Int) -> String {
            let eq = section * 2
            
            let lower = input.index(input.startIndex, offsetBy: eq - 1)
            let upper = input.index(input.startIndex, offsetBy: eq + 1)
            
            return String(input[lower..<upper])
        }
        
        func floatThe(string value: String) -> CGFloat {
            let val = Int(value, radix: 16)!
            let max: Double = 255
            
            return Double(val) / max
        }
        
        let rHex = hexi(section: 1)
        let gHex = hexi(section: 2)
        let bHex = hexi(section: 3)
        
        let rValue = floatThe(string: rHex)
        let gValue = floatThe(string: gHex)
        let bValue = floatThe(string: bHex)
        
        self.init(red: rValue, green: gValue, blue: bValue)
    }
}

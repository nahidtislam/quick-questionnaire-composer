//
//  NumericTextField.swift
//  money slice visualiser
//
//  Created by Nahid Islam on 04/04/2023.
//

import SwiftUI

struct NumericTextField: View {
    let title: String
    @Binding var number: Double
    @State private var text = ""
    
    let digitLimit: Int?
    let decimalLimit: Int?
    
    var appearWithZero = true
    
    var body: some View {
        TextField(title, text: $text)
            .keyboardType(decimalLimit == 0 ? .numberPad : .decimalPad)
//            .onReceive(Just(text), perform: process)
            .onAppear(perform: initDisplay)
            .onChange(of: text, perform: process)
    }
    
    private func process(text updated: String) {
        let filtered = updated
            .filter { "0123456789.".contains($0) }
            .replacingOccurrences(of: "..", with: ".")
        if filtered != updated { text = filtered }
        if text.first == "." { text = "0." }
        
        let dotC = text.components(separatedBy: ".")
        if dotC.count > 2 {
            text = dotC[0..<2].joined(separator: ".")
        }
        limit(input: text)
    }
    
    private func initDisplay() {
        guard number != 0 || appearWithZero else { return }
        text = String(number)
    }
    
    private func limit(input: String) {
        guard let num = Double(input) else { number = 0; return }
        // MARK: get system's seprator
        let c = input.components(separatedBy: ".")
        var digit = c[0]
        var decimal: String
//        print("yes: \(input) <=> \(num)")
        if c.count == 1 {
            if digit.count > digitLimit ?? .max {
                digit.removeLast()
                text = digit
            }
            number = num
            return
        }
        
        decimal = c[1]
        
        if digit.count > digitLimit ?? .max {
            digit.removeLast()
            if decimal == "0" {
                text = digit
            } else {
                text = "\(digit).\(decimal)"
            }
        }
        if decimalLimit == 0 {
            text = digit
        } else if decimal.count > decimalLimit ?? .max {
            if decimal.count == 0 {
                text = digit
            } else {
                decimal.removeLast()
                text = "\(digit).\(decimal)"
            }
        }
        
        number = num
    }
}

extension NumericTextField {
    init(title: String, number: Binding<Double>, appearWithZero: Bool = true, decimalLimit: Int? = nil) {
        self.title = title
        self._number = number
        
        self.appearWithZero = appearWithZero
        
        self.digitLimit = nil
        self.decimalLimit = decimalLimit
    }
    
    func dontApeapearWithZeo() -> NumericTextField {
        var new = self
        new.appearWithZero = false
        
        return new
    }
}

struct NumericTextField_Previews: PreviewProvider {
    static var previews: some View {
        NumericTextField(title: "number", number: .constant(12), digitLimit: 4, decimalLimit: 4)
            .padding()
    }
}

//
//  TickBox.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 04/03/2023.
//

import SwiftUI

struct TickBox: View {
    
    var title: String
    @Binding var isOn: Bool
    
    var textColor = Color.primary
    
    var imagePair: [Bool : Image]?
    
    var body: some View {
        Button {
            withAnimation {
                isOn.toggle()
            }
        } label: {
            HStack {
                Text(title)
                    .foregroundColor(textColor)
                Spacer()
                imagePair?[isOn] ?? [true : Image(systemName: "checkmark")][isOn]
//                if let imagePair {
//                    imagePair[isOn]
//                } else if isOn {
//                    Image(systemName: "checkmark")
//                }
            }
        }
    }
    
    func textColor(_ color: Color) -> Self {
        var new = self
        new.textColor = color
        
        return new
    }
}

struct TickBox_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TickBox(title: "on", isOn: .constant(true))
            TickBox(title: "off", isOn: .constant(false))
            TickBox(title: "on img", isOn: .constant(true), imagePair: [true : Image(systemName: "mediastick"), false : Image(systemName: "ticket")])
            TickBox(title: "on img", isOn: .constant(false), imagePair: [true : Image(systemName: "mediastick"), false : Image(systemName: "ticket")])
        }
    }
}

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
    
    var titleColor: Color?
    var tickColor: Color?
    
    var imagePair: [Bool : Image]?
    
    var body: some View {
        Button {
            withAnimation {
                isOn.toggle()
            }
        } label: {
            HStack {
                Text(title)
                    .foregroundColor(titleColor)
                Spacer()
                imagePair?[isOn] ?? defaultTick
            }
        }
        .foregroundColor(tickColor)
    }
    
    private var defaultTick: Image? {
        isOn ? Image(systemName: "checkmark") : nil
    }
    
    func titleColor(_ color: Color) -> Self {
        var new = self
        new.titleColor = color
        
        return new
    }
    
    func tickColor(_ color: Color) -> Self {
        var new = self
        new.tickColor = color
        
        return new
    }
}

struct TickBox_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TickBox(title: "on", isOn: .constant(true))
            TickBox(title: "off", isOn: .constant(false))
            TickBox(title: "on img", isOn: .constant(true), imagePair: [true : Image(systemName: "mediastick"), false : Image(systemName: "ticket")])
            TickBox(title: "of img", isOn: .constant(false), imagePair: [true : Image(systemName: "mediastick"), false : Image(systemName: "ticket")])
        }
    }
}

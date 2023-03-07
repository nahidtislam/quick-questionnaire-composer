//
//  BackgroundColorPicker.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 06/03/2023.
//

import SwiftUI

struct BackgroundColorPicker: View {
    
    @Binding var selection: Color
    @Binding var accentSchme: ColorScheme?
    var name: String
    var label: String
    
    var font = Font.subheadline
    
    var body: some View {
        HStack {
            if selection != .clear {
                Button {
                    withAnimation { selection = .clear }
                } label: {
                    Text("clear")
                        .font(.footnote.weight(.bold).width(.condensed))
                        .padding(.horizontal, 4)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                        .padding(.trailing, -6)
                }
            }
            ColorPicker(selection: $selection, supportsOpacity: false) {
                ZStack{
                    // this is displayed to the actual picker
                    Text(name)
                        .frame(width: 0, height: 0)
                        .opacity(0)
                        .foregroundColor(.clear)
                    // shown to user before invoking picker
                    Text(label)
                        .font(.subheadline.width(.condensed))
                }
            }
            .animation(.easeOut, value: accentSchme)
            Picker("content accent", selection: $accentSchme) {
                Text("dark")
                    .tag(Optional<ColorScheme>.some(.dark))
                Text("light")
                    .tag(Optional<ColorScheme>.some(.light))
                Text("default")
                    .tag(Optional<ColorScheme>.none)
            }
            .pickerStyle(.automatic)
            .padding(.horizontal, -4)
            .padding(.leading, accentSchme == .none ? -6 : 0)
            .disabled(selection == .clear)
        }
    }
}

struct BackgroundColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            BackgroundColorPicker(selection: .constant(.clear), accentSchme: .constant(.none), name: "background color", label: "bg")
        }
    }
}

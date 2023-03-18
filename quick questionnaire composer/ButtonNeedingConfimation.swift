//
//  ButtonNeedingConfimation.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 11/03/2023.
//

import SwiftUI

struct ButtonNeedingConfimation: View {
    
    @Namespace var someNamespace
    
    let actionName: String
    let confirmationMessage: String
    
    let role: ButtonRole?
    let systemSymbol: String
    
    let action: () -> Void
    
    var transformationAnimation = Animation.easeOut(duration: 0.55)
    var buttonColor: Color?
    
    @State private var isClicked = false
    
    init(actionName: String, confirmationMessage: String, role: ButtonRole? = nil, systemSymbol: String, action: @escaping () -> Void) {
        self.actionName = actionName
        self.confirmationMessage = confirmationMessage
        self.role = role
        self.systemSymbol = systemSymbol
        self.action = action
    }
    
    var body: some View {
        HStack {
            if !isClicked {
                base
            } else {
                confirmation
            }
        }
    }
    
    private var roundedBgBorder: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(mainColor)
            .foregroundColor(Color(uiColor: .systemBackground))
    }
    
    private var isSlightlyTaller: Bool {
        confirmationMessage.count > 20
    }
    
    private var symbol: Image? {
        guard UIImage(systemName: systemSymbol) != nil else { return nil }
        return Image(systemName: systemSymbol)
        /*idk why the code below won't let it respect the forground color*/
//        if let symbol = UIImage(systemName: systemSymbol) {
//            return Image(uiImage: symbol)
//        } else {
//            return nil
//        }
    }
    
    private var base: some View {
        ZStack {
            Button(role: role) {
                withAnimation(transformationAnimation) {
                    isClicked = true
                }
            } label: {
                HStack {
                    symbol
                        .matchedGeometryEffect(id: "symbol", in: someNamespace)
                    Text(actionName)
                        .matchedGeometryEffect(id: "action_text", in: someNamespace)
                }
                .foregroundColor(mainColor)
                .padding(6)
                .padding(.horizontal, 10)
                .background(roundedBgBorder.matchedGeometryEffect(id: "bg", in: someNamespace))
            }
            .zIndex(1)
            
            // extra inivis view for animation
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 35, height: 20)
                .animation(.none, value: isClicked)
                .disabled(true)
                .zIndex(0)
                .matchedGeometryEffect(id: "button_yes", in: someNamespace)
            Rectangle()
                .animation(.easeIn(duration: .leastNormalMagnitude), value: isClicked)
                .foregroundColor(.clear)
                .frame(width: 25, height: 20)
                .disabled(true)
                .zIndex(0)
                .matchedGeometryEffect(id: "button_no", in: someNamespace)
            Rectangle()
                .animation(.easeIn(duration: .leastNormalMagnitude), value: isClicked)
                .foregroundColor(.clear)
                .frame(width: 5, height: isSlightlyTaller ? 35 : 20)
                .disabled(true)
                .zIndex(0)
                .matchedGeometryEffect(id: "line_sep", in: someNamespace)
        }
    }
    
    private var confirmation: some View {
        HStack(spacing: 20) {
            symbol
                .foregroundColor(.white)
                .padding(.trailing, -6)
                .matchedGeometryEffect(id: "symbol", in: someNamespace)
            Text(confirmationMessage)
//                .animation(.default.delay(0.9), value: isClicked)
                .matchedGeometryEffect(id: "action_text", in: someNamespace, anchor: isSlightlyTaller ? .init(x: 0.25, y: 0.25) : .leading)
//                .lineLimit(1)
//                .truncationMode(.middle)
                .foregroundColor(.white)
            Rectangle()
                .frame(width: 2, height: 30)
                .foregroundColor(.white)
                .matchedGeometryEffect(id: "line_sep", in: someNamespace)
            Button("yes") {
                action()
                putTheThingBack()
            }
            .matchedGeometryEffect(id: "button_yes", in: someNamespace)
            .foregroundColor(.white)
            Button("no") {
                putTheThingBack()
            }
            .matchedGeometryEffect(id: "button_no", in: someNamespace)
            .foregroundColor(.white)
        }
        .padding(6)
        .padding(.horizontal, 10)
        .background(
            mainColor
                .cornerRadius(20)
                .matchedGeometryEffect(id: "bg", in: someNamespace)
        )
        
//        .transition(.scale(scale: 0.3))
    }
    
    private var mainColor: Color {
        buttonColor ?? (role == .destructive ? Color.red : Color.accentColor)
    }
    
    private func putTheThingBack() {
        withAnimation(transformationAnimation) {
            isClicked = false
        }
    }
    
    func transformationAnimation(_ value: Animation) -> ButtonNeedingConfimation {
        var new = self
        new.transformationAnimation = value
        
        return new
    }
    
    func buttonColor(_ value: Color?) -> ButtonNeedingConfimation {
        var new = self
        new.buttonColor = value
        
        return new
    }
}

struct ButtonNeedingConfimation_Previews: PreviewProvider {
    static var previews: some View {
        ButtonNeedingConfimation(actionName: "click it", confirmationMessage: "u sure u wanna do it?", role: .destructive, systemSymbol: "hand.tap.fill") {}
    }
}

extension ButtonNeedingConfimation {
    init(name: String, role: ButtonRole? = nil, systemSymbol: String = "", action: @escaping () -> Void) {
        self.actionName = name
        self.confirmationMessage = "are you sure you want to \(name)?"
        self.role = role
        self.systemSymbol = systemSymbol
        self.action = action
    }
}

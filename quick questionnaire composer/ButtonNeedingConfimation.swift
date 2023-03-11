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
    
    @State private var isClicked = false
    
    var body: some View {
        HStack {
            if !isClicked {
                base
            } else {
                confirmation
            }
        }
    }
    
    var base: some View {
        Button(actionName, role: role) {
            withAnimation(.easeIn(duration: 0.1)) {
                isClicked = true
            }
        }
        .matchedGeometryEffect(id: "l", in: someNamespace)
//        .transition(.scale(scale: 0.3))
    }
    
    var confirmation: some View {
        HStack {
            Text(confirmationMessage)
                .truncationMode(.middle)
                .matchedGeometryEffect(id: "l", in: someNamespace)
            Button("yes") {
                action()
                putTheThingBack()
            }
            Button("no") {
                putTheThingBack()
            }
        }
//        .transition(.scale(scale: 0.3))
    }
    
    func putTheThingBack() {
        withAnimation(.interactiveSpring()){
            isClicked = false
        }
    }
}

struct ButtonNeedingConfimation_Previews: PreviewProvider {
    static var previews: some View {
        ButtonNeedingConfimation(actionName: "click it", confirmationMessage: "u sure u wanna do it?", role: .destructive, systemSymbol: "cancel") {}
    }
}

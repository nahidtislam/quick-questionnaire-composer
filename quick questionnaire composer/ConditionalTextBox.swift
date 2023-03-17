//
//  ConditionalTextBox.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 11/03/2023.
//

import SwiftUI

struct ConditionalTextBox: View {
    
    let name: String
    
    @Binding var input: String?
    @State private var output = ""
    @State private var isVisible = false
    @Namespace var someNamespace
    
    var body: some View {
        HStack {
            if !isVisible {
                addTextButton
            } else {
                textContent
            }
        }
        .onAppear {
            if let input {
                isVisible = true
                output = input
            }
        }
    }
    
    var addTextButton: some View {
        Button {
            withAnimation {
                isVisible = true
                input = output
            }
        } label: {
            HStack(spacing: 0) {
                Text("add ")
//                    .transition(.move(edge: .trailing))
//                    .transition(.offset(x: -90))
                Text(name)
//                    .transition(.move(edge: .leading))
//                    .matchedGeometryEffect(id: "name", in: someNamespace)
            }
        }
//        .frame(maxWidth: .infinity)
//        .transition(.scale(scale: 0.8).combined(with: .opacity))
    }
    
    var textContent: some View {
        HStack {
            TextField(text: $output) {
                Text(name)
//                    .matchedGeometryEffect(id: "name", in: someNamespace)
            }
            .onChange(of: output) { newValue in
                input = output
                if input!.isEmpty { input = nil }
            }
//            .transition(.move(edge: .leading))
            Button("disable") {
                withAnimation {
                    removeInput()
                }
            }
            .transition(.scale)
//            .transition(.move(edge: .trailing))
        }
    }
    
    func removeInput() {
        isVisible = false
//        output = ""
        input = nil
    }
}

struct ConditionalTextBox_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ConditionalTextBox(name: "eg open", input: .constant("example"))
            ConditionalTextBox(name: "eg nah", input: .constant(nil))
        }
    }
}

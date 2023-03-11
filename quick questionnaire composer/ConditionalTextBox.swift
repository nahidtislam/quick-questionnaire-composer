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
                Button {
                    withAnimation {
                        isVisible = true
                        input = output
                    }
                } label: {
                    HStack(spacing: 0) {
                        Text("add ")
                        Text(name)
                            .matchedGeometryEffect(id: "name", in: someNamespace)
                    }
                }
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
    
    var textContent: some View {
        HStack {
            TextField(text: $output) {
                Text(name)
                    .matchedGeometryEffect(id: "name", in: someNamespace)
            }
            .transition(.move(edge: .leading))
            Button("disable") {
                withAnimation {
                    removeInput()
                }
            }
            .transition(.move(edge: .trailing))
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

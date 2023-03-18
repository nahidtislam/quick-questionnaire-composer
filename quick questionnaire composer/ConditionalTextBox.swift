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
        .onAppear { load(text: input) }
        .onChange(of: input, perform: load)
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
                Text(name)
            }
        }
    }
    
    var textContent: some View {
        HStack {
            TextField(text: $output) {
                Text(name)
            }
            .onChange(of: output) { newValue in
                input = newValue != "" ? newValue : nil
            }
            Button("disable") {
                withAnimation {
                    removeInput()
                }
            }
            .transition(.scale)
        }
    }
    
    func removeInput() {
        isVisible = false
        input = nil
    }
    
    func load(text input: String?) {
        guard let input else { return }
        isVisible = true
        output = input
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

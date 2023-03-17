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
    @State private var autoTransition = true
    
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
                autoTransition = false
                if newValue.isEmpty {
                    input = newValue
                } else {
                    input = nil
                }
                autoTransition = true
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
        /// input being will clear the output
//        let tOutput = output
        isVisible = false
        input = nil
//        output = tOutput // restores output when user reenable the text
    }
    
    func load(text input: String?) {
        guard let input else {
            if autoTransition {
                output = ""
                isVisible = false
            }
            return
        }
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

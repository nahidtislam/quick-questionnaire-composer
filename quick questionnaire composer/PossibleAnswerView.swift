//
//  PossibleAnswerView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 14/05/2023.
//

import SwiftUI

struct PossibleAnswerView: View {
    @State var answer: PossibleAnswer
    @State private var symbol = ""
    
    var body: some View {
        List {
            TextField("name", text: $answer.name)
            ConditionalTextBox(name: "symbol", input: $answer.symbol)
//            TextField("symbol", text: $symbol)
//                .onChange(of: symbol) { newValue in
//                    if newValue == "" {
//                        self.answer.symbol = nil
//                    } else {
//                        answer.symbol = newValue
//                    }
//                }
        }
    }
}

struct PossibleAnswerView_Previews: PreviewProvider {
    private struct Interactive: View {
        @State private var answer = PossibleAnswer(name: "example", symbol: "")
        
        var body: some View {
            PossibleAnswerView(answer: answer)
                .environmentObject(NavigationCoordinator())
        }
    }
    
    static var previews: some View {
        Interactive()
    }
}

extension PossibleAnswerView {
    struct Cell: View {
        let answer: PossibleAnswer
        let correct: Bool
        
        var body: some View {
            VStack {
                HStack {
                    if let symbol = answer.symbol {
                        Image(systemName: symbol)
                    }
                    Text(answer.name)
                    Spacer()
                    Image(systemName: correct ? "checkmark.circle.fill" : "x.circle")
                }
            }
        }
    }
}

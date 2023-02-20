//
//  AddQuetionsView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

struct AddQuetionsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var questionOutput = QuestionCard(title: "", subtitle: nil, possibleAnswers: [])
    
    @State private var title = ""
    @State private var subtitle = ""
    
    @State private var possibleAnswers = [QuestionCard.Answer]()
    
    var body: some View {
        VStack(alignment: .center) {
            TextField("title", text: $title)
            TextField("description", text: $subtitle)
            Rectangle()
                .frame(height: 4)
                .foregroundColor(.init(hex: "#bbeebb"))
                .padding(.horizontal, -10)
            VStack {
                ForEach(possibleAnswers.indices) { index in
                    TextField("", text: Binding<String>(get: {
                        possibleAnswers[index].name
                    }, set: { newValue, _ in
                        let old = possibleAnswers[index]
                        let new = QuestionCard.Answer(id: old.id, name: newValue, style: old.style, isCorrect: old.isCorrect)
                        possibleAnswers[index] = new
                    }))
                }
            }
            .background(Color(hex: "#99DDFF"))
            .cornerRadius(20)
            
            HStack(spacing: 40) {
                Button("cancel") {}
                Button("add") {}
            }
        }.padding(.horizontal, 35)
    }
    
    func generateValue() -> QuestionCard {
        let subtitle = self.subtitle != "" ? self.subtitle : nil
        
        return QuestionCard(title: title, subtitle: subtitle, possibleAnswers: possibleAnswers)
    }
}

struct AddQuetionsView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuetionsView()
    }
}

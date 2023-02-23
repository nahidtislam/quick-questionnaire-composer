//
//  QuestionView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 22/02/2023.
//

import SwiftUI

struct QuestionView: View {
    
    var quetion: QuestionCard
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(quetion.title)
                .font(.title)
                .padding(.horizontal, 10)
            line
            if let desc = quetion.subtitle {
                Text(desc)
                    .font(.title2)
                    .padding(.horizontal, 10)
            }
            HStack {
                Text("possible answers: ")
                Spacer()
                Text("\(quetion.possibleAnswers.count)")
            }
            if quetion.possibleAnswers.count > 2 {
                HStack {
                    Text("all answers required: ")
                    Spacer()
                    Text("\(quetion.allCorrectAnswersRequired ? "yes" : "no")")
                }
            }
        }
        .padding()
        .background(bg)
        .cornerRadius(16)
        .padding(12)
//        .background(bg.saturation(0.8).brightness(0.1))
        .background(bg.opacity(0.75))
        .cornerRadius(20)
        .padding(8)
//        .background(bg.saturation(0.6).brightness(0.2))
        .background(bg.opacity(0.5))
        .cornerRadius(24)
    }
    
    var line: some View {
        Rectangle()
            .frame(height: 3)
    }
    
    var bg: Color {
//        return .blue
        if let savedColor = Color(hex: quetion.bgColorHex ?? "fail it") {
            return savedColor
        } else {
            return colorScheme == .dark ? Color(hex: "#1E1E1E")! : Color(hex: "#EEEEEE")!
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(quetion: QuestionCard(title: "test", subtitle: "the desc", possibleAnswers: [], allCorrectAnswersRequired: true))
    }
}

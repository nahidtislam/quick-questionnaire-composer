//
//  QuestionsListView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

struct QuestionsListView: View {
    
    @AppStorage("cards") var cards: [QuestionCard] = []
    @State var editingForUUID: UUID?
    
    var vm = QuestionsListViewModel()
    
    var body: some View {
        NavigationStack {
            if cards.isEmpty {
                intro
                    .navigationTitle("welcome")
            } else {
                cardList
                    .navigationTitle("questions maker \(editingForUUID != nil ? "yes - \(editingForUUID!)" : "no")")
                Button("add") {
                    vm.addQuestion()
                }
                Button("clear") {
                    vm.cards.removeAll()
                    vm.editingAt = nil
                }
            }
        }
    }
    
    var cardList: some View {
        ScrollView {
            ForEach(cards) { card in
                if editingForUUID == card.id {
                    QuestionEditorView(question: $cards.first(where: { $0.id == card.id})!)
                } else {
                    QuestionView(quetion: card)
                        .background(Color(hue: 0.3, saturation: 0.6, brightness: 0.7, opacity: 0.9))
                        .cornerRadius(26)
                        .padding(12)
                        .background(Color(hue: 0.3, saturation: 0.5, brightness: 0.7, opacity: 0.7))
                        .cornerRadius(30)
                        .padding(8)
                        .background(Color(hue: 0.3, saturation: 0.4, brightness: 0.8, opacity: 0.7))
                        .cornerRadius(30)
                        .padding(4)
                        .onTapGesture {
                            editingForUUID = card.id
                        }
                }
            }
            .onDelete { indexSet in
                vm.cards.remove(atOffsets: indexSet)
            }
        }
    }
    
    var intro: some View {
        VStack {
            Text("add card")
                .font(.headline)
            Button {
                vm.addQuestion()
            } label: {
                Image(systemName: "plus.square.fill")
                    .font(.system(size: 80))
//                    .frame(width: 80, height: 80)
            }
        }
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsListView()
    }
    
    static let egQuestions: [QuestionCard] = {
        var output = [QuestionCard]()
        
        let qaStyle1 = QuestionCard.Answer.StyleInfo(color: "#10EE35", shape: "circle")
        let ans1 = QuestionCard.Answer(name: "answer 1", style: qaStyle1, isCorrect: false)
        let qaStyle2 = QuestionCard.Answer.StyleInfo(color: "#106600", shape: "square")
        let ans2 = QuestionCard.Answer(name: "answer 2", style: qaStyle1, isCorrect: true)
        
        QuestionCard(title: "hi", subtitle: "test quetion", marks: 1, possibleAnswers: [ans1, ans2])
        
        return output
    }()
}

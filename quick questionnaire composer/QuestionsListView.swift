//
//  QuestionsListView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

struct QuestionsListView: View {
    
    @AppStorage("cards") var cards: [QuestionCard] = []
    
    var vm = QuestionsListViewModel()
    
    var body: some View {
        NavigationStack {
            if vm.cards.isEmpty {
                intro
                    .navigationTitle("welcome")
            } else {
                cardList
                    .navigationTitle("questions maker")
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
        List {
            ForEach(cards) { card in
                QuestionView(quetion: card)
            }
        }
    }
    
    var intro: some View {
        VStack {
            Text("add card")
                .font(.headline)
            Button {
                print("clicled")
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

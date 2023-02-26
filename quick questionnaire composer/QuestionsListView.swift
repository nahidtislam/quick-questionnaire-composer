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
    
    @Namespace var someNamespace
    
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
                    QuestionEditorView(question: $cards.first(where: { $0.id == card.id})!, qSpace: someNamespace)
                        .matchedGeometryEffect(id: "q_card-\(card.id)", in: someNamespace)
                } else {
                    QuestionView(question: card, qSpace: someNamespace)
                        .padding(8)
                        .matchedGeometryEffect(id: "q_card-\(card.id)", in: someNamespace)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                editingForUUID = card.id
                            }
                        }
                }
            }
            .onDelete { indexSet in
                vm.cards.remove(atOffsets: indexSet)
//                if vm.cards[indexSet].contains(where: { $0.id == editingForUUID }) {
//                    editingForUUID = nil
//                }
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

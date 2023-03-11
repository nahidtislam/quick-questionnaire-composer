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
                    .navigationTitle("questions maker")
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button {
                                vm.addQuestion()
                                
                            } label: {
                                Label("add question", systemImage: "rectangle.stack.badge.plus")
                            }
                        }
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
                        .transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
                        .padding(12)
                } else {
                    QuestionView(question: card, qSpace: someNamespace)
                        .matchedGeometryEffect(id: "q_card-\(card.id)", in: someNamespace)
                        .padding(8)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                editingForUUID = card.id
                            }
                        }
                        .transition(.push(from: .top))
//                        .scaleEffect(x: editingForUUID == nil ? 1 : 0.95, y: editingForUUID == nil ? 1 : 0.95)
                }
            }
            .onDelete { indexSet in
                vm.cards.remove(atOffsets: indexSet)
//                if vm.cards[indexSet].contains(where: { $0.id == editingForUUID }) {
//                    editingForUUID = nil
//                }
            }
            
            ButtonNeedingConfimation(actionName: "clear", confirmationMessage: "are you sure you want to delete all questions?", role: .destructive, systemSymbol: "") {
                
                vm.cards.removeAll()
                vm.editingAt = nil
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

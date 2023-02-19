//
//  QuestionsView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

struct QuestionsView: View {
    
    @StateObject var vm = QuestionsViewModel(cards: [])
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.cards) { card in
                    Text(card.title)
                }
            }
            
        }
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView()
    }
    
    static let egQuestions: [QuestionCard] = {
        var output = [QuestionCard]()
        
        return output
    }()
}

//
//  QuestionsViewModel.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

class QuestionsViewModel: ObservableObject {
    @AppStorage("cards") var cards: [QuestionCard] = []
    
    
}

//
//  QuestionnaireListView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 15/05/2023.
//

import SwiftUI

struct QuestionnaireListView: View {
    @State var questionnaires: [Questionnaire]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct QuestionnaireListView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireListView(questionnaires: [])
            .environmentObject(NavigationCoordinator())
    }
}

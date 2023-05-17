//
//  QuestionnaireListView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 15/05/2023.
//

import SwiftUI

struct QuestionnaireListView: View {
    @State var questionnaires: [Questionnaire]
    @EnvironmentObject var navCoord: NavigationCoordinator
    
    var body: some View {
        List(questionnaires) { questionnaire in
            NavigationLink(value: PathForView.questionnaire(questionnaire)) {
                QuestionnaireView.Cell(questionnaire: questionnaire)
            }
        }
        .navigationTitle("questionnaires")
    }
}

struct QuestionnaireListView_Previews: PreviewProvider {
    
    private struct InteractiveContainer: View {
        @State private var list = [ExampleUserData.oneQuestionnaire]
        
        var body: some View {
            NavigationStack {
                QuestionnaireListView(questionnaires: list)
                    .environmentObject(NavigationCoordinator())
                    .environmentObject(QuestionnaireListProvider.blank())
            }
        }
        
    }
    
    static var previews: some View {
        InteractiveContainer()
    }
}

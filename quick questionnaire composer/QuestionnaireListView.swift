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
    @EnvironmentObject var provider: ListProvider
    
    var body: some View {
        List {
            ForEach(questionnaires) { questionnaire in
                NavigationLink(pfView: .questionnaire(questionnaire)) {
                    QuestionnaireView.Cell(questionnaire: questionnaire)
                }
            }
            .onDelete { indexSet in
                try? provider.delete(indexSet: indexSet)
                withAnimation {
                    questionnaires = provider.questionnaires
                }
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
                    .environmentObject(ListProvider.blank())
            }
        }
        
    }
    
    static var previews: some View {
        InteractiveContainer()
    }
}

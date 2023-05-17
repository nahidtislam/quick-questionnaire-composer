//
//  WelcomeView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 14/05/2023.
//

import SwiftUI

struct WelcomeView: View {
    
    @StateObject var provider = (try? QuestionnaireListProvider.loadFromStorage()) ?? .blank()
    @StateObject private var navCoord = NavigationCoordinator()
    
    @State private var newQuestionnaire = Questionnaire(name: "", symbol: "", questions: [])
    
    var body: some View {
        NavigationStack(path: $navCoord.navNodes) {
            VStack {
                Text("welcome")
                    .font(.system(.largeTitle, design: .rounded, weight: .black))
                NavigationLink("create new", value: PathForView.questionnaire(newQuestionnaire))
//                Button("create new") {
//                    navCoord.add(destination: .questionnaire(newQuestionnaire))
//                }
                Button("continue") {
                    navCoord.add(destination: .questionnaireList(provider.questionnaires))
                }
                .disabled(provider.questionnaires.count < 1)
            }
            .toolbar(.hidden)
            .navigationTitle("welcome")
            .navigationDestination(for: PathForView.self) { dest in
                dest
            }
        }
        .environmentObject(provider)
        .environmentObject(navCoord)
        .onAppear {
            print(provider.questionnaires)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

//
//  WelcomeView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 14/05/2023.
//

import SwiftUI

struct WelcomeView: View {
    
    @StateObject var provider = (try? QuestionnaireProvider.loadFromStorage()) ?? .blank()
    
    @State private var navCoord = NavigationCoordinator()
    @State private var newQuestionnaire = Questionnaire(name: "", symbol: "", questions: [])
    
    var body: some View {
        NavigationStack(path: $navCoord.navNodes) {
            VStack {
                Text("welcome")
                    .font(.system(.largeTitle, design: .rounded, weight: .black))
//                NavigationLink("create new", value: PathForView.questionnaire(newQuestionnaire))
                Button("create new") {
                    print(navCoord.navNodes)
                    navCoord.add(destination: .questionnaire(newQuestionnaire))
                    print(navCoord.navNodes)
                }
                Button("continue") {
                    navCoord.add(destination: .questionnaireList(provider.questionnaire))
                }
                .disabled(provider.questionnaire.count < 1)
            }
            .toolbar(.hidden)
            .navigationTitle("welcome")
            .navigationDestination(for: PathForView.self) { dest in
                dest
            }
        }
        .environmentObject(provider)
        .environmentObject(navCoord)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

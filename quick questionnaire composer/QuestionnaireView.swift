//
//  QuestionnaireView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 14/05/2023.
//

import SwiftUI

struct QuestionnaireView: View {
    @State var questionnaire: Questionnaire
    
    @State private var nameNeedingToBeSet = false
    
    @EnvironmentObject var provider: QuestionnaireListProvider
    @EnvironmentObject var navCoord: NavigationCoordinator
    
    var body: some View {
        List {
            Section("questions") {
                ForEach($questionnaire.questions) { $question in
                    NavigationLink {
                        QuestionView(question: question)
                    } label: {
                        QuestionView.Cell(question: question)
                    }
                    
                }
                .onDelete { indexSet in
                    questionnaire.questions.remove(atOffsets: indexSet)
                }
            }
            Button("new question") {
                let newQuestion = Question(title: "", possibleAnswers: [], correctAnswersID: [], marks: 0, allAnswersRequired: false)
                questionnaire.questions.append(newQuestion)
                navCoord.add(destination: .question(newQuestion))
            }
        }
        .navigationTitle(questionnaire.name)
        .onAppear {
            nameNeedingToBeSet = questionnaire.name.count == 0
        }
        .onDisappear {
            if questionnaire.name.count > 0 {
                try? provider.save(questionnaire: questionnaire)
                try? provider.reload()
            }
        }
        .sheet(isPresented: $nameNeedingToBeSet) {
            if questionnaire.name.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
                self.navCoord.goBack()
            }
        } content: {
            Form {
                TextField("set name", text: $questionnaire.name)
                    .onSubmit {
                        nameNeedingToBeSet = false
                    }
            }
            .navigationTitle("please set name")
        }
        .navigationDestination(for: PathForView.self) { $0 }
    }
}

struct QuestionnaireView_Previews: PreviewProvider {
    
    private struct Interactive: View {
        @State private var questionnaire = Questionnaire(name: "example", symbol: "00.square.fill", questions: [])
        
        var body: some View {
            QuestionnaireView(questionnaire: questionnaire)
                .environmentObject(QuestionnaireListProvider(questionnaire: [questionnaire]))
                .environmentObject(NavigationCoordinator())
        }
        
    }
    
    static var previews: some View {
        Interactive()
    }
}

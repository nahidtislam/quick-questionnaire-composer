//
//  AddQuetionsView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

struct AddQuetionsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm = ViewModel()
    
    @State private var b = false
    
    var body: some View {
        VStack(alignment: .center) {
            TextField("title", text: $vm.titleInput)
            TextField("description \(vm.possibleAnswers.indices.upperBound)", text: $vm.subtitleInput)
            Rectangle()
                .frame(height: 4)
                .foregroundColor(.init(hex: "#bbeebb"))
                .padding(.horizontal, -10)
            answerBox
            
            HStack(spacing: 40) {
                Button("cancel") {}
                Button("add") {}
            }
        }.padding(.horizontal, 35)
    }
    
    var answerBox: some View {
        VStack {
            Button("add answer") {
                let ans = QuestionCard.Answer(name: "", style: nil, isCorrect: false)
                withAnimation {
                    vm.possibleAnswers.append(ans)
                }
            }
            ScrollView {
                ForEach($vm.possibleAnswers) { i in
                    answer(item: i)
                        .id(i.id)
                }
            }
            .frame(height: 40 * CGFloat(min(6, vm.possibleAnswers.count)))
            Button("delte answer") {
                withAnimation {
                    _ = vm.possibleAnswers.removeLast()
                }
            }
        }
        .padding(6)
        .background(Color(hex: "#99DDFF"))
        .cornerRadius(20)
    }
    
    func answer(item: Binding<QuestionCard.Answer>) -> some View {
        HStack {
            item.wrappedValue.shape
                .resizable()
                .frame(width: 20, height: 20)
            TextField("answer name", text: item.name)
            Spacer()
            Toggle("is correct", isOn: item.isCorrect)
        }
        .transition(.move(edge: .bottom))
    }
}

struct AddQuetionsView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuetionsView()
    }
}

extension AddQuetionsView {
    class ViewModel: ObservableObject {
        let questionUUID = UUID()
        
        var titleInput = ""
        var subtitleInput = ""
        
        var subtitleIsEnabled = false
        var allCorrectAnswersRequired = false
        
        @Published var possibleAnswers = [QuestionCard.Answer]()
        
        var subtitleOutput: String? {
            if subtitleIsEnabled && subtitleInput != "" {
                return subtitleInput
            }  else {
                return nil
            }
        }
        
        var questionOutput: QuestionCard {
            .init(
                id: questionUUID,
                title: titleInput,
                subtitle: subtitleOutput,
                possibleAnswers: possibleAnswers,
                allCorrectAnswersRequired: allCorrectAnswersRequired
            )
        }
    }
}

//
//  AddQuetionsView.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

struct AddQuetionsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var quetionTitle = ""
    @State private var quetionDesc = ""
    
    var body: some View {
        VStack(alignment: .center) {
            TextField("title", text: $quetionTitle)
            TextField("description", text: $quetionDesc)
            HStack(spacing: 40) {
                Button("cancel") {}
                Button("add") {}
            }
        }.padding(.horizontal, 35)
    }
}

struct AddQuetionsView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuetionsView()
    }
}

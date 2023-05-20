//
//  NavigationCoordinator.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 16/05/2023.
//

import SwiftUI

final class NavigationCoordinator: ObservableObject {
    
    @Published var navNodes = [PathForView]()
    
    func add(destination: PathForView) {
        navNodes.append(destination)
    }
    
    var uuidFlow: [UUID] {
        navNodes.map { $0.uuidForContainingData }
    }
    
    func goBack(by steps: Int = 1) {
        navNodes.removeLast(steps)
    }
    
    func goHome() {
        navNodes = []
    }
}

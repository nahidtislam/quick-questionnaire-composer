//
//  Array+IndexFromIdentifiableElement.swift
//  money slice visualiser
//
//  Created by Nahid Islam on 08/05/2023.
//

import Foundation

extension Array where Element: Identifiable {
    func index(using compared: Element) -> Int {
        guard let index = self.firstIndex(where: { ele in
            ele.id == compared.id
        }) else { fatalError("mismatching array") }
        
        return index
    }
}

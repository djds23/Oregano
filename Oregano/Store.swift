//
//  Store.swift
//  Oregano
//
//  Created by Dean Silfen on 12/8/19.
//  Copyright © 2019 Dean Silfen. All rights reserved.
//

import UIKit

class Store {
    
    static var shared = Store()

    var currentState = State(
        recipe: Recipe(),
        editingState: .default
    )
    
    var currentText: String? {
        currentState.recipe[keyPath: currentState.editingState.keypath]
    }

    func update(action: Action) {
        switch action {
        case let .updateText(string):
            let keyPath = currentState.editingState.keypath
            currentState.recipe[keyPath: keyPath] = string
        case let .updateEditingState(state):
            currentState.editingState = state
        }
    }
}

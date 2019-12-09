//
//  State.swift
//  Oregano
//
//  Created by Dean Silfen on 12/8/19.
//  Copyright © 2019 Dean Silfen. All rights reserved.
//

import UIKit

struct State {
    var recipe: Recipe
    var editingState: EditingState
}

struct Recipe: Codable {
    var name: String?
    /// Separated by \n newlines
    var ingredients: String?
    var directions: String?
}

enum EditingState: CaseIterable {
    case title
    case ingredients
    case instructions
    
    static var `default`: EditingState {
        .title
    }
    
    static var statesByIndex: [Int: EditingState] {
        Dictionary(
            uniqueKeysWithValues: EditingState.allCases.map { ($0.segment, $0) }
        )
    }

    var segment: Int {
        switch self {
        case .title:
            return 0
        case .ingredients:
            return 1
        case .instructions:
            return 2
        }
    }
    
    var text: String {
        switch self {
        case .title:
            return "Title"
        case .ingredients:
            return "Ingredients"
        case .instructions:
            return "Instructions"
        }
    }
    
    var keypath: WritableKeyPath<Recipe, String?> {
        switch self {
        case .title:
            return \Recipe.name
        case .ingredients:
            return \Recipe.ingredients
        case .instructions:
            return \Recipe.directions
        }
    }
}

//
//  ViewModel.swift
//  Set
//
//  Created by Kristina Grebneva on 20.12.2023.
//

import Foundation

class SetGame: ObservableObject {
    @Published var viewModel = Model()
    
    var countOfGettedSets: Int {
        viewModel.countOfGettedSets
    }
    
    var cards: [Model.Card] {
        viewModel.cards
    }
    
    var countOfShowingCards: Int {
        viewModel.countOfShowingCards
    }
    
    var isSetSelected: Bool {
        viewModel.isSetSelected
    }
    
    var isSetMatched: Bool {
        viewModel.checkSet()
    }
    
    func addCards() {
        viewModel.addCards()
    }
    
    func chooseCard(_ card: Model.Card) {
        viewModel.chooseCard(card)
    }
    
    init() {
        viewModel.makeArray()
        viewModel.shuffle()
    }
}

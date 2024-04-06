//
//  ViewModel.swift
//  Set
//
//  Created by Kristina Grebneva on 20.12.2023.
//

import Foundation

class SetGame: ObservableObject {
    @Published var viewModel: Model
    
    var countOfGettedSets: Int {
        viewModel.countOfGettedSets
    }
    
    var cards: [Model.Card] {
        viewModel.cards
    }
    
    var showingCards: [Model.Card] {
        viewModel.showingCards
    }
    
    var discardPile: [Model.Card] {
        viewModel.discardPile
    }
    
    var countOfShowingCards: Int {
        viewModel.countOfShowingCards
    }
    
    var countOfNotASet: Int {
        viewModel.countOfNotASet
    }
    
    var isSetSelected: Bool {
        viewModel.isSetSelected
    }
    
    var allCardsAreOnTheDesk: Bool {
        viewModel.showingCards.count + viewModel.countOfGettedSets * 3 == viewModel.cards.count
    }
    
    var isGameOver: Bool {
        allCardsAreOnTheDesk && checkGameOver()
    }
    
    func flipTheCards() {
        viewModel.flipTheCards()
    }
    
    func checkGameOver() -> Bool {
        return viewModel.checkGameOver()
    }
    
    func removeSelection() {
        viewModel.removeSelection()
    }
    
    func deleteCards() {
        viewModel.deleteCards()
    }
    
    func addCards() {
        viewModel.addCards()
    }
    
    func chooseCard(_ card: Model.Card) {
        viewModel.chooseCard(card)
    }
    
    init() {
        viewModel = Model()
        viewModel.makeArray()
    }
    
    func startNewGame() {
        viewModel = Model()
        viewModel.makeArray()
    }
}

//
//  Model.swift
//  Set
//
//  Created by Kristina Grebneva on 20.12.2023.
//

import Foundation
 
let startCountOfCards = 12
let countOfFullDeck = 81

struct Model {
    var cards: [Card]
    var showingCards: [Card]
    var discardPile: [Card]
    
    var countOfShowingCards: Int
    
    var indicesOfSet: [Int]
    
    var countOfGettedSets: Int
    var countOfNotASet: Int
    
    var isSetSelected: Bool {
        get {
            var count = 0
            showingCards.indices.forEach {if showingCards[$0].isSelected { count += 1 }}
            return count == 3 ? true : false
        }
    }
    
    struct Card: Identifiable, Equatable {
        var number: Options.Numbers
        var shape: Options.Shapes
        var shading: Options.Shadings
        var color: Options.Colors
        
        var isSelected: Bool = false
        var isMatched: Bool = false
        var isFacedUp: Bool = false
        
        var debugDescription: String {
            return "number: \(number)\(number.rawValue), shape: \(shape)\(shape.rawValue), shading: \(shading)\(shading.rawValue), color: \(color)\(color.rawValue)"
        }
        
        var shadingValue: Double {
            switch shading {
            case .solid:
                1
            case .striped:
                0.2
            case .open:
                0
            }
        }
        
        var id: UUID
        
        mutating func clearSelection() {
            isMatched = false
            isSelected = false
        }
    }
    
    init() {
        cards = []
        showingCards = []
        discardPile = []
        indicesOfSet = []
        countOfShowingCards = startCountOfCards
        countOfGettedSets = 0
        countOfNotASet = 0
    }
    
    mutating func flipTheCards() {
        showingCards.indices.forEach { showingCards[$0].isFacedUp = true }
    }
    
    func printCards() {
        showingCards.forEach {card in
            print(card.debugDescription)
        }
    }
    
    mutating func chooseCard(_ card: Card) {
        if let chosenIndex = showingCards.firstIndex(where: { $0.id == card.id }) {
            
            showingCards[chosenIndex].isSelected.toggle()
            
            showingCards[chosenIndex].isSelected ? indicesOfSet.append(chosenIndex) : indicesOfSet.removeAll(where: { $0 == chosenIndex} )
            
            if isSetSelected {
                if checkSet(at: indicesOfSet[0], indicesOfSet[1], indicesOfSet[2]) {
                    indicesOfSet.indices.forEach { showingCards[indicesOfSet[$0]].isMatched = true
                        showingCards[indicesOfSet[$0]].isSelected = false
                    }
                    countOfGettedSets += 1
                } else {
                    countOfNotASet += 1
                }
            }
            
        }
    }
    
    mutating func removeSelection() {
        indicesOfSet.indices.forEach {
            showingCards[indicesOfSet[$0]].isSelected = false
        }
        indicesOfSet.removeAll()
    }
    
    mutating func addCards() {
        for i in 0 ..< 3 {
            showingCards.append(cards[countOfShowingCards + i])
        }
        countOfShowingCards += 3
    }
    
    mutating func deleteCards() {
            indicesOfSet.sort(by: {$0 > $1})
            for i in 0 ..< indicesOfSet.count {
                var card = showingCards[indicesOfSet[i]]
                card.clearSelection()
                discardPile.append(card)
                
                showingCards.remove(at: indicesOfSet[i])
            }
            indicesOfSet.removeAll()
    }
    
    func checkGameOver() -> Bool {
        var isGameOver = true
        
        for i in 0 ..< showingCards.count {
            for j in i + 1 ..< showingCards.count {
                for k in j + 1 ..< showingCards.count {
                    if checkSet(at: i, j, k) {
                        isGameOver = false
                        print(i, j, k)
                        return isGameOver
                    }
                }
            }
        }
        return isGameOver
    }
    
    
    func checkSet(at i: Int, _ j: Int, _ k: Int) -> Bool {
        let card1 = showingCards[i]
        let card2 = showingCards[j]
        let card3 = showingCards[k]
     
        return allSameOrDifferent(card1.color, card2.color, card3.color)
        && allSameOrDifferent(card1.number, card2.number, card3.number)
        && allSameOrDifferent(card1.shading, card2.shading, card3.shading)
        && allSameOrDifferent(card1.shape, card2.shape, card3.shape)
    }
    
    func allSameOrDifferent<T: CaseIterable & RawRepresentable>(_ card1: T, _ card2: T, _ card3: T) -> Bool where T.RawValue == Int {
        
        return (card1.rawValue + card2.rawValue + card3.rawValue) % 3 == 0
    }
    
    mutating func makeArray() {
        for i in 0 ..< 171 {
            let shape: Options.Shapes? = chooseOption(number: i, range: 0)
            let color: Options.Colors? = chooseOption(number: i, range: 2)
            let number: Options.Numbers? = chooseOption(number: i, range: 4)
            let shading: Options.Shadings? = chooseOption(number: i, range: 6)
            
            if shape != nil && color != nil && number != nil && shading != nil{
                cards.append(Card(number: number!, shape: shape!, shading: shading!, color: color!, id: UUID()))
            }
        }
        
        cards.shuffle()
        
        cards.indices.forEach { index in
            if index < startCountOfCards {
                    showingCards.append(cards[index])
            }
        }
    }
    
    func chooseOption<T: CaseIterable & RawRepresentable>(number: Int, range: Int) -> T? where T.RawValue == Int {
        let a = number >> (2 + range)
        let b = (number - (a << (2 + range))) >> range
        
        for item in T.allCases {
            if b == item.rawValue {
                return item
            }
        }
        return nil
    }
    
    struct Options {
        enum Numbers: Int, CaseIterable  {
            case one = 0, two = 1, three = 2
        }
        enum Shapes: Int, CaseIterable {
            case circle = 0, diamond = 1, capsule = 2
        }
        enum Shadings: Int, CaseIterable {
            case solid = 0, striped = 1, open = 2
        }
        enum Colors: Int, CaseIterable {
            case pink = 0, blue = 1, green = 2
        }
    }
    
}

extension String {
    var decimalToBinary: String { return String(Int(self) ?? 0, radix: 2) }
    
    var binaryToInt: Int { return Int(strtoul(self, nil, 2)) }
    
    
    var treeToInt: Int { return Int(strtoul(self, nil, 3)) }
}

extension Int {
    var binaryString: String { return String(self, radix: 2) }
}


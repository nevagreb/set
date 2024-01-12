//
//  Model.swift
//  Set
//
//  Created by Kristina Grebneva on 20.12.2023.
//

import Foundation
 
let startCountOfCards = 16

struct Model {
    var cards: [Card]
    var showingCards: [Card]
    
    var countOfShowingCards: Int
    
    var indicesOfSet: [Int]
    var countOfGettedSets: Int
    
    var isSetSelected: Bool {
        get {
            var count = 0
            cards.indices.forEach {if cards[$0].isSelected { count += 1 }}
            return count == 3 ? true : false
        }
    }
    
    struct Card: Identifiable {
        var number: Options.Numbers
        var shape: Options.Shapes
        var shading: Options.Shadings
        var color: Options.Colors
        
        var isSelected: Bool = false
        var isMatched: Bool = false
        
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
    }
    
    init() {
        cards = []
        showingCards = []
        indicesOfSet = []
        countOfShowingCards = startCountOfCards
        countOfGettedSets = 0
    }
    
    mutating func addCards() {
        countOfShowingCards += 3
    }
    
    mutating func chooseCard(_ card: Card) {
        //print("\(card.debugDescription)")
        
        print(indicesOfSet)
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            
            cards[chosenIndex].isSelected.toggle()
            
            cards[chosenIndex].isSelected ? indicesOfSet.append(chosenIndex) : indicesOfSet.removeAll(where: { $0 == chosenIndex} )
            
            if isSetSelected {
                if checkSet() {
                    indicesOfSet.indices.forEach { cards[indicesOfSet[$0]].isMatched = true
                        cards[indicesOfSet[$0]].isSelected = false
                        countOfGettedSets += 1
                    }
                    
                    indicesOfSet.removeAll()
                }
                print("Res \(indicesOfSet)")
            }
            
        }
        
        print(indicesOfSet)
    
    }
    
    func checkSet() -> Bool {
        let card1 = cards[indicesOfSet[0]]
        let card2 = cards[indicesOfSet[1]]
        let card3 = cards[indicesOfSet[2]]
        
        //for debugging
        print(card1.debugDescription)
        print(card2.debugDescription)
        print(card3.debugDescription)
        
        let color = allSameOrDifferent(card1.color, card2.color, card3.color)
        
        print("Color: \(color)")
        
        let number = allSameOrDifferent(card1.number, card2.number, card3.number)
        print("Number: \(number)")
        
        let shading = allSameOrDifferent(card1.shading, card2.shading, card3.shading)
        print("Shading: \(shading)")
        
        let shape = allSameOrDifferent(card1.shape, card2.shape, card3.shape)
        print("Shape: \(shape)")
         
        return color && number && shading && shape
        
        //for app
       /* return allSameOrDifferent(card1.color, card2.color, card3.color)
        && allSameOrDifferent(card1.number, card2.number, card3.number)
        && allSameOrDifferent(card1.shading, card2.shading, card3.shading)
        && allSameOrDifferent(card1.shape, card2.shape, card3.shape)*/
    }
    
    func allSameOrDifferent<T: CaseIterable & RawRepresentable>(_ card1: T, _ card2: T, _ card3: T) -> Bool where T.RawValue == Int {
   
        //for debugging
        print("result: \(card1.rawValue) + \(card2.rawValue) + \(card3.rawValue)")
        
        return (card1.rawValue + card2.rawValue + card3.rawValue) % 3 == 0
    }
    
    mutating func shuffle() {
        cards.shuffle()
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

//extension Bool {
//    static func ^^(lhs:Bool, rhs:Bool) -> Bool {
//        if (lhs && !rhs) || (!lhs && rhs) {
//            return true
//        }
//        return false
//    }
//}

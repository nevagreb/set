//
//  ContentView.swift
//  Set
//
//  Created by Kristina Grebneva on 20.12.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = SetGame()
    
    private let dealAnimation: Animation = .easeInOut(duration: 0.5)
    private let dealInterval: TimeInterval = 0.1
    
    var body: some View {
        NavigationView {
            VStack {
                animatedCards
                    .animation(.easeInOut, value: viewModel.showingCards)
                HStack {
                    Spacer()
                    deck
                    Spacer()
                    discardPile
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("New Game") {
                        viewModel.startNewGame()
                    }
                }
            }
            .navigationTitle("SET!")
        }
    }
    
    @ViewBuilder
    var animatedCards: some View {
        if viewModel.isGameOver {
            Text("Congratulation!")
                .font(.title)
                .foregroundColor(.yellow)
        } else {
            cards
                .onChange(of: viewModel.countOfGettedSets) {
                    deleteCards() }
                .onChange(of: viewModel.countOfNotASet) { removeSelection() }
        }
    }
    
    private func removeSelection() {
        let delay = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(delay)) {
            viewModel.removeSelection()
        }
    }
    
    private func deleteCards() {
        let delay = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(Int(delay))) {
            withAnimation(dealAnimation) {
                viewModel.deleteCards()
            }
        }
    }
    
    typealias Card = Model.Card
    
    private let deckWidth: CGFloat = 50
    private let aspectRatio: CGFloat = 2/3
    
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var unDealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
    private var deck: some View {
        ZStack {
            ForEach(unDealtCards) { card in
                CardView(card, isFacedUp: false)
                    .matchedGeometryEffect(id: card.id, in: deckNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
            .frame(width: deckWidth, height: deckWidth / aspectRatio)
        }
        .onTapGesture {
                deal()
        }
    }
    
    private func deal() {
        if unDealtCards.count <= countOfFullDeck - startCountOfCards {
            viewModel.addCards()
        }
        var delay: TimeInterval = 0
        for card in viewModel.showingCards {
            if !isDealt(card) {
                _ = withAnimation(dealAnimation.delay(delay)) {
                    dealt.insert(card.id)
                }
                
                delay += dealInterval
            }
        }
    }
    
    private var discardPile: some View {
        ZStack {
            ForEach(viewModel.discardPile) { card in
                CardView(card, isFacedUp: true)
                    .matchedGeometryEffect(id: card.id, in: discardPileNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
            .frame(width: deckWidth, height: deckWidth / aspectRatio)
        }
    }
    
    @Namespace private var deckNamespace
    @Namespace private var discardPileNamespace
    
    var cards: some View {
        AspectVGrid(items: viewModel.showingCards, aspectRatio: aspectRatio) { card in
            if isDealt(card) {
                CardView(card, isSetSelected: viewModel.isSetSelected, isFacedUp: card.isFacedUp)
                    .onTapGesture {
                        withAnimation {
                            viewModel.chooseCard(card)
                        }
                    }
                    .disabled(viewModel.isSetSelected)
                    .matchedGeometryEffect(id: card.id, in: deckNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                
                    .matchedGeometryEffect(id: card.id, in: discardPileNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                
                    .onAppear {
                        flipCards()
                    }
            }
        }
    }
    
    private func flipCards() {
        var timeToFlip = 1
        if viewModel.countOfShowingCards == startCountOfCards {
            timeToFlip = 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(Int(timeToFlip))) {
            withAnimation(.easeInOut) {
                viewModel.flipTheCards()
            }
        }
    }
}

struct CardView: View {
    var card: Model.Card
    var isSetSelected: Bool = false
    var isFacedUp: Bool = true
    
    var color: Color {
        if card.isMatched {
            return Color.green.opacity(0.2)
        }
        if card.isSelected {
            return Color.pink.opacity(0.2)
        } else {
            return Color.white
        }
    }
    
    var body: some View {
        cardContent()
            .cardify(isFaceUp: isFacedUp, color: color)
            .padding(3)
    }
    
    init(_ card: Model.Card, isSetSelected: Bool) {
        self.card = card
        self.isSetSelected = isSetSelected
    }
    
    init(_ card: Model.Card, isFacedUp: Bool) {
        self.card = card
        self.isFacedUp = isFacedUp
    }
    
    init(_ card: Model.Card, isSetSelected: Bool, isFacedUp: Bool) {
        self.card = card
        self.isSetSelected = isSetSelected
        self.isFacedUp = isFacedUp
    }
    
    func cardContent() -> some View {
        VStack {
            ForEach(0 ..< card.number.rawValue + 1, id: \.self) {_ in
                shape
                    .scaleEffect(isSetSelected && card.isSelected && !card.isMatched ? 0.8 : 1)
                    .animation(.spring().repeatForever(), value: isSetSelected)
            }
            .modifier(ColorModifier(card))
        }
        .padding()
    }
    
    @ViewBuilder var shape: some View {
        switch card.shape {
        case .circle:
            Squiggle()
                .fill(.opacity(card.shadingValue))
                .strokeBorder(lineWidth: 2)
                .aspectRatio(2, contentMode: .fit)
        case .capsule:
            Capsule()
                .fill(.opacity(card.shadingValue))
                .strokeBorder(lineWidth: 2)
                .aspectRatio(2, contentMode: .fit)
        case .diamond:
            Rhombus()
                .strokeBorder(lineWidth: 2)
                .fill(.opacity(card.shadingValue))
                .aspectRatio(2, contentMode: .fit)
        }
    }
    
    struct ColorModifier: ViewModifier {
        var card: Model.Card
        
        init(_ card: Model.Card) {
            self.card = card
        }
        
        func body(content: Content) -> some View {
            switch card.color {
            case .pink:
                content.foregroundStyle(.pink)
            case .blue:
                content.foregroundStyle(.blue)
            case .green:
                content.foregroundStyle(.green)
                
            }
        }
    }
}

#Preview {
    ContentView()
}

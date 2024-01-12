//
//  ContentView.swift
//  Set
//
//  Created by Kristina Grebneva on 20.12.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = SetGame()
    
    var body: some View {
        NavigationView {
            cards
                .onChange(of: viewModel.countOfGettedSets) { delayCards()
                }
            // }
            //            .toolbar {
            //                ToolbarItem(placement: .topBarTrailing) {
            //                    Button("Button") {
            //                        if viewModel.isSetMatched {
            //                            print("SET")
            //                        } else {
            //                            print("NO")
            //                        }
            //                    }
            //                }
            
        }
    }
    
    private func delayCards() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            viewModel.addCards()
        }
    }
    
    var cards: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(count: viewModel.countOfShowingCards, size: geometry.size, atAspectRatio: 2/3)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(0 ..< viewModel.countOfShowingCards, id: \.self) {index in
                    withAnimation {
                        CardView(viewModel.cards[index])
                            .aspectRatio(2/3, contentMode: .fit)
                            .padding(4)
                            .onTapGesture {
                                viewModel.chooseCard(viewModel.cards[index])
                            }
                    }
                }
            }
        }
    }
    
    func gridItemWidthThatFits(count: Int, size: CGSize, atAspectRatio aspectRatio: CGFloat) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        
        print ("\(min(size.width / count, size.height * aspectRatio).rounded(.down))")
        
        return max(size.width / count, size.height * aspectRatio).rounded(.down)
    }
        
        
}

struct CardView: View {
    var card: Model.Card
    
    var color: Color {
        if card.isMatched {
            return Color.green
        }
        if card.isSelected {
            return Color.pink
        } else {
            return Color.white
        }
    }
    
    var body: some View {
        //if !card.isMatched {
            ZStack {
                let base = RoundedRectangle(cornerRadius: 12)
                Group {
                    base.strokeBorder(lineWidth: 2)
                        .background(base.foregroundColor(color.opacity(0.2)))
                        .overlay(content: cardContent)
                }
            }
        //}
    }
    
    init(_ card: Model.Card) {
        self.card = card
    }
    
    func cardContent() -> some View {
        VStack {
            ForEach(0 ..< card.number.rawValue + 1, id: \.self) {_ in
                shape
                    .scaleEffect(card.isMatched == true ? 1.1 : 1)
                    .animation(.spring().repeatForever(), value: card.isMatched)
                    .scaleEffect(card.isMatched == false && card.isSelected ? 0.8 : 1)
            }
            .modifier(ColorModifier(card))
        }
        .padding()
    }
    
    @ViewBuilder var shape: some View {
        switch card.shape {
        case .circle:
            Circle()
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

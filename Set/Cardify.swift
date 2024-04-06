//
//  Cardify.swift
//  Set
//
//  Created by Kristina Grebneva on 27.01.2024.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
    var isFaceUp: Bool {
        rotation < 90
    }
    
    init(isFaceUp: Bool, color: Color) {
        rotation = isFaceUp ? 0.001 : 180
        self.color = color
    }
    
    var rotation: Double
    var color: Color
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            
            base.strokeBorder(lineWidth: 2)
                .background(color)
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            
            base.fill(.orange)
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(
            .degrees(rotation), axis: (0, 1, 0)
        )
    }
}

extension View {
    func cardify(isFaceUp: Bool, color: Color) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, color: color))
    }
}

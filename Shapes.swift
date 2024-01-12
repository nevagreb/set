//
//  Shapes.swift
//  Set
//
//  Created by Kristina Grebneva on 08.01.2024.
//

import SwiftUI

struct Rhombus: Shape, InsettableShape {
    var insetAmount = 0.0
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))

        return path
    }
}

struct Shapes: View {
    var body: some View {
//        Rhombus()
//            .strokeBorder(.red, lineWidth: 40)
//            .background(.blue)
        GeometryReader {geometry in
           // VStack {
                //Text("A")
                Button("GGG") {
                }
          //  }
        }
    }
}

#Preview {
    Shapes()
}

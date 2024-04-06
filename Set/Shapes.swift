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

struct Squiggle : Shape, InsettableShape {
    var insetAmount = 0.0
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
    
    func path(in rect : CGRect) -> Path { // rect is the space offered for drawing
        
        let leftArcStart = CGPoint (x: rect.minX + rect.height/4, y: rect.maxY)
        let leftArcStop = CGPoint (x: rect.minX + 3 * rect.height/4, y: rect.minY)
        let rightArcStart = CGPoint (x: rect.maxX - rect.height/4, y: rect.minY)
        let rightArcStop = CGPoint (x: rect.maxX - 3 * rect.height/4, y: rect.maxY)
        
        var p = Path()
        
        // draw Squiggle
           // draw left arc
           p.move(to:leftArcStart)
           p.addCurve(to: leftArcStop, control1: CGPoint(x: rect.minX, y: rect.maxY), control2: CGPoint(x: rect.minX, y: rect.minY))

           //draw upper connection curve
           p.addCurve(to: rightArcStart, control1: CGPoint(x: rect.midX + rect.height/4, y: rect.minY), control2: CGPoint(x: rect.midX+rect.height/4, y: rect.midY))
    
           // draw right arc
           p.addCurve(to: rightArcStop, control1: CGPoint(x: rect.maxX, y: rect.minY), control2: CGPoint(x: rect.maxX, y: rect.maxY))

           //draw lower connection curve
           p.addCurve(to: leftArcStart, control1: CGPoint(x: rect.midX-rect.height/2, y: rect.midY), control2: CGPoint(x: rect.midX-rect.height/2, y: rect.maxY))
        //

        return p // return a Path
    }
}

struct Shapes: View {
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width * 0.85
            let height = geometry.size.height * 0.2
            Squiggle()
                .frame(width: width, height: height)
        }
    }
}




#Preview {
    Shapes()
}

//
//  FlipCard.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 12/03/2023.
//

import SwiftUI

struct FlipCard<FrontContent: View, BackContent: View>: View {
    
    @State private var side = FlipCard.Side.front
    @State private var rad = Angle(radians: 0)
    @State private var isFlipping = false
    
    @ViewBuilder var front: FrontContent
    @ViewBuilder var back: BackContent
    
    @State private var size: CGSize = .zero
    
    var flipTime = 0.5
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in HStack {} .onAppear { size = proxy.size } }
            switch side {
            case .front: front
            case .back:
                back
                    .rotation3DEffect(.radians(.pi), axis: (x: 0, y: 1, z: 0))
            }
        }
//        .frame(width: size.width, height: size.height)
        .onTapGesture {
            flipCard(animationTime: flipTime)
        }
        .disabled(isFlipping)
        .scaleEffect(scale)
        .rotation3DEffect(rad, axis: (x: 0, y: 1, z: 0))
//        .gesture(DragGesture()
//            .onChanged({ v in
//                rad += .init(radians: v.translation.width / (150 * .pi))
//            })
//            .onEnded({ v in
//                if rad < .radians(.pi) {
//                    rad = .init(radians: 0)
//                    side = .front
//                } else {
//                    side = .back
//                    rad = .init(radians: .pi)
//                }
//            }))
    }
    
    func flipCard(animationTime: CGFloat = 0.5) {
        isFlipping = true
        withAnimation(.linear(duration: animationTime / 2)) {
            rad += Angle(radians: .pi / 2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime / 2.1) {
            side.flip()
            isFlipping = false
        }
        withAnimation(.linear(duration: animationTime / 2).delay(animationTime / 2)) {
            rad += Angle(radians: .pi / 2)
        }
        if rad == .init(radians: 2 * .pi) { rad = .init(radians: 0) }
    }
    
    func flipTime(_ value: Double) -> FlipCard {
        var new = self
        new.flipTime = value
        
        return new
    }
    
    var scale: CGSize {
        let minimum = 0.5
        let compliment = 1 - minimum
//        let π = Double.pi
        
        let rad = rad.radians
        let rotation = (cos(2 * rad) + 1) / 2
        
        let shift = compliment * rotation
        
        let len = minimum + shift
        
        return .init(width: len, height: len)
    }
}

extension FlipCard {
    enum Side {
        case front, back
        
        var opposite: Side {
            switch self {
            case .front:
                return .back
            case .back:
                return .front
            }
        }
        
        mutating func flip() { self = opposite }
    }
}

struct FlipCard_Previews: PreviewProvider {
    static var previews: some View {
        FlipCard {
            RoundedRectangle(cornerRadius: 50)
                .foregroundColor(Color(hex: "#33EEFF"))
                .overlay(Text(try! AttributedString(markdown: "this is _front_")))
                .frame(width: 300, height: 420)
        } back: {
            RoundedRectangle(cornerRadius: 50)
                .foregroundColor(Color(hex: "#33EE77"))
                .overlay(Text(try! AttributedString(markdown: "this is _back_")))
                .frame(width: 360, height: 180)
        }
        .flipTime(0.5)
    }
}

//
//  Sparkline.swift
//  crypto-app
//
//  Created by Montasir Moyen on 9/27/25.
//

import SwiftUI

struct SparklineView: View {
    let data: [Double]
    let isPositive: Bool
    var lineWidth: CGFloat = 2

    var body: some View {
        GeometryReader { geo in
            if data.count >= 2 {
                let maxY = data.max() ?? 1
                let minY = data.min() ?? 0
                let range = maxY - minY
                Path { path in
                    let stepX = geo.size.width / CGFloat(max(1, data.count - 1))
                    for index in data.indices {
                        let x = CGFloat(index) * stepX
                        let y: CGFloat
                        if range == 0 {
                            y = geo.size.height / 2
                        } else {
                            y = geo.size.height * (1 - CGFloat((data[index] - minY) / range))
                        }

                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(
                    isPositive ? Color.green : Color.red,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
                )
            } else {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geo.size.height / 2))
                    path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height / 2))
                }
                .stroke(isPositive ? Color.green.opacity(0.6) : Color.red.opacity(0.6), lineWidth: 1)
            }
        }
    }
}

struct SparklineView_Previews: PreviewProvider {
    static var up: [Double] = (0..<40).map { i in Double(100 + i) + Double.random(in: -4...4) }
    static var down: [Double] = (0..<40).map { i in Double(140 - i) + Double.random(in: -4...4) }

    static var previews: some View {
        VStack(spacing: 12) {
            SparklineView(data: up, isPositive: true)
                .frame(width: 120, height: 40)
            SparklineView(data: down, isPositive: false)
                .frame(width: 120, height: 40)
        }
        .padding()
        .background(Color.black)
        .previewLayout(.sizeThatFits)
    }
}

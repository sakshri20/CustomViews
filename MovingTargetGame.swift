//
//  MovingTargetGame.swift
//  CustomViews
//
//  Created by Sakshi Shrivastava on 3/10/26.
//

import SwiftUI
import Combine

struct MovingTargetGame: View {
    @State private var position = CGPoint(x: 100, y: 100)
    
    @State private var score = 0

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

        var body: some View {
            ZStack {
                Text("Score: \(score)")
                    .font(.title)
                    .padding()
                    .position(x: 200, y: 50)

                Circle()
                    .fill(Color.red)
                    .frame(width: 60, height: 60)
                    .position(position)
                    .onTapGesture {
                        score += 1
                    }
            }
            .onReceive(timer) { _ in
                moveTarget()
            }
        }

        func moveTarget() {
            position = CGPoint(
                x: CGFloat.random(in: 50...350),
                y: CGFloat.random(in: 100...700)
            )
        }
}

#Preview {
    MovingTargetGame()
}

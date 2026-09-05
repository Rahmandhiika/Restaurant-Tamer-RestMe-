//
//  ContentView.swift
//  RestMe
//
//  Created by Rahmandhika Putra Purwdi Wicaksono on 05/09/26.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    let scene = GameScene(size: GameConfig.sceneSize)

    var body: some View {
        SpriteView(scene: scene)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}

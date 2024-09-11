//
//  GameScene.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 07/09/2024.
//

import SpriteKit


class GameScene: SKScene {
    
    var player: Player!
    
    func addPlayer() {
        player = Player(imageNamed: GameConstants.StringConstants.playerImageName)
        player.scale(to: frame.size, width: false, multiplier: 0.1)
        player.name = GameConstants.StringConstants.playerName
        
        player.position = CGPoint(x: frame.midX/2.0, y: frame.midY)
        
        player.loadTextures()
        player.state = .idle
    }
}

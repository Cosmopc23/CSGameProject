//
//  Player.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 11/09/2024.
//

import SpriteKit

enum PlayerState {
    case idle, running
}

class Player: SKSpriteNode {
    var idleFrames = [SKTexture]()
    
    var state = PlayerState.idle {
        willSet {
            animate(for: newValue)
        }
    }
    
    func loadTextures() {
        idleFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerIdleAtlas), withName: GameConstants.StringConstants.idlePrefixKey)
    }

    
    func animate(for state: PlayerState) {
        
        removeAllActions()
        switch state {
        case .idle:
            self.run(SKAction.repeatForever(SKAction.animate(withNormalTextures: idleFrames, timePerFrame: 0.05, resize: true, restore: true)))
        case .running:
            break
        }
    }
}

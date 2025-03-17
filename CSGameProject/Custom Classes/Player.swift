//
//  Player.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 11/09/2024.
//

import SpriteKit

enum PlayerState {
    case idle, running, throwIdle, throwRunning
}

class Player: SKSpriteNode {
    var idleFrames = [SKTexture]()
    var runFrames = [SKTexture]()
    var throwIdleFrames = [SKTexture]()
    var throwRunFrames = [SKTexture]()
    
    // State property observer automatically triggers animation when state changes
    var state = PlayerState.idle {
        willSet {
            animate(for: newValue)
        }
    }
    
    
    func loadTextures() {
        idleFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerIdleAtlas), withName: GameConstants.StringConstants.idlePrefixKey)
        runFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerRunAtlas), withName: GameConstants.StringConstants.runPrefixKey)
        throwIdleFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.throwingIdleAtlas), withName: GameConstants.StringConstants.throwingIdlePrefixKey)
        throwRunFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.throwingRunningAtlas), withName: GameConstants.StringConstants.throwingRunningPrefixKey)
    }

    
    func animate(for state: PlayerState) {
        removeAllActions()
        switch state {
        case .idle:
            self.run(SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.05, resize: true, restore: true)))
        case .running:
            self.run(SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.05, resize: true, restore: true)))
        case .throwIdle:
            self.run(SKAction.repeatForever(SKAction.animate(with: throwIdleFrames, timePerFrame: 0.05, resize: true, restore: true)))
        case .throwRunning:
            self.run(SKAction.repeatForever(SKAction.animate(with: throwRunFrames, timePerFrame: 0.05, resize: true, restore: true)))
        }
    }
}



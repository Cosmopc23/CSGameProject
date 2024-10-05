//
//  Competitors.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 04/10/2024.
//


import SpriteKit

enum Competitor1State {
    case idle, running
}

class Competitor1: SKSpriteNode {
    var idleFrames = [SKTexture]()
    var runFrames = [SKTexture]()
    
    var competitor1Speed: CGFloat = 60.0
    
    var state = Competitor1State.idle {
        willSet {
            animate(for: newValue)
        }
    }
    
    func loadTextures() {
        idleFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.competitor1IdleAtlas), withName: GameConstants.StringConstants.competitor1IdlePrefixKey)
        runFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.competitor3RunAtlas), withName: GameConstants.StringConstants.competitor3RunPrefixKey)
    }
    
    func animate(for state: Competitor1State) {
        
//        guard !idleFrames.isEmpty && !runFrames.isEmpty else {
//            print("Warning: Attempting to animate with empty texture arrays")
//            return
//        }
//        
        
        print("Loading textures from: \(GameConstants.StringConstants.competitor1RunAtlas)")
        print("Using prefix: \(GameConstants.StringConstants.competitor1RunPrefixKey)")

        
        print("Idle Frames: \(idleFrames)")
        print("Run Frames: \(runFrames)")
        
        removeAllActions()
        switch state {
        case .idle:
            self.run(SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.05, resize: true, restore: true)))
        case .running:
            self.run(SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.05, resize: true, restore: true)))
        }
    }
}

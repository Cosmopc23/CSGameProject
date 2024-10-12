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
    
    var competitor1CurrentSpeed: CGFloat = 0

    var state = Competitor1State.idle {
        willSet {
            animate(for: newValue)
        }
    }
    

    func loadTextures() {
        idleFrames = AnimationHelper.loadTextures(
            from: SKTextureAtlas(named: GameConstants.StringConstants.competitor1IdleAtlas),
            withName: GameConstants.StringConstants.competitor1IdlePrefixKey
        )
        runFrames = AnimationHelper.loadTextures(
            from: SKTextureAtlas(named: GameConstants.StringConstants.competitor1RunAtlas),
            withName: GameConstants.StringConstants.competitor1RunPrefixKey
        )
    }
    

    func animate(for state: Competitor1State) {
        removeAllActions()
        switch state {
        case .idle:
            self.run(SKAction.repeatForever(
                SKAction.animate(with: idleFrames, timePerFrame: 0.05, resize: true, restore: true)
            ))
        case .running:
            self.run(SKAction.repeatForever(
                SKAction.animate(with: runFrames, timePerFrame: 0.05, resize: true, restore: true)
            ))
        }
    }

}



enum Competitor2State {
    case idle, running
}

class Competitor2: SKSpriteNode {
    var idleFrames = [SKTexture]()
    var runFrames = [SKTexture]()
    
    var competitor2Speed: CGFloat = 75.0
    
    var state = Competitor2State.idle {
        willSet {
            animate(for: newValue)
        }
    }
    
    func loadTextures() {
        idleFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.competitor2IdleAtlas), withName: GameConstants.StringConstants.competitor2IdlePrefixKey)
        runFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.competitor2RunAtlas), withName: GameConstants.StringConstants.competitor2RunPrefixKey)
    }
    
    func animate(for state: Competitor2State) {
        
        removeAllActions()
        switch state {
        case .idle:
            self.run(SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.05, resize: true, restore: true)))
        case .running:
            self.run(SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.05, resize: true, restore: true)))
        }
    }
}

enum Competitor3State {
    case idle, running
}

class Competitor3: SKSpriteNode {
    var idleFrames = [SKTexture]()
    var runFrames = [SKTexture]()
    
    var competitor3Speed: CGFloat = 70.0
    
    var state = Competitor3State.idle {
        willSet {
            animate(for: newValue)
        }
    }
    
    func loadTextures() {
        idleFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.competitor3IdleAtlas), withName: GameConstants.StringConstants.competitor3IdlePrefixKey)
        runFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.competitor3RunAtlas), withName: GameConstants.StringConstants.competitor3RunPrefixKey)
    }
    
    func animate(for state: Competitor3State) {
        
        removeAllActions()
        switch state {
        case .idle:
            self.run(SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.05, resize: true, restore: true)))
        case .running:
            self.run(SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.05, resize: true, restore: true)))
        }
    }
}

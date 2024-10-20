//
//  JavelinScene.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 16/10/2024.
//

import Foundation
import SpriteKit

enum JavelinGameState {
    case ready, ongoing, throwing, thrown
}

class JavelinScene: SKScene, SKPhysicsContactDelegate {
    var worldLayer: Layer!
    var backgroundLayer: RepeatingLayer!
    var mapNode: SKNode!
    var tileMap: SKTileMapNode!
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var player: Player!
    
    let javelinSprite = SKSpriteNode(imageNamed: "Javelin")
    
    var tileSize = CGFloat(10)
    
    var xHandPosition: Double = 0.0
    var yHandPosition: Double = 0.0
    
    var currentHandFrameIndex = 0

    
    
    var gameState = JavelinGameState.ready {
        willSet{
            switch newValue {
            case.ready:
                player.state = .throwIdle
            case .ongoing:
                player.state = .throwRunning
            case .throwing:
                player.state = .throwIdle // need to change to throw action
            case .thrown:
                player.state = .idle
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -4)
        
        physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY), to: CGPoint(x: frame.maxX, y: frame.minY))
        physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.frameCategory
        physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.playerCategory
        
        createLayers()
    }
    
    func createLayers() {
        worldLayer = Layer()
        worldLayer.zPosition = GameConstants.zPositions.worldZ
        
        addChild(worldLayer)
        
        backgroundLayer = RepeatingLayer()
        backgroundLayer.zPosition = GameConstants.zPositions.backgroundZ
        
        addChild(backgroundLayer)
        
        for i in 0...1 {
            let backgroundImage = SKSpriteNode(imageNamed: GameConstants.StringConstants.worldBackgroundName)
            backgroundImage.name = String(i)
            backgroundImage.scale(to: frame.size, width: false, multiplier: 1.0)
            backgroundImage.anchorPoint = CGPoint.zero
            backgroundImage.position = CGPoint(x: 0.0 + CGFloat(i) * backgroundImage.size.width, y: 0.0)
            backgroundLayer.addChild(backgroundImage)
        }
        
        load(level: "Javelin")
    }
    
    func load(level: String) {
        if let levelNode = SKNode.unarchiveFromFile(file: level) {
            mapNode = levelNode
            worldLayer.addChild(mapNode)
            loadTileMap()
        }
    }
    func loadTileMap() {
        if let groundTiles = mapNode.childNode(withName: GameConstants.StringConstants.groundTilesName) as? SKTileMapNode {
            tileMap = groundTiles
            
            
            tileMap.scale(to: frame.size, width: false, multiplier: 1.0)
            
            PhysicsHelper.addPhysicsBody(to: tileMap, and: "ground")
            for child in groundTiles.children {
                if let sprite = child as? SKSpriteNode, sprite.name != nil {
                    ObjectHelper.handleChild(sprite: sprite, with: sprite.name!)
                }
            }
        }
        
        addPlayer()
        

        yHandPosition = frame.minY + tileSize + player.size.height * 254/1023
        xHandPosition = frame.midX/2.0
        
        addJavelin()
    }
    
    func addPlayer() {
        player = Player(imageNamed: GameConstants.StringConstants.playerImageName)
        player.scale(to: frame.size, width: false, multiplier: 0.4)
        player.name = GameConstants.StringConstants.playerName
        PhysicsHelper.addPhysicsBody(to: player, with: player.name!)
        player.position = CGPoint(x: frame.midX/2.0, y: frame.midY)
        player.zPosition = GameConstants.zPositions.playerZ
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        player.loadTextures()
        player.state = .throwIdle
        
        addChild(player)
    }
    
    func addJavelin() {
        PhysicsHelper.addPhysicsBody(to: javelinSprite, with: GameConstants.StringConstants.javelinName)
        javelinSprite.scale(to: frame.size, width: false, multiplier: 0.165)
        javelinSprite.position = CGPoint(x: xHandPosition, y: yHandPosition)
        javelinSprite.zPosition = GameConstants.zPositions.objectZ
        javelinSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        javelinSprite.zRotation = -0.1
        
        addChild(javelinSprite)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .ready:
            gameState = .ongoing
        default:
            break
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if lastTime > 0 {
            dt = currentTime - lastTime
        } else {
            dt = 0
        }
        
        
        if gameState == .ongoing {
            worldLayer.update(dt)
            backgroundLayer.update(dt)
            backgroundLayer.layerVelocity = CGPoint(x: -75.0, y: 0.0)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask == GameConstants.PhysicsCategories.javelinCategory) && (bodyB.categoryBitMask == GameConstants.PhysicsCategories.groundCategory) || (bodyA.categoryBitMask == GameConstants.PhysicsCategories.groundCategory) &&  (bodyB.categoryBitMask == GameConstants.PhysicsCategories.javelinCategory) {
            javelinSprite.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            javelinSprite.physicsBody!.allowsRotation = false
            javelinSprite.physicsBody!.angularVelocity = 0
        }
    }
}

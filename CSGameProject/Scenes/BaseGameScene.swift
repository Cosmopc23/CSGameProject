//
//  BaseGameScene.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 10/11/2024.
//

import SpriteKit
import Foundation

class BaseGameScene: SKScene, SKPhysicsContactDelegate {
    var worldLayer: Layer!
    var backgroundLayer: RepeatingLayer!
    var mapNode: SKNode!
    var tileMap: SKTileMapNode!
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var playerFinishPosition: Int = 0
    var rewards: [Double] = [40.0, 30.0, 20.0, 10.0]
    
    var characterSpeed: CGFloat = 0.0 {
        didSet {
            updateLayerVelocities()
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
    
    func sortResults(string: String, sortedResults: [(String, Double)]){
        var yOffSet: CGFloat = 100
        var i = 4
        
        for (character, distance) in sortedResults {
            let resultLabel = SKLabelNode(text: "\(i). \(character.capitalized): \(String(format: "%.2f", distance)) \(string) \(rewards[(i-1)])")
            resultLabel.fontSize = 24
            resultLabel.fontColor = .white
            resultLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 150 - yOffSet)
            resultLabel.zPosition = GameConstants.zPositions.topZ
            self.addChild(resultLabel)
            i -= 1
            
            if character == "Player" {
                playerFinishPosition = i
                MenuScene.reward(amount: rewards[playerFinishPosition])
            }
            
            yOffSet -= 30
        }
    }
    
    func createLayers() {
        worldLayer = Layer()
        worldLayer.zPosition = GameConstants.zPositions.worldZ
        
        addChild(worldLayer)
        worldLayer.layerVelocity = CGPoint(x: -200.0, y: 0.0)
        
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
        
        backgroundLayer.layerVelocity = CGPoint(x: -75.0, y: 0.0)
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
    }
    
    func updateLayerVelocities() {
        let worldLayerSpeedFactor: CGFloat = 10.0
        let backgroundLayerSpeedFactor: CGFloat = 5
        
        worldLayer.layerVelocity = CGPoint(x: -characterSpeed * worldLayerSpeedFactor, y: 0.0)
        backgroundLayer.layerVelocity = CGPoint(x: -characterSpeed * backgroundLayerSpeedFactor, y: 0.0)
    }
    
    func printSceneGraph(for node: SKNode, level: Int = 0) {
        let indent = String(repeating: "  ", count: level)
        let nodeName = node.name ?? "unnamed"
        print("\(indent)\(nodeName) (Position: \(node.position), zPosition: \(node.zPosition))")
        for child in node.children {
            printSceneGraph(for: child, level: level + 1)
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
            // Base implementation - can be overridden by subclasses
        }
}

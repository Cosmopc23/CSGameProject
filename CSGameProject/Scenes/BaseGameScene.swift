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
    
    // Tracking time between frames for game physics
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    // Player's final position in the race (0-based index)
    var playerFinishPosition: Int = 0
    var rewards: [Double] = [20.0, 15.0, 10.0, 5.0]
    var reputationIncrease: [Double] = [40.0, 20.0, 10.0, -5.0]
    
    // Character movement speed - triggers velocity updates when changed
    var characterSpeed: CGFloat = 0.0 {
        didSet {
            updateLayerVelocities()
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -4)
        
        // Create physics boundary at the bottom of the screen
        physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY), to: CGPoint(x: frame.maxX, y: frame.minY))
        physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.frameCategory
        physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.playerCategory
        
        createLayers()
    }
    
    // Display race results and calculate rewards
    func sortResults(string: String, sortedResults: [(String, Double)], difficulty: Difficulty){
        var yOffSet: CGFloat = 100
        var i = 4
        let difficultyMultiplier = setDifficultyMultiplier(difficulty: difficulty)
        
        
        for (character, distance) in sortedResults {
            
            var displayedReward = 0.0
            
            displayedReward = rewards[(i-1)] * difficultyMultiplier
            
            
            if character == "Player" {
                playerFinishPosition = i - 1
                
                let playerReward = ((rewards[playerFinishPosition]) * difficultyMultiplier)
                
                
                
                MenuScene.reward(amount: playerReward * getCurrentRewardMultiplier())
                MenuScene.increaseReputationBar(reputationIncrease[playerFinishPosition] * difficultyMultiplier)
                
                displayedReward = playerReward
                
            }
            
            let resultLabel = SKLabelNode(text: "\(i). \(character.capitalized): \(String(format: "%.2f", distance)) \(string) \(displayedReward)")
            resultLabel.fontSize = 24
            resultLabel.fontColor = .white
            resultLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 150 - yOffSet)
            resultLabel.zPosition = GameConstants.zPositions.topZ
            self.addChild(resultLabel)
            i -= 1
                                 
            
            yOffSet -= 30
        }
    }
    
    // Returns a multiplier for rewards based on the selected difficulty level
    func setDifficultyMultiplier(difficulty: Difficulty) -> Double {
        switch difficulty {
        case .beginner:
            return 1.0
        case .amateur:
            return 2.0
        case .intermediate:
            return 3.0
        case .professional:
            return 4.0
        case .elite:
            return 5.0
        }
    }
    
    // Gets the current sponsor multiplier for additional reward calculations
    func getCurrentRewardMultiplier() -> Double {
        return MenuScene.getCurrentSponsorMultiplier()
    }
    
    // Initialize the world and background layers
    func createLayers() {
        // Set up main game world layer
        worldLayer = Layer()
        worldLayer.zPosition = GameConstants.zPositions.worldZ
        
        addChild(worldLayer)
        worldLayer.layerVelocity = CGPoint(x: -200.0, y: 0.0)
        
        // Set up repeating background layer for parallax effect
        backgroundLayer = RepeatingLayer()
        backgroundLayer.zPosition = GameConstants.zPositions.backgroundZ
        addChild(backgroundLayer)
        
        // Create two background images side by side for seamless scrolling
        for i in 0...1 {
            let backgroundImage = SKSpriteNode(imageNamed: GameConstants.StringConstants.worldBackgroundName)
            backgroundImage.name = String(i)
            backgroundImage.scale(to: frame.size, width: false, multiplier: 1.0)
            backgroundImage.anchorPoint = CGPoint.zero
            backgroundImage.position = CGPoint(x: 0.0 + CGFloat(i) * backgroundImage.size.width, y: 0.0)
            backgroundLayer.addChild(backgroundImage)
        }
        
        // Set background layer to move slower than world layer for parallax effect
        backgroundLayer.layerVelocity = CGPoint(x: -75.0, y: 0.0)
    }
    
    // Loads a level from an archived file
    func load(level: String) {
        if let levelNode = SKNode.unarchiveFromFile(file: level) {
            mapNode = levelNode
            worldLayer.addChild(mapNode)
            loadTileMap()
        }
    }
    
    // Sets up the tile map and adds physics to ground tiles
    func loadTileMap() {
        if let groundTiles = mapNode.childNode(withName: GameConstants.StringConstants.groundTilesName) as? SKTileMapNode {
            tileMap = groundTiles
            
            tileMap.scale(to: frame.size, width: false, multiplier: 1.0)
            
            // Add physics bodies to ground tiles
            PhysicsHelper.addPhysicsBody(to: tileMap, and: "ground")
            for child in groundTiles.children {
                if let sprite = child as? SKSpriteNode, sprite.name != nil {
                    // Process special objects in the tile map
                    ObjectHelper.handleChild(sprite: sprite, with: sprite.name!)
                }
            }
        }
    }
    
    // Updates layer movement speeds based on character speed
    func updateLayerVelocities() {
        let worldLayerSpeedFactor: CGFloat = 10.0
        let backgroundLayerSpeedFactor: CGFloat = 5
        
        // World moves faster than background for parallax effect
        worldLayer.layerVelocity = CGPoint(x: -characterSpeed * worldLayerSpeedFactor, y: 0.0)
        backgroundLayer.layerVelocity = CGPoint(x: -characterSpeed * backgroundLayerSpeedFactor, y: 0.0)
    }
    
    // Debugging function to print the scene hierarchy
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

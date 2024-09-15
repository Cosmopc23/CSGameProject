//
//  GameScene.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 07/09/2024.
//

import SpriteKit



enum GameState {
    case ready, ongoing, finished
}

class GameScene: SKScene {
    
    var worldLayer: Layer!
    var mapNode: SKNode!
    var tileMap: SKTileMapNode!
    
    override func didMove(to view: SKView) {
        load(level: "100m")

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
    
    var player: Player!
    
    
    // Adds player object by adding an idle image, scaling the size relative to the frame, adding a physics body, putting its initial position, loading the textures and setting the player state to idle so that the animation does not show the character running when it is not moving.
    func addPlayer() {
        player = Player(imageNamed: GameConstants.StringConstants.playerImageName)
        player.scale(to: frame.size, width: false, multiplier: 0.1)
        player.name = GameConstants.StringConstants.playerName
        PhysicsHelper.addPhysicsBody(to: player, with: player.name!)
        player.position = CGPoint(x: frame.midX/2.0, y: frame.midY)
        
        player.loadTextures()
        player.state = .idle
    
    }
}

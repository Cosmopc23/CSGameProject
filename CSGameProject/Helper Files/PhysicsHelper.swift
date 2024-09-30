//
//  PhysicsHelper.swift
//  CSGameProject
//
//  Created by Page-Croft, Cosmo (HWTA) on 12/09/2024.
//

import SpriteKit




class PhysicsHelper {
    
    static func addPhysicsBody(to sprite: SKSpriteNode, with name: String) {
        
        let offsetX: CGFloat = 0
        let offsetY: CGFloat = -(sprite.size.height / 5)
        
        switch name {
        case GameConstants.StringConstants.playerName:
            sprite.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:sprite.size.width/4, height: sprite.size.height/3), center: CGPoint(x: offsetX, y: offsetY))
            sprite.physicsBody!.restitution = 0.0
            sprite.physicsBody!.allowsRotation = false
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.playerCategory
            sprite.physicsBody!.collisionBitMask = GameConstants.PhysicsCategories.groundCategory | GameConstants.PhysicsCategories.finishCategory
            sprite.physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.allCategory
        default:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        }
    }
    static func addPhysicsBody(to tileMap: SKTileMapNode, and tileInfo: String) {
        let tileSize = tileMap.tileSize
        
        for row in 0..<tileMap.numberOfRows {
            var tiles = [Int]()
            for col in 0..<tileMap.numberOfColumns {
                let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row)
                let isUsedTile = tileDefinition?.userData?[tileInfo] as? Bool
                if (isUsedTile ?? false) {
                    tiles.append(1)
                } else {
                    tiles.append(0)
                }
            }
            if tiles.contains(1) {
                let x = CGFloat(0)
                let y = CGFloat(row) * tileSize.height + (tileSize.height/2)
                
                let totalGroundWidth = CGFloat(tileMap.numberOfColumns) * tileSize.width + 10000
                
                let tileNode = GroundNode(with: CGSize(width: totalGroundWidth, height: tileSize.height))
                tileNode.position = CGPoint(x: x, y: y)
                tileNode.anchorPoint = CGPoint.zero
                tileMap.addChild(tileNode)
                                          
                                          
//                var platform = [Int]()
//                
//                for (index, tile) in tiles.enumerated() {
//                    if tile == 1 {
//                        platform.append(index)
//                    } else if !platform.isEmpty {
//                        let x = CGFloat(platform[0]) * tileSize.width
//                        let y = CGFloat(row) * tileSize.height + (tileSize.height / 2)
//                        let tileNode = GroundNode(with: CGSize(width: tileSize.width * CGFloat(platform.count), height: tileSize.height))
//                        
//                        tileNode.position = CGPoint(x: x, y: y)
//                        tileNode.anchorPoint = CGPoint.zero
//                        tileMap.addChild(tileNode)
//                        
//                        platform.removeAll()
//                    }
//                }

            }
        }
    }
}

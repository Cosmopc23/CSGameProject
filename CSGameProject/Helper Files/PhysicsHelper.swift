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
            
        case GameConstants.StringConstants.competitor1Name:
            sprite.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:sprite.size.width/4, height: sprite.size.height/3), center: CGPoint(x: offsetX, y: offsetY))
            sprite.physicsBody!.restitution = 0.0
            sprite.physicsBody!.allowsRotation = false
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.competitor1Category
            sprite.physicsBody!.collisionBitMask = GameConstants.PhysicsCategories.groundCategory | GameConstants.PhysicsCategories.finishCategory
            sprite.physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.allCategory
            
        case GameConstants.StringConstants.competitor2Name:
            sprite.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:sprite.size.width/4, height: sprite.size.height/3), center: CGPoint(x: offsetX, y: offsetY))
            sprite.physicsBody!.restitution = 0.0
            sprite.physicsBody!.allowsRotation = false
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.competitor2Category
            sprite.physicsBody!.collisionBitMask = GameConstants.PhysicsCategories.groundCategory | GameConstants.PhysicsCategories.finishCategory
            sprite.physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.allCategory
            
        case GameConstants.StringConstants.competitor3Name:
            sprite.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width:sprite.size.width/4, height: sprite.size.height/3), center: CGPoint(x: offsetX, y: offsetY))
            sprite.physicsBody!.restitution = 0.0
            sprite.physicsBody!.allowsRotation = false
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.competitor3Category
            sprite.physicsBody!.collisionBitMask = GameConstants.PhysicsCategories.groundCategory | GameConstants.PhysicsCategories.finishCategory
            sprite.physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.allCategory
            
            
        case GameConstants.StringConstants.finishLineName:
            sprite.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize( width: sprite.size.width, height: sprite.size.height), center: CGPoint(x: 0.5, y: 0.5))
            sprite.physicsBody!.affectedByGravity = false
            sprite.physicsBody!.isDynamic = false
            sprite.physicsBody!.allowsRotation = false
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.finishCategory
            sprite.physicsBody!.collisionBitMask = GameConstants.PhysicsCategories.playerCategory
            sprite.physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.playerCategory
        
        case GameConstants.StringConstants.javelinName:
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            
            sprite.isHidden = true
            sprite.physicsBody!.affectedByGravity = false
            sprite.physicsBody!.isDynamic = true
            sprite.physicsBody!.allowsRotation = true
            sprite.physicsBody!.restitution = 0
            sprite.physicsBody!.friction = 1.0

            
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.javelinCategory
            sprite.physicsBody!.collisionBitMask = GameConstants.PhysicsCategories.groundCategory
            sprite.physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.groundCategory
            
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
                
                let totalGroundWidth = CGFloat(tileMap.numberOfColumns) * tileSize.width + 1000000000
                
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

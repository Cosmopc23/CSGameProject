//
//  GroundNode.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 17/09/2024.
//

import SpriteKit

class GroundNode: SKSpriteNode {
    

    
    init(with size: CGSize) {
        super.init(texture: nil, color: UIColor.clear, size: size)
        


        self.physicsBody = SKPhysicsBody(rectangleOf: size) // This should replace activatedBody!
        self.physicsBody?.isDynamic = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.groundCategory
        self.physicsBody?.collisionBitMask = GameConstants.PhysicsCategories.playerCategory
        

        
        
        name = GameConstants.StringConstants.groundNodeName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

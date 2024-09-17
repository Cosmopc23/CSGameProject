//
//  ObjectHelper.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 17/09/2024.
//

import SpriteKit

class ObjectHelper {
    
    static func handleChild(sprite: SKSpriteNode, with name: String) {
        switch name {
        case GameConstants.StringConstants.finishLineName:
            PhysicsHelper.addPhysicsBody(to: sprite, with: name)
            
        default:
            break
        }
    }
}

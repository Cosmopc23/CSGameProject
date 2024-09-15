//
//  Object Helper.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 15/09/2024.
//

import SpriteKit

static func handleChild(sprite: SKSpriteNode, with name: String) {
    switch name {
    case GameConstants.StringConstants.finishLineName:
        PhysicsHelper.addPhysicsBody(to: sprite, with: name)
    }
}



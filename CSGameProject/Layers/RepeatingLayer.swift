//
//  RepeatingLayer.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 18/09/2024.
//

import SpriteKit

// Layer that repeats its content for infinite scrolling effect
class RepeatingLayer: Layer {
    
    // Override updateNodes to handle repositioning sprites when they move offscreen
    override func updateNodes(_ delta: TimeInterval, childNode: SKNode) {
        if let node = childNode as? SKSpriteNode {
            if node.position.x <= -(node.size.width) {
                if node.name == "0" && self.childNode(withName: "1") != nil || node.name == "1" && self.childNode(withName: "0") != nil {
                    node.position = CGPoint(x: node.position.x + node.size.width*2, y: node.position.y)
                }
            }
        }
    }
}

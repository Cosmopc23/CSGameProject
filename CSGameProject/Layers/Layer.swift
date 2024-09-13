//
//  Layer.swift
//  CSGameProject
//
//  Created by Page-Croft, Cosmo (HWTA) on 13/09/2024.
//

import SpriteKit

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

class Layer: SKNode {
    var layerVelocity = CGPoint.zero
    
    func update(_ delta: TimeInterval) {
        for child in children {
            updateNodesGlobal(delta, childNode: child)
        }
    }
    
    func updateNodesGlobal(_ delta: TimeInterval, childNode: SKNode) {
        let offset = layerVelocity * CGFloat(delta)
        childNode.position += offset
        updateNodes(delta, childNode: childNode)
    }
    
    func updateNodes(_ delta: TimeInterval, childNode: SKNode) {
        
    }
}

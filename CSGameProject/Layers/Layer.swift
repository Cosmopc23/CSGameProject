//
//  Layer.swift
//  CSGameProject
//
//  Created by Page-Croft, Cosmo (HWTA) on 13/09/2024.
//


import SpriteKit

// Vector addition operator
public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

// Vector compound addition operator
public func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

// Vector scalar multiplication operator
public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

// Base layer class for managing node movement
class Layer: SKNode {
    var layerVelocity = CGPoint.zero
    
    // Update all child nodes
    func update(_ delta: TimeInterval) {
        for child in children {
            updateNodesGlobal(delta, childNode: child)
        }
    }
    
    // Apply movement to nodes based on velocity
    func updateNodesGlobal(_ delta: TimeInterval, childNode: SKNode) {
        let offset = layerVelocity * CGFloat(delta)
        childNode.position += offset
        updateNodes(delta, childNode: childNode)
    }
    
    // Custom behavior for subclasses
    func updateNodes(_ delta: TimeInterval, childNode: SKNode) {
        
    }
}

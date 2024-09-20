//
//  GameConstants.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 11/09/2024.
//

import Foundation
import CoreGraphics

struct GameConstants {
    struct StringConstants {
        static let groundTilesName = "Ground Tiles"
        static let playerName = "Player"
        static let finishLineName = "Finish Line"
        
        static let worldBackgroundName = "BackgroundDouble"
        static let playerImageName = "idle_0"
        static let groundNodeName = "GroundNode"
        static let playerIdleAtlas = "Player Idle Atlas"
        static let idlePrefixKey = "idle_"
    }
    
    struct PhysicsCategories {
        static let noCategory: UInt32 = 0
        static let allCategory: UInt32 = UInt32.max
        static let playerCategory: UInt32 = 0x1
        static let groundCategory: UInt32 = 0x1 << 1
        static let frameCategory: UInt32 = 0x1 << 2
        static let ceilingCategory: UInt32 = 0x1 << 3
        static let finishCategory: UInt32 = 0x1 << 4
    }

    struct zPositions {
        static let backgroundZ: CGFloat = 0
        static let worldZ: CGFloat = 1
        static let objectZ: CGFloat = 2
        static let playerZ: CGFloat = 3
        static let hudZ: CGFloat = 4
    }
}


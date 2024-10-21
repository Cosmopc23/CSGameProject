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
        
        static let competitor1Name = "JamesBot"
        static let competitor2Name = "BellaBot"
        static let competitor3Name = "PeterBot"
        
        
        static let hundredLinker = "Hundred Link"
        static let javelinLinker = "Javelin Link"
        
        
        static let worldBackgroundName = "BackgroundDouble"
        static let playerImageName = "idle_0"
        static let groundNodeName = "GroundNode"
        
        static let playerIdleAtlas = "Player Idle Atlas"
        static let idlePrefixKey = "idle_"
        
        static let playerRunAtlas = "Player Running Atlas"
        static let runPrefixKey = "run_"
        
        static let competitor1ImageName = "1idle_0"
        static let competitor1IdleAtlas = "Competitor1 Idle Atlas"
        static let competitor1IdlePrefixKey = "1idle_"
        
        static let competitor1RunAtlas = "Competitor1 Running Atlas"
        static let competitor1RunPrefixKey = "1run_"
        
        static let competitor2ImageName = "2idle_0"
        static let competitor2IdleAtlas = "Competitor2 Idle Atlas"
        static let competitor2IdlePrefixKey = "2idle_"
        
        static let competitor2RunAtlas = "Competitor2 Running Atlas"
        static let competitor2RunPrefixKey = "2run_"
        
        static let competitor3ImageName = "3idle_0"
        static let competitor3IdleAtlas = "Competitor3 Idle Atlas"
        static let competitor3IdlePrefixKey = "3idle_"
        
        static let competitor3RunAtlas = "Competitor3 Running Atlas"
        static let competitor3RunPrefixKey = "3run_"
        
        static let speedKey = "playerSpeed"
        static let strengthKey = "playerStrength"
        static let skillKey = "playerSkill"
        
        static let throwingIdleAtlas = "Player Throwing Idle Atlas"
        static let throwingRunningAtlas = "Player Throwing Running Atlas"
        static let playerThrowingImageName = "throwingIdle_0"
        static let throwingIdlePrefixKey = "throwingIdle_"
        static let throwingRunningPrefixKey = "throwingRunning_"
        
        static let javelinName = "Javelin"
    }
    
    struct PhysicsCategories {
        static let noCategory: UInt32 = 0
        static let allCategory: UInt32 = UInt32.max
        static let playerCategory: UInt32 = 0x1
        static let groundCategory: UInt32 = 0x1 << 1
        static let frameCategory: UInt32 = 0x1 << 2
        static let ceilingCategory: UInt32 = 0x1 << 3
        static let finishCategory: UInt32 = 0x1 << 4
        static let competitor1Category: UInt32 = 0x1 << 5
        static let competitor2Category: UInt32 = 0x1 << 6
        static let competitor3Category: UInt32 = 0x1 << 7
        static let javelinCategory: UInt32 = 0x1 << 8
    }

    struct zPositions {
        static let backgroundZ: CGFloat = 0
        static let worldZ: CGFloat = 1
        static let competitor3Z: CGFloat = 2
        static let competitor2Z: CGFloat = 3
        static let competitor1Z: CGFloat = 4
        static let playerZ: CGFloat = 5
        static let objectZ: CGFloat = 6
        static let hudZ: CGFloat = 7
        static let finishScreenZ: CGFloat = 8
        static let topZ: CGFloat = 9
    }
    
    struct Keys {
        static let bankBalanceKey = "bankBalance"
        static let speedKey = "speed"
        static let strengthKey = "strength"
        static let skillKey = "skill"
        static let coachKey = "coach"
    }
}


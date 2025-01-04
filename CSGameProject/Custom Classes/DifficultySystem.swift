//
//  DifficultySystem.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 04/01/2025.
//

import Foundation
import SpriteKit

enum EventType {
    case hundred
    case javelin
}

struct HundredParams {
    let topSpeedRange: ClosedRange<CGFloat>
    let accelerationRange: ClosedRange<CGFloat>
}

struct JavelinParams {
    let distanceRange: ClosedRange<Double>
}

enum RaceDifficulty: Int {
    case beginner = 1
    case amateur = 2
    case intermediate = 3
    case professional = 4
    case elite = 5
    
    func parameters(for eventType: EventType) -> Any {
        switch eventType {
        case .hundred:
            return hundredParameters
        case .javelin:
            return javelinParameters
        }
    }
    
    private var hundredParameters: HundredParams {
        switch self {
        case .elite:
            return HundredParams(
                topSpeedRange: 95...98,
                accelerationRange: 9...10
            )
            
        case .professional:
            return HundredParams(
                topSpeedRange: 85...90,
                accelerationRange: 8...9
            )
            
        case .intermediate:
            return HundredParams(
                topSpeedRange: 75...80,
                accelerationRange: 7...8
            )
            
        case .amateur:
            return HundredParams(
                topSpeedRange: 65...70,
                accelerationRange: 6...7
            )
            
        case .beginner:
            return HundredParams(
                topSpeedRange: 55...60,
                accelerationRange: 5...6
            )
        }
        
    }
    
    private var javelinParameters: JavelinParams {
        switch self {
        case .elite:
            return JavelinParams(distanceRange: 85...90)
        case .professional:
            return JavelinParams(distanceRange: 75...80)
        case .intermediate:
            return JavelinParams(distanceRange: 65...70)
        case .amateur:
            return JavelinParams(distanceRange: 55...60)
        case .beginner:
            return JavelinParams(distanceRange: 45...50)
        }
    }
}


class DifficultyManager {
    static func configureCompetitors(_ scene: HundredScene, for difficulty: RaceDifficulty) {
        guard let params = difficulty.parameters(for: .hundred) as? HundredParams else { return }
        
        scene.competitor1.competitor1TopSpeed = CGFloat.random(in: params.topSpeedRange)
        scene.competitor1.competitor1Acceleration = CGFloat.random(in: params.accelerationRange)
        
        scene.competitor2.competitor2TopSpeed = CGFloat.random(in: params.topSpeedRange)
        scene.competitor2.competitor2Acceleration = CGFloat.random(in: params.accelerationRange)
        
        scene.competitor3.competitor3TopSpeed = CGFloat.random(in: params.topSpeedRange)
        scene.competitor3.competitor3Acceleration = CGFloat.random(in: params.accelerationRange)
    }
    
    static func generateCompetitorThrow(_ scene: JavelinScene, for difficulty: RaceDifficulty) -> Double {
        guard let params = difficulty.parameters(for: .javelin) as? JavelinParams else { return 0 }
        return Double.random(in: params.distanceRange).rounded(to: 2)
    }
}

extension Double {
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//
//  Sponsors.swift
//  CSGameProject
//
//  Created by Page-Croft, Cosmo (HWTA) on 22/11/2024.
//

struct Sponsor {
    let name: String
    let reputationRequirement: Double
    let lengthOfContract: Int
    let rewardMultiplier: Double
}

let sponsors = [
    // Tier 1: Newcomer Sponsors (Reputation 0–10)
    Sponsor(name: "FirstStep Shoes", reputationRequirement: 0, lengthOfContract: 2, rewardMultiplier: 1),
    Sponsor(name: "Speedup", reputationRequirement: 3, lengthOfContract: 3, rewardMultiplier: 1.1),
    Sponsor(name: "Sportify Gear", reputationRequirement: 8, lengthOfContract: 4, rewardMultiplier: 1.3),
    Sponsor(name: "Cheetah Tracks", reputationRequirement: 10, lengthOfContract: 5, rewardMultiplier: 1.4),
    Sponsor(name: "UnderWorld Armour", reputationRequirement: 10, lengthOfContract: 4, rewardMultiplier: 1.4),
    Sponsor(name: "SweatShop", reputationRequirement: 6, lengthOfContract: 3, rewardMultiplier: 1.25),
    Sponsor(name: "FlexTape Apparel", reputationRequirement: 5, lengthOfContract: 3, rewardMultiplier: 1.2),
    Sponsor(name: "SunnyShoes", reputationRequirement: 7, lengthOfContract: 4, rewardMultiplier: 1.3),
    Sponsor(name: "JumpStart", reputationRequirement: 9, lengthOfContract: 3, rewardMultiplier: 1.35),
    Sponsor(name: "GatorPower", reputationRequirement: 10, lengthOfContract: 3, rewardMultiplier: 1.4),

    // Tier 2: Mid-Tier Sponsors (Reputation 11–25)
    Sponsor(name: "Pike", reputationRequirement: 15, lengthOfContract: 5, rewardMultiplier: 1.6),
    Sponsor(name: "Reeboks", reputationRequirement: 20, lengthOfContract: 6, rewardMultiplier: 1.8),
    Sponsor(name: "Adidasleek", reputationRequirement: 25, lengthOfContract: 7, rewardMultiplier: 2.0),
    Sponsor(name: "FitBitStep", reputationRequirement: 18, lengthOfContract: 5, rewardMultiplier: 1.7),
    Sponsor(name: "SnapCouch", reputationRequirement: 22, lengthOfContract: 6, rewardMultiplier: 1.85),
    Sponsor(name: "PowerTracks", reputationRequirement: 20, lengthOfContract: 5, rewardMultiplier: 1.75),
    Sponsor(name: "Dunkin’ Trainers", reputationRequirement: 23, lengthOfContract: 7, rewardMultiplier: 1.9),
    Sponsor(name: "TrailBlaze", reputationRequirement: 24, lengthOfContract: 6, rewardMultiplier: 1.85),
    Sponsor(name: "ActiveFit", reputationRequirement: 17, lengthOfContract: 5, rewardMultiplier: 1.65),
    Sponsor(name: "CoolRunnings", reputationRequirement: 19, lengthOfContract: 5, rewardMultiplier: 1.7),

    // Tier 3: High-Tier Sponsors (Reputation 26–40)
    Sponsor(name: "Coke-a-Fun", reputationRequirement: 35, lengthOfContract: 9, rewardMultiplier: 2.5),
    Sponsor(name: "Burger Kingpin", reputationRequirement: 30, lengthOfContract: 8, rewardMultiplier: 2.4),
    Sponsor(name: "Peppy Cola", reputationRequirement: 28, lengthOfContract: 7, rewardMultiplier: 2.3),
    Sponsor(name: "MacDollars", reputationRequirement: 40, lengthOfContract: 10, rewardMultiplier: 3.0),
    Sponsor(name: "Gucci Goals", reputationRequirement: 50, lengthOfContract: 10, rewardMultiplier: 3.5),
    Sponsor(name: "VersaScore", reputationRequirement: 37, lengthOfContract: 9, rewardMultiplier: 2.7),
    Sponsor(name: "Armain Goals", reputationRequirement: 36, lengthOfContract: 8, rewardMultiplier: 2.6),
    Sponsor(name: "MountainFew", reputationRequirement: 32, lengthOfContract: 7, rewardMultiplier: 2.5),
    Sponsor(name: "LucoSmart", reputationRequirement: 34, lengthOfContract: 8, rewardMultiplier: 2.6),
    Sponsor(name: "Gainsbury’s", reputationRequirement: 33, lengthOfContract: 7, rewardMultiplier: 2.4),

    // Tier 4: Elite Sponsors (Reputation 41+)
    Sponsor(name: "EnergiserX", reputationRequirement: 45, lengthOfContract: 10, rewardMultiplier: 3.7),
    Sponsor(name: "Rolexercise", reputationRequirement: 50, lengthOfContract: 10, rewardMultiplier: 4.0),
    Sponsor(name: "TrophyCo", reputationRequirement: 43, lengthOfContract: 9, rewardMultiplier: 3.8),
    Sponsor(name: "SmoothFinish", reputationRequirement: 41, lengthOfContract: 9, rewardMultiplier: 3.6),
    Sponsor(name: "BeMoreDoMore", reputationRequirement: 48, lengthOfContract: 10, rewardMultiplier: 3.9),
    Sponsor(name: "Zenith Zero", reputationRequirement: 47, lengthOfContract: 9, rewardMultiplier: 3.8),
    Sponsor(name: "LuxeLift", reputationRequirement: 42, lengthOfContract: 8, rewardMultiplier: 3.6),
    Sponsor(name: "KingKicks", reputationRequirement: 44, lengthOfContract: 9, rewardMultiplier: 3.7),
    Sponsor(name: "Crown Cola", reputationRequirement: 46, lengthOfContract: 10, rewardMultiplier: 3.8),
    Sponsor(name: "PureScore", reputationRequirement: 49, lengthOfContract: 10, rewardMultiplier: 4.0)
]

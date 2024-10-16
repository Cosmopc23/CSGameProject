//
//  MenuScene.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 11/10/2024.
//

import SpriteKit
import Foundation

class MenuScene: SKScene {
    
    var speedBar: ProgressBar!
    var strengthBar: ProgressBar!
    var skillBar: ProgressBar!
    
    let xBuffer: CGFloat = 70
    let yBuffer: CGFloat = 30
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        let titleLabel = SKLabelNode(text: "Olympics Game")
        titleLabel.fontSize = 40
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 150)
        addChild(titleLabel)

        
        let startButton = SKLabelNode(text: "Start 100m Race")
        startButton.fontSize = 30
        startButton.fontColor = .blue
        startButton.position = CGPoint(x: frame.midX, y: frame.midY)
        startButton.name = GameConstants.StringConstants.hundredLinker
        addChild(startButton)
        
        
        let javelinButton = SKLabelNode(text: "Javelin")
        javelinButton.fontSize = 30
        javelinButton.fontColor = .gray
        javelinButton.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        javelinButton.name = GameConstants.StringConstants.javelinLinker
        addChild(javelinButton)
        
        let label = SKLabelNode(text: "Balance: \(MenuScene.getBankBalance()) ")
        label.fontSize = 15
        label.fontColor = .black
        label.position = CGPoint(x: frame.minX + xBuffer, y: frame.maxY - yBuffer)

        addChild(label)
        
        speedBar = ProgressBar(labelText: "Speed", key: GameConstants.StringConstants.speedKey)
        speedBar.position = CGPoint(x: (frame.minX + 3*(xBuffer)), y: (frame.minY + (yBuffer)))
        speedBar.bar.anchorPoint = CGPoint(x: 0, y: 0)
        
        strengthBar = ProgressBar(labelText: "Strength", key: GameConstants.StringConstants.strengthKey)
        strengthBar.position = CGPoint(x: (frame.minX + 3*(xBuffer)), y: (frame.minY + 2*(yBuffer)))
        strengthBar.bar.anchorPoint = CGPoint(x: 0, y: 0)
        
        skillBar = ProgressBar(labelText: "Skill", key: GameConstants.StringConstants.skillKey)
        strengthBar.position = CGPoint(x: (frame.minX + 3*(xBuffer)), y: (frame.minY + 3*(yBuffer)))
        skillBar.bar.anchorPoint = CGPoint(x: 0, y: 0)
        
        addChild(speedBar)
        addChild(strengthBar)
        addChild(skillBar)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        print(location)
        let node = self.atPoint(location)
        
        if node.name == GameConstants.StringConstants.hundredLinker {
            
            let transition = SKTransition.fade(withDuration: 1.0)
            let gameScene = HundredScene(size: self.size)
            view?.presentScene(gameScene, transition: transition)
        } else if node.name == GameConstants.StringConstants.javelinLinker {
            let transition = SKTransition.fade(withDuration: 1.0)
            let gameScene = JavelinScene(size: self.size)
            view?.presentScene(gameScene, transition: transition)
        }
    }
    
    static func saveBankBalance(_ balance: Double) {
        UserDefaults.standard.set(balance, forKey: GameConstants.cashKeys.bankBalanceKey)
    }
    
    static func getBankBalance() -> Double {
        return UserDefaults.standard.double(forKey: GameConstants.cashKeys.bankBalanceKey)
    }
    
    static func reward(amount: Double) {
        var currentBalance = getBankBalance()
        currentBalance += amount
        saveBankBalance(currentBalance)
    }
    
    static func transaction(amount: Double) -> Bool {
        var currentBalance = getBankBalance()
        if amount <= currentBalance {
            currentBalance -= amount
            saveBankBalance(currentBalance)
            return true
        } else {
            let alert = UIAlertController(title: "Insufficient Funds", message: "You do not have enough money to make this transaction", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            return false
        }
    }
}

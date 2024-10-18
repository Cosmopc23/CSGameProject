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
    
    let xBuffer: CGFloat = 100
    let yBuffer: CGFloat = 30

    
    
    var speedProgressBar: SKSpriteNode!
    var speedCurrentValue: Double = 10
    var maxValue: Double = 100
    
    var skillProgressBar: SKSpriteNode!
    var skillCurrentValue: Double = 10

    
    var strengthProgressBar: SKSpriteNode!
    var strengthCurrentValue: Double = 10

    
    override func didMove(to view: SKView) {
        
        speedProgressBar = SKSpriteNode(color: .blue, size: CGSize(width: 150, height: 15))
        
        skillProgressBar = SKSpriteNode(color: .blue, size: CGSize(width: 150, height: 15))
        
        strengthProgressBar = SKSpriteNode(color: .blue, size: CGSize(width: 150, height: 15))
        
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
        
        let balanceLabel = SKLabelNode(text: "Balance: \(MenuScene.getBankBalance()) ")
        balanceLabel.fontSize = 15
        balanceLabel.fontColor = .black
        balanceLabel.position = CGPoint(x: frame.minX + xBuffer, y: frame.maxY - yBuffer)

        addChild(balanceLabel)
        
        addLabel(label: "Speed", positionX: (frame.midX/4.0) - 40, positionY: ((frame.midY/3.0) + yBuffer - 5))
        addLabel(label: "Skill", positionX: (frame.midX/4.0) - 40, positionY: (frame.midY/3.0) - 5)
        addLabel(label: "Strength", positionX: (frame.midX/4.0) - 40, positionY: ((frame.midY/3.0) - yBuffer - 5))
        
        speedCurrentValue = getStat(key: GameConstants.cashKeys.speedKey)
        skillCurrentValue = getStat(key: GameConstants.cashKeys.skillKey)
        strengthCurrentValue = getStat(key: GameConstants.cashKeys.skillKey)
        
        
        addProgressBar(progressBar: speedProgressBar, positionX: (frame.midX/4.0), positionY: (frame.midY/3.0) + yBuffer)
        addProgressBar(progressBar: skillProgressBar, positionX: frame.midX/4.0, positionY: (frame.midY/3.0))
        addProgressBar(progressBar: strengthProgressBar, positionX: frame.midX/4.0, positionY: ((frame.midY/3.0) - yBuffer))
        
        updateProgressbar(progressBar: speedProgressBar, currentValue: speedCurrentValue)
        updateProgressbar(progressBar: skillProgressBar, currentValue: skillCurrentValue)
        updateProgressbar(progressBar: strengthProgressBar, currentValue: strengthCurrentValue)
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
    
    func updateProgressbar(progressBar: SKSpriteNode, currentValue: Double) {
        let maxValue: CGFloat = 100
        let progress = CGFloat(currentValue) / maxValue
        let width = progress * 150
        progressBar.size.width = CGFloat(width)
    }
    
    func saveStat(_ currentValue: Double, key: String) {
        UserDefaults.standard.set(currentValue, forKey: key)
    }
    
    func getStat(key: String) -> Double {
        return UserDefaults.standard.double(forKey: key)
    }
    
    func changeStat(amount: Double, key: String) {
        var currentValue = getStat(key: key)
        currentValue += amount
        saveStat(currentValue, key: key)
    }
    
    func addProgressBar(progressBar: SKSpriteNode, positionX: CGFloat, positionY: CGFloat) {
        progressBar.position = CGPoint(x: positionX, y: positionY)
        progressBar.zPosition = GameConstants.zPositions.hudZ
        progressBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        addChild(progressBar)
        
        let borderWidth: CGFloat = 2.0
        let border = SKShapeNode(rectOf: CGSize(width: 150 + borderWidth, height: 15 + borderWidth), cornerRadius: 2.0)
        border.strokeColor = .black
        border.lineWidth = borderWidth
        border.fillColor = .clear
        border.position = CGPoint(x: positionX + progressBar.size.width/2, y: positionY)
        border.zPosition = GameConstants.zPositions.hudZ - 0.1
        
        addChild(border)
    }
    
    func addLabel(label: String, positionX: CGFloat, positionY: CGFloat) {
        let finishedLabel = SKLabelNode(text: label)
        finishedLabel.fontSize = 15
        finishedLabel.fontColor = .black
        finishedLabel.position = CGPoint(x: positionX, y: positionY)
        
        
        addChild(finishedLabel)
    }
}

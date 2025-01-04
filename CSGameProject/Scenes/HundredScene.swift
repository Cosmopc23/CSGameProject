//
//  HundredScene.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 07/09/2024.
//

import SpriteKit
import Foundation

enum HundredGameState {
    case ready, ongoing, finished
}

class HundredScene: BaseGameScene {
    
    // running bar
    var progressBar: SKSpriteNode!
    var currentValue: CGFloat = 0.0
    var maxValue: CGFloat = 100.0
    var minValue: CGFloat = 40.0
    var decreaseRate: CGFloat = 4
    var timer: Timer?
    
    var targetMinValue: CGFloat = 0.0
    var targetMaxValue: CGFloat = 0.0
    
    var targetMinIndicator: SKSpriteNode!
    var targetMaxIndicator: SKSpriteNode!
    
    var finishTimes: [String:TimeInterval] = [:]
    var raceStartTime: TimeInterval = 0
    var playerTime: TimeInterval = 0
    var competitor1Time: TimeInterval = 0
    var competitor2Time: TimeInterval = 0
    var competitor3Time: TimeInterval = 0
    
    var player: Player!
    var competitor1: Competitor1!
    var competitor2: Competitor2!
    var competitor3: Competitor3!
    var finishers: Int = 0
    
    var playerSkill: Double = 0.0
    var playerSpeed: Double = 0.0
    
    var touch = false
    
    var difficulty: RaceDifficulty = .intermediate
    
    var gameState = HundredGameState.ready {
        willSet {
            switch newValue {
            case .ready:
                player.state = .idle
                competitor1.state = .idle
                competitor2.state = .idle
                competitor3.state = .idle
            case .ongoing:
                player.state = .running
                competitor1.state = .running
                competitor2.state = .running
                competitor3.state = .running
            case .finished:
                player.state = .idle
                competitor1.state = .idle
                competitor2.state = .idle
                competitor3.state = .idle
            }
        }
    }
    
    convenience init(size: CGSize, difficulty: RaceDifficulty = .intermediate) {
        self.init(size: size)
        self.difficulty = difficulty
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        playerSkill = MenuScene.getStat(key: GameConstants.StringConstants.skillKey)
        playerSpeed = MenuScene.getStat(key: GameConstants.StringConstants.speedKey)
        
        targetMinValue = 60 - (CGFloat(playerSkill) / 6.0)
        
        targetMaxValue = 80 + (CGFloat(playerSkill) / 6.0)
        
        // running bar
        progressBar = SKSpriteNode(color: .red, size: CGSize(width: 300, height: 20))
        progressBar.position = CGPoint(x: size.width / 3, y: size.height - 3*(progressBar.size.height))
        progressBar.zPosition = GameConstants.zPositions.hudZ
        progressBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        addChild(progressBar)
        
        let borderWidth: CGFloat = 2.0
        let border = SKShapeNode(rectOf: CGSize(width: 300 + borderWidth, height: 20 + borderWidth), cornerRadius: 2.0)
        border.strokeColor = .black
        border.lineWidth = borderWidth
        border.fillColor = .clear
        border.position = CGPoint(x: (size.width / 3) + progressBar.size.width/2, y: size.height - 3*(progressBar.size.height))
        border.zPosition = GameConstants.zPositions.hudZ - 0.1
        
        addChild(border)
        
        targetMinIndicator = SKSpriteNode(color: .black, size: CGSize(width: 2, height: 20))
        targetMinIndicator.zPosition = GameConstants.zPositions.hudZ + 1
        progressBar.addChild(targetMinIndicator)
        
        targetMaxIndicator = SKSpriteNode(color: .black, size: CGSize(width: 2, height: 20))
        targetMaxIndicator.zPosition = GameConstants.zPositions.hudZ + 1
        progressBar.addChild(targetMaxIndicator)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(decreaseValue), userInfo: nil, repeats: true)
        
        load(level: "100m")
        addPlayer()
        addCompetitor1()
        addCompetitor2()
        addCompetitor3()
        
        DifficultyManager.configureCompetitors(self, for: difficulty)
        
        
        print("\n=== 100M RACE DEBUG ===")
        print("Current Difficulty: \(difficulty)")
        print("Competitor 1 - Speed: \(String(format: "%.2f", competitor1.competitor1TopSpeed)), Acceleration: \(String(format: "%.2f", competitor1.competitor1Acceleration))")
        print("Competitor 2 - Speed: \(String(format: "%.2f", competitor2.competitor2TopSpeed)), Acceleration: \(String(format: "%.2f", competitor2.competitor2Acceleration))")
        print("Competitor 3 - Speed: \(String(format: "%.2f", competitor3.competitor3TopSpeed)), Acceleration: \(String(format: "%.2f", competitor3.competitor3Acceleration))")
        print("=====================\n")
        
        
    }
    
    func addPlayer() {
        player = Player(imageNamed: GameConstants.StringConstants.playerImageName)
        player.scale(to: frame.size, width: false, multiplier: 0.4)
        player.name = GameConstants.StringConstants.playerName
        PhysicsHelper.addPhysicsBody(to: player, with: player.name!)
        player.position = CGPoint(x: frame.midX/2.0, y: frame.midY)
        player.zPosition = GameConstants.zPositions.playerZ
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        player.loadTextures()
        player.state = .idle
        
        addChild(player)
    }
    
    func addCompetitor1() {
        competitor1 = Competitor1(imageNamed: GameConstants.StringConstants.competitor1ImageName)
        competitor1.scale(to: frame.size, width: false, multiplier: 0.4)
        competitor1.name = GameConstants.StringConstants.competitor1Name
        PhysicsHelper.addPhysicsBody(to: competitor1, with: competitor1.name!)
        competitor1.position = CGPoint(x: frame.midX/2.0, y: frame.midY)
        competitor1.zPosition = GameConstants.zPositions.competitor1Z
        competitor1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        competitor1.competitor1Speed = 0.0
        
        competitor1.loadTextures()
        competitor1.state = .idle
        
        addChild(competitor1)
    }
    
    func addCompetitor2() {
        competitor2 = Competitor2(imageNamed: GameConstants.StringConstants.competitor2ImageName)
        competitor2.scale(to: frame.size, width: false, multiplier: 0.4)
        competitor2.name = GameConstants.StringConstants.competitor2Name
        PhysicsHelper.addPhysicsBody(to: competitor2, with: competitor2.name!)
        competitor2.position = CGPoint(x: frame.midX/2.0, y: frame.midY)
        competitor2.zPosition = GameConstants.zPositions.competitor2Z
        competitor2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        competitor2.competitor2Speed = 0.0
        
        
        competitor2.loadTextures()
        competitor2.state = .idle
        
        addChild(competitor2)
    }
    
    func addCompetitor3() {
        competitor3 = Competitor3(imageNamed: GameConstants.StringConstants.competitor3ImageName)
        competitor3.scale(to: frame.size, width: false, multiplier: 0.4)
        competitor3.name = GameConstants.StringConstants.competitor3Name
        PhysicsHelper.addPhysicsBody(to: competitor3, with: competitor3.name!)
        competitor3.position = CGPoint(x: frame.midX/2.0, y: frame.midY)
        competitor3.zPosition = GameConstants.zPositions.competitor3Z
        competitor3.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        competitor3.competitor3Speed = 0.0
        
        competitor3.loadTextures()
        competitor3.state = .idle
        
        addChild(competitor3)
    }
    
    func handleFinish() {
        gameState = .finished
        print("End")
        
        self.isPaused = true
        showFinishLineScreen()
    }
    
    func showFinishLineScreen() {
        let finishScreen = SKSpriteNode(color: .black, size: CGSize(width: self.size.width, height: self.size.height))
        finishScreen.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        finishScreen.zPosition = GameConstants.zPositions.finishScreenZ
        finishScreen.alpha = 0.75
        self.addChild(finishScreen)
        
        let titleLabel = SKLabelNode(text: "Race Results")
        titleLabel.fontSize = 40
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 100)
        titleLabel.zPosition = GameConstants.zPositions.topZ
        self.addChild(titleLabel)
        
        let sortedResults = finishTimes.sorted { $0.value < $1.value }
        
        sortResults(string: " seconds    Reward: ", sortedResults: sortedResults)
        
        let restartButton = SKLabelNode(text: "Return to Menu")
        restartButton.fontSize = 30
        restartButton.fontColor = .yellow
        restartButton.position = CGPoint(x: self.size.width / 2, y: 100)
        restartButton.zPosition = GameConstants.zPositions.topZ
        restartButton.name = "returnToMenu"
        self.addChild(restartButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .ready:
            gameState = .ongoing
            raceStartTime = CACurrentMediaTime()
        case .ongoing:
            currentValue += 8
            if currentValue > maxValue {
                currentValue = maxValue
            }
            updateProgressBar()
        case .finished:
            let touch = touches.first!
            let location = touch.location(in: self)
            let nodeAtPoint = atPoint(location)
            print("Touched at: \(location)")
            if nodeAtPoint.name == "returnToMenu"{
                returnToMenu()
            }
        }
    }
    
    func returnToMenu() {
        let transition = SKTransition.fade(withDuration: 1.0)
        let scene = MenuScene(size: self.size)
        scene.scaleMode = .aspectFill
        self.view?.presentScene(scene, transition: transition)
    }
    
    @objc func decreaseValue() {
        currentValue -= decreaseRate
        if currentValue < 0 {
            currentValue = 0
        }
        updateProgressBar()
        adjustSpeed()
    }
    
    func updateProgressBar() {
        let width = (currentValue / maxValue) * 300
        progressBar.size.width = width
        
        if currentValue >= targetMinValue && currentValue <= targetMaxValue {
            progressBar.color = .green
        } else {
            progressBar.color = .red
        }
        
        let targetMinX = (targetMinValue / maxValue) * 300
        let targetMaxX = (targetMaxValue / maxValue) * 300
        
        targetMinIndicator.position = CGPoint(x: targetMinX, y: 0)
        targetMaxIndicator.position = CGPoint(x: targetMaxX, y: 0)
    }
    
    func adjustSpeed() {
        let baseMultiplier = 1.0 + (playerSpeed / 100.0)

        if currentValue == 0 {
            characterSpeed = 0
        } else if currentValue < targetMinValue * 0.2 {
            characterSpeed = 10.0 * baseMultiplier
        } else if currentValue < targetMinValue * 0.4 {
            characterSpeed = 20.0 * baseMultiplier
        } else if currentValue < targetMinValue * 0.6 {
            characterSpeed = 30.0 * baseMultiplier
        } else if currentValue < targetMinValue * 0.8 {
            characterSpeed = 40.0 * baseMultiplier
        } else if currentValue < targetMinValue {
            characterSpeed = 50.0 * baseMultiplier
        } else if currentValue < (targetMinValue + (targetMaxValue - targetMinValue) * 0.33) {
            characterSpeed = 60.0 * baseMultiplier
        } else if currentValue < (targetMinValue + (targetMaxValue - targetMinValue) * 0.66) {
            characterSpeed = 70.0 * baseMultiplier
        } else if currentValue <= targetMaxValue {
            characterSpeed = 80.0 * baseMultiplier
        } else if currentValue <= maxValue * 0.9 {
            characterSpeed = 40.0 * baseMultiplier
        } else {
            characterSpeed = 20.0 * baseMultiplier
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastTime > 0 {
            dt = currentTime - lastTime
        } else {
            dt = 0
        }
        
        let deltaTime = currentTime - lastTime
        lastTime = currentTime
        
        if gameState == .ongoing {
            worldLayer.update(dt)
            backgroundLayer.update(dt)
            
            if competitor1.competitor1Speed > competitor1.competitor1TopSpeed {
                competitor1.competitor1Speed = competitor1.competitor1TopSpeed
            } else if (competitor1.competitor1Speed) > (competitor1.competitor1TopSpeed - 15) {
                let randomChange = CGFloat.random(in: -10...10)
                competitor1.competitor1Speed += randomChange
            } else {
                competitor1.competitor1Speed += competitor1.competitor1Acceleration
            }
            
            let speedDifference1 = characterSpeed - competitor1.competitor1Speed
            competitor1.position.x -= speedDifference1 * CGFloat(deltaTime) * 3
            
            if competitor2.competitor2Speed > competitor2.competitor2TopSpeed {
                competitor2.competitor2Speed = competitor2.competitor2TopSpeed
            } else if (competitor2.competitor2Speed) > (competitor2.competitor2TopSpeed - 15) {
                let randomChange = CGFloat.random(in: -10...10)
                competitor2.competitor2Speed += randomChange
            } else {
                competitor2.competitor2Speed += competitor2.competitor2Acceleration
            }
            
            let speedDifference2 = characterSpeed - competitor2.competitor2Speed
            competitor2.position.x -= speedDifference2 * CGFloat(deltaTime) * 3
            
            if competitor3.competitor3Speed > competitor3.competitor3TopSpeed {
                competitor3.competitor3Speed = competitor3.competitor3TopSpeed
            } else if (competitor3.competitor3Speed) > (competitor3.competitor3TopSpeed - 15) {
                let randomChange = CGFloat.random(in: -10...10)
                competitor3.competitor3Speed += randomChange
            } else {
                competitor3.competitor3Speed += competitor3.competitor3Acceleration
            }
            
            let speedDifference3 = characterSpeed - competitor3.competitor3Speed
            competitor3.position.x -= speedDifference3 * CGFloat(deltaTime) * 3
            
        } else if gameState == .finished {
            backgroundLayer.layerVelocity = CGPoint(x: -75.0, y: 0.0)
        }
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
            let bodyA = contact.bodyA
            let bodyB = contact.bodyB
            
            if (bodyA.categoryBitMask == GameConstants.PhysicsCategories.playerCategory) && (bodyB.categoryBitMask == GameConstants.PhysicsCategories.finishCategory) || (bodyA.categoryBitMask == GameConstants.PhysicsCategories.finishCategory) &&  (bodyB.categoryBitMask == GameConstants.PhysicsCategories.playerCategory) {
                let currentTime = CACurrentMediaTime()
                playerTime = raceStartTime - currentTime
                finishTimes["Player"] = playerTime
                
                finishers += 1
                characterSpeed = 0
                player.state = .idle
                print("Player Finish")
            }
            if (bodyA.categoryBitMask == GameConstants.PhysicsCategories.competitor1Category) && (bodyB.categoryBitMask == GameConstants.PhysicsCategories.finishCategory) || (bodyA.categoryBitMask == GameConstants.PhysicsCategories.finishCategory) &&  (bodyB.categoryBitMask == GameConstants.PhysicsCategories.competitor1Category) {
                
                let currentTime = CACurrentMediaTime()
                competitor1Time = raceStartTime - currentTime
                finishTimes[GameConstants.StringConstants.competitor1Name] = competitor1Time
                
                finishers += 1
                competitor1.competitor1Speed = 0
                competitor1.state = .idle
                print("Competitor1 Finish")
            }
            if (bodyA.categoryBitMask == GameConstants.PhysicsCategories.competitor2Category) && (bodyB.categoryBitMask == GameConstants.PhysicsCategories.finishCategory) || (bodyA.categoryBitMask == GameConstants.PhysicsCategories.finishCategory) &&  (bodyB.categoryBitMask == GameConstants.PhysicsCategories.competitor2Category) {
                
                let currentTime = CACurrentMediaTime()
                competitor2Time = raceStartTime - currentTime
                finishTimes[GameConstants.StringConstants.competitor2Name] = competitor2Time
                
                finishers += 1
                competitor2.competitor2Speed = 0
                competitor2.state = .idle
                print("Competitor2 Finish")
            }
            if (bodyA.categoryBitMask == GameConstants.PhysicsCategories.competitor3Category) && (bodyB.categoryBitMask == GameConstants.PhysicsCategories.finishCategory) || (bodyA.categoryBitMask == GameConstants.PhysicsCategories.finishCategory) &&  (bodyB.categoryBitMask == GameConstants.PhysicsCategories.competitor3Category) {
                
                let currentTime = CACurrentMediaTime()
                competitor3Time = raceStartTime - currentTime
                finishTimes[GameConstants.StringConstants.competitor3Name] = competitor3Time
                
                finishers += 1
                competitor3.competitor3Speed = 0
                competitor3.state = .idle
                print("Competitor3 Finish")
            }
            
            if finishers == 4 {
                print("\n=== RACE FINISH TIMES ===")
                print("Current Difficulty: \(difficulty)")
                for (name, time) in finishTimes.sorted(by: { $0.value < $1.value }) {
                    print("\(name): \(abs(time)) seconds")
                }
                print("=====================\n")
                handleFinish()
            }
        }
    }

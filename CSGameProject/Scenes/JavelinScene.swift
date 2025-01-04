//
//  JavelinScene.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 16/10/2024.
//

import Foundation
import SpriteKit

enum JavelinGameState {
    case ready, running, speedLock, angleSelection, throwing, thrown
}

class JavelinScene: BaseGameScene {
    var player: Player!
    let javelinSprite = SKSpriteNode(imageNamed: "Javelin")
    var tileSize = CGFloat(10)
    
    var xHandPosition: Double = 0.0
    var yHandPosition: Double = 0.0
    
    var distances: [String:Double] = [:]
    
    var timesThrown: Int = 0
    var playerThrows: [Double] = []
    
    var bestDistance: Double = 0.0
    
    // Progress bar
    var progressBar: SKSpriteNode!
    var currentValue: CGFloat = 0.0
    var decreaseRate: CGFloat = 6
    var maxValue: CGFloat = 100.0
    var timer: Timer?
    var lockedValue: CGFloat = 0.0
    
    private var throwAngle: CGFloat = 0.0
    private var initialVelocity: CGFloat = 0.0
    private var throwStartTime: TimeInterval = 0
    private var throwStartPosition: CGPoint = .zero
    private var distanceTraveled: CGFloat = 0.0
    private var virtualPositionX: CGFloat = 0.0
    private let gravity: CGFloat = -9.81
    
    private var angleBar: SKSpriteNode!
    private var angleIndicator: SKSpriteNode!
    private var currentAngle: CGFloat = 0.0
    private var angleSwingSpeed: CGFloat = 2.0
    private var isSwingingAngle: Bool = false
    private var angleDirection: CGFloat = 1.0
    
    private var runningDistance: CGFloat = 0.0
    private var maxRunningDistance: CGFloat = 200.0
    private var speedLockLabel: SKLabelNode?
    private var angleBorder: SKShapeNode?
    
    var difficulty: RaceDifficulty = .intermediate
    
    var playerStrength: Double = 10.0
    var playerSkill: Double = 10.0
    
    convenience init(size: CGSize, numberOfThrows: Int = 0, previousThrows: [Double] = [], difficulty: RaceDifficulty = .intermediate, strength: Double = 10.0, skill: Double = 10.0) {
        self.init(size: size)
        self.timesThrown = numberOfThrows
        self.playerThrows = previousThrows
        self.difficulty = difficulty
        self.playerStrength = strength
        self.playerSkill = skill
    
        
        // Adjust angleSwingSpeed based on skill
        // At 80 skill (current), speed is 2.0
        // At 100 skill, speed will be 1.2 (much easier to time)
        // At 0 skill, speed will be 4.0 (much harder to time)
        self.angleSwingSpeed = 4.0 - (skill / 100.0 * 2.8)
    }
    
    var gameState = JavelinGameState.ready {
        willSet {
            switch newValue {
            case .ready:
                player.state = .throwIdle
                characterSpeed = 0
                angleBar?.isHidden = true
                (angleBorder! as SKNode).isHidden = true
                angleIndicator?.isHidden = true
                runningDistance = 0
            case .running:
                player.state = .throwRunning
                angleBar?.isHidden = true
                (angleBorder! as SKNode).isHidden = true
                angleIndicator?.isHidden = true
            case .speedLock:
                player.state = .throwRunning
                characterSpeed = currentValue / 2
                angleBar.isHidden = false
                angleIndicator.isHidden = true
                (angleBorder! as SKNode).isHidden = false
                showSpeedLockMessage()
            case .angleSelection:
                player.state = .throwRunning
                angleBar?.isHidden = false
                angleIndicator.isHidden = false
                angleIndicator?.isHidden = false
                isSwingingAngle = true
                
            case .throwing:
                player.state = .idle

                isSwingingAngle = false
                angleBar?.isHidden = true
                (angleBorder! as SKNode).isHidden = true
                angleIndicator?.isHidden = true
                speedLockLabel?.removeFromParent()
            case .thrown:
                player.state = .idle
                characterSpeed = 0
            }
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
            
        // Progress bar setup
        progressBar = SKSpriteNode(color: .green, size: CGSize(width: 300, height: 20))
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
        
        setupAngleBar()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(decreaseValue), userInfo: nil, repeats: true)
        load(level: "Javelin")
    }
    
    func showSpeedLockMessage() {
        speedLockLabel = SKLabelNode(text: "SPEED LOCK")
        speedLockLabel?.fontSize = 48
        speedLockLabel?.fontColor = .yellow
        speedLockLabel?.position = CGPoint(x: frame.midX, y: frame.midY)
        speedLockLabel?.zPosition = GameConstants.zPositions.hudZ + 2
        
        if let label = speedLockLabel {
            addChild(label)
            
            let wait = SKAction.wait(forDuration: 1.2)
            let fadeOut = SKAction.fadeOut(withDuration: 0.3)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([wait, fadeOut, remove])
            
            
            label.run(sequence) { [weak self] in
                self?.gameState = .angleSelection
            }
        }
        
        gameState = .angleSelection
        
        lockedValue = currentValue
        decreaseRate = 2
    }
    
    func setupAngleBar() {
        let borderWidth: CGFloat = 2.0
        
        angleBar = SKSpriteNode(color: .gray, size: CGSize(width: 200, height: 20))
        angleBar.position = CGPoint(x: size.width / 3, y: size.height - 5*(angleBar.size.height))
        angleBar.zPosition = GameConstants.zPositions.hudZ
        angleBar.isHidden = true
        addChild(angleBar)
        
        angleIndicator = SKSpriteNode(color: .yellow, size: CGSize(width: 10, height: 20))
        angleIndicator.position = CGPoint(x: angleBar.position.x, y: angleBar.position.y)
        angleIndicator.zPosition = GameConstants.zPositions.hudZ + 1
        angleIndicator.isHidden = true
        addChild(angleIndicator)
        
        angleBorder = SKShapeNode(rectOf: CGSize(width: 200 + borderWidth, height: 20 + borderWidth), cornerRadius: 2.0)
        angleBorder?.strokeColor = .black
        angleBorder?.lineWidth = borderWidth
        angleBorder?.fillColor = .clear
        angleBorder?.position = angleBar.position
        angleBorder?.zPosition = GameConstants.zPositions.hudZ - 0.1
        addChild(angleBorder!)
        
        angleBar.isHidden = true
        (angleBorder! as SKNode).isHidden = true
    }
    
    
    override func loadTileMap() {
        super.loadTileMap()
        addPlayer()
        player.isHidden = false
        addJavelin()
    }
    
    @objc func decreaseValue() {
            currentValue -= decreaseRate
            if currentValue < 0 {
                currentValue = 0
            }
            updateProgressBar()
            adjustSpeed()
        }
    
    func adjustSpeed() {
            characterSpeed = currentValue / 2
            updateLayerVelocities()
        }
    
    func updateProgressBar() {
        let width = (currentValue / maxValue) * 300
        progressBar.size.width = width
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
        player.state = .throwIdle
        
        addChild(player)
    }
    
    func addJavelin() {
        PhysicsHelper.addPhysicsBody(to: javelinSprite, with: GameConstants.StringConstants.javelinName)
        javelinSprite.scale(to: frame.size, width: false, multiplier: 0.165)
        javelinSprite.position = CGPoint(x: xHandPosition, y: yHandPosition)
        javelinSprite.zPosition = GameConstants.zPositions.objectZ
        javelinSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        javelinSprite.zRotation = -0.1
        
        addChild(javelinSprite)
    }
    
    func initiateThrow() {
        throwAngle = ((currentAngle * .pi) / 180)
        throwStartTime = lastTime
        throwStartPosition = player.position
        virtualPositionX = 0
        
        // Modify initial velocity based on strength
        // At 80 strength (current), velocity is lockedValue
        // At 100 strength, velocity should be 25% higher
        // At 0 strength, velocity should be 50% lower
        let strengthMultiplier = 0.5 + (playerStrength / 100.0 * 0.75)
        initialVelocity = lockedValue * CGFloat(strengthMultiplier)
        
        javelinSprite.isHidden = false
        javelinSprite.position = CGPoint(x: player.position.x + 30, y: player.position.y + 20)
        javelinSprite.physicsBody?.isDynamic = true
        javelinSprite.physicsBody?.affectedByGravity = true
        
        let verticalVelocity = initialVelocity * sin(throwAngle) * 2.0
        let horizontalVelocity = initialVelocity * cos(throwAngle)
        let initialTrajectoryAngle = atan2(verticalVelocity, horizontalVelocity)
        javelinSprite.zRotation = initialTrajectoryAngle - .pi/2
        
    }
    
    func returnToMenu() {
        playerThrows = []
        timesThrown = 0
        
        let transition = SKTransition.fade(withDuration: 1.0)
        let scene = MenuScene(size: self.size)
        scene.scaleMode = .aspectFill
        self.view?.presentScene(scene, transition: transition)
    }
    
    func updateAngleIndicator() {
        if isSwingingAngle {
            currentAngle += angleSwingSpeed * angleDirection
            
            
            if currentAngle >= 90 || currentAngle <= 0 {
                angleDirection *= -1
            }
            
            currentAngle = max(0, min(90, currentAngle))
            
            let progress = currentAngle/90
            let newX = angleBar.position.x - (angleBar.size.width/2) + (angleBar.size.width * progress)
            angleIndicator.position.x = newX
            
//            print(progress)
        }
    }
    
    func generateRandomDistance() -> Double {
        let randomValue = Double.random(in: 70..<101)
        return (randomValue * 100).rounded() / 100
    }
    
    func generateCompetitorThrow() {
//        let Competitor1Distance = generateRandomDistance()
//        let Competitor2Distance = generateRandomDistance()
//        let Competitor3Distance = generateRandomDistance()
        
        let Competitor1Distance = DifficultyManager.generateCompetitorThrow(self, for: difficulty)
        let Competitor2Distance = DifficultyManager.generateCompetitorThrow(self, for: difficulty)
        let Competitor3Distance = DifficultyManager.generateCompetitorThrow(self, for: difficulty)
        
        print("\n=== JAVELIN THROW DEBUG ===")
        print("Current Difficulty: \(difficulty)")
        print("Competitor 1 Distance: \(String(format: "%.2f", Competitor1Distance))m")
        print("Competitor 2 Distance: \(String(format: "%.2f", Competitor2Distance))m")
        print("Competitor 3 Distance: \(String(format: "%.2f", Competitor3Distance))m")
        print("========================\n")
        
        distances[GameConstants.StringConstants.competitor1Name] = Competitor1Distance
        distances[GameConstants.StringConstants.competitor2Name] = Competitor2Distance
        distances[GameConstants.StringConstants.competitor3Name] = Competitor3Distance
    }
    
    func handleThrowComplete() {
        let finalDistance = distanceTraveled / 10
        playerThrows.append(finalDistance)
        timesThrown += 1
        
        print(playerThrows)
        
        bestDistance = playerThrows.max() ?? 0.0
        
        print(bestDistance)
        
        let finishScreen = SKSpriteNode(color: .black, size: CGSize(width: self.size.width, height: self.size.height))
        finishScreen.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        finishScreen.zPosition = GameConstants.zPositions.finishScreenZ
        finishScreen.alpha = 0.75
        self.addChild(finishScreen)
        
        let titleLabel = SKLabelNode(text: "Throw \(timesThrown)")
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        titleLabel.fontColor = .yellow
        titleLabel.fontSize = 30
        titleLabel.zPosition = GameConstants.zPositions.topZ
        self.addChild(titleLabel)
        
        
        var yOffset: CGFloat = 40
        var i = 1
        for attempt in playerThrows {
            let resultLabel = SKLabelNode(text: "Attempt \(i). \(String(format: "%.2f", attempt))m")
            resultLabel.fontSize = 24
            resultLabel.fontColor = .white
            resultLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 150 - yOffset)
            resultLabel.zPosition = GameConstants.zPositions.topZ
            self.addChild(resultLabel)
            i += 1
            
            yOffset += 30
        }
        
        if timesThrown == 3 {
            let continueLabel = SKLabelNode(text: "Continue to Results")
            continueLabel.position = CGPoint(x: frame.midX, y: frame.midY - 110)
            continueLabel.fontColor = .yellow
            continueLabel.fontSize = 24
            continueLabel.zPosition = GameConstants.zPositions.topZ
            continueLabel.name = "continue"
            self.addChild(continueLabel)
        } else {
            let resetLabel = SKLabelNode(text: "Next Attempt")
            resetLabel.position = CGPoint(x: frame.midX, y: frame.midY - 110)
            resetLabel.fontColor = .yellow
            resetLabel.fontSize = 24
            resetLabel.zPosition = GameConstants.zPositions.topZ
            resetLabel.name = "resetLabel"
            self.addChild(resetLabel)
        }
    }
    
    
    func cleanupThrowScreen() {
        self.children.forEach { node in
            // Remove all labels and the finish screen
            if node is SKLabelNode || node.name == "finishScreen" {
                node.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .ready:
            gameState = .running
            characterSpeed = 10
            updateLayerVelocities()
        case .running:
            currentValue += 10
            if currentValue > maxValue {
                currentValue = maxValue
            }
            updateProgressBar()
            adjustSpeed()
        case .angleSelection:
            gameState = .throwing
            initiateThrow()
        case .thrown:
            let touch = touches.first!
            let location = touch.location(in: self)
            let nodeAtPoint = atPoint(location)
            
            if nodeAtPoint.name == "returnToMenu" {
                returnToMenu()
            } else if nodeAtPoint.name == "resetLabel" {
                let transition = SKTransition.fade(withDuration: 1.0)
                let scene = JavelinScene(size: self.size, numberOfThrows: self.timesThrown, previousThrows: self.playerThrows, difficulty: self.difficulty, strength: self.playerStrength, skill: self.playerSkill)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: transition)
            } else if nodeAtPoint.name == "continue" {
                cleanupThrowScreen()
                
                distances["Player"] = bestDistance
                generateCompetitorThrow()
                
                let sortedResults = distances.sorted { $0.value < $1.value }
                
                
                sortResults(string: "m      Reward: ", sortedResults: sortedResults)
                
                
                let menuButton = SKLabelNode(text: "Return to Menu")
                menuButton.position = CGPoint(x: frame.midX, y: frame.midY - 110)
                menuButton.fontColor = .yellow
                menuButton.fontSize = 24
                menuButton.name = "returnToMenu"
                menuButton.zPosition = GameConstants.zPositions.topZ
                addChild(menuButton)
                
                print("THROW COMPLETE")
                
                
            }
        default:
            break
        }
        }
    
    override func update(_ currentTime: TimeInterval) {
            if lastTime > 0 {
                dt = currentTime - lastTime
            } else {
                dt = 0
            }
            lastTime = currentTime
            
        if gameState == .angleSelection {
            updateAngleIndicator()
        }
        
        switch gameState {
        case .running:
            worldLayer.update(dt)
            backgroundLayer.update(dt)
            runningDistance += characterSpeed * CGFloat(dt)
            
            if runningDistance >= maxRunningDistance {
                gameState = .speedLock
            }
        case .speedLock:
            worldLayer.update(dt)
            backgroundLayer.update(dt)
            runningDistance += characterSpeed * CGFloat(dt)
        case .throwing:
            if javelinSprite.physicsBody != nil {
                distanceTraveled = virtualPositionX / 7.0
                let throwDuration = currentTime - throwStartTime
                        
                let horizontalVelocity = initialVelocity * cos(throwAngle)
                virtualPositionX = lockedValue * cos(throwAngle) * CGFloat(throwDuration) * 7.0
                
                let verticalVelocity = initialVelocity * sin(throwAngle) * 2.0
                let verticalPosition = throwStartPosition.y + (verticalVelocity * CGFloat(throwDuration)) +
                (gravity * CGFloat(throwDuration * throwDuration))
                
                // Update javelin position
                let newPosition = CGPoint(x: throwStartPosition.x + virtualPositionX, y: verticalPosition)
                 
                var trajectoryAngle = 0.0
                
                if throwDuration < 0.6 {
                    let vertAngle = (verticalVelocity +
                                     (gravity * CGFloat(throwDuration * throwDuration)))
                    trajectoryAngle = atan2(vertAngle, horizontalVelocity)
                } else {
                    let vertAngle = (verticalVelocity * throwDuration +
                                     (gravity * CGFloat(throwDuration * throwDuration)))
                    trajectoryAngle = atan2(vertAngle, horizontalVelocity)
                }
                
//                print("=== Frame Debug ===")
//                print("Initial Velocity: \(initialVelocity)")
//                print("Throw Angle: \(throwAngle)")
//                print("Time Duration: \(throwDuration)")
//                print("Horizontal Velocity: \(horizontalVelocity)")
//                print("Vertical Velocity: \(verticalVelocity)")
//                print("Current Vertical: \(verticalVelocity + (gravity * throwDuration))")
//                print("Trajectory Angle: \(trajectoryAngle)")
//                print("==================")
                
                javelinSprite.zRotation = trajectoryAngle - .pi/2
                
                javelinSprite.position = newPosition
                
            }
        default:
            break
        }
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask == GameConstants.PhysicsCategories.javelinCategory) && (bodyB.categoryBitMask == GameConstants.PhysicsCategories.groundCategory) || (bodyA.categoryBitMask == GameConstants.PhysicsCategories.groundCategory) &&  (bodyB.categoryBitMask == GameConstants.PhysicsCategories.javelinCategory) {
            javelinSprite.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            javelinSprite.physicsBody!.allowsRotation = false
            javelinSprite.physicsBody!.angularVelocity = 0
            
            if gameState == .throwing {
                gameState = .thrown
                handleThrowComplete()
                
                print("Complete")
            }
        }
    }
}

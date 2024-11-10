//
//  JavelinScene.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 16/10/2024.
//

import Foundation
import SpriteKit

enum JavelinGameState {
    case ready, ongoing, throwing, thrown
}

class JavelinScene: BaseGameScene {
    var player: Player!
    let javelinSprite = SKSpriteNode(imageNamed: "Javelin")
    var tileSize = CGFloat(10)
    
    var xHandPosition: Double = 0.0
    var yHandPosition: Double = 0.0
    var currentHandFrameIndex = 0
    
    // Progress bar
    var progressBar: SKSpriteNode!
    var currentValue: CGFloat = 0.0
    var decreaseRate: CGFloat = 6
    var maxValue: CGFloat = 100.0
    var timer: Timer?
    
    var gameState = JavelinGameState.ready {
        willSet {
            switch newValue {
            case .ready:
                player.state = .throwIdle
                characterSpeed = 0  // Make sure to stop when ready
            case .ongoing:
                player.state = .throwRunning
            case .throwing:
                player.state = .throwIdle // need to change to throw action
                characterSpeed = 0  // Stop when throwing
            case .thrown:
                player.state = .idle
                characterSpeed = 0  // Stop when thrown
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
            
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(decreaseValue), userInfo: nil, repeats: true)
            
            load(level: "Javelin")
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
            if gameState == .ongoing {
                characterSpeed = currentValue
                updateLayerVelocities()
            } else {
                characterSpeed = 0
                updateLayerVelocities()
            }
        print("Currentvalue = \(currentValue)")
        print("Characterspeed = \(characterSpeed)")
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            switch gameState {
            case .ready:
                gameState = .ongoing
                characterSpeed = 10
                updateLayerVelocities()
            case .ongoing:
                currentValue += 10
                if currentValue > maxValue {
                    currentValue = maxValue
                }
                updateProgressBar()
                adjustSpeed()
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
            
            if gameState == .ongoing {
                worldLayer.update(dt)
                backgroundLayer.update(dt)
            }
        }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask == GameConstants.PhysicsCategories.javelinCategory) && (bodyB.categoryBitMask == GameConstants.PhysicsCategories.groundCategory) || (bodyA.categoryBitMask == GameConstants.PhysicsCategories.groundCategory) &&  (bodyB.categoryBitMask == GameConstants.PhysicsCategories.javelinCategory) {
            javelinSprite.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            javelinSprite.physicsBody!.allowsRotation = false
            javelinSprite.physicsBody!.angularVelocity = 0
        }
    }
}

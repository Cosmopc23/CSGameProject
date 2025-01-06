//
//  Difficulty Selector .swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 05/01/2025.
//

import Foundation
import SpriteKit



class DifficultySelector: SKScene {
    
    let borderWidth: CGFloat = 2.0
    
    var playerSkill: Double = 10.0
    var playerStrength: Double = 10.0
    var playerSpeed: Double = 10.0
    
    var chosenEvent: String = "Hundred"
    
    convenience init(size: CGSize, event: String, skill: Double = 10.0, strength: Double = 10.0, speed: Double = 10.0) {
        self.init(size: size)
        
        self.playerSkill = skill
        self.playerStrength = strength
        self.playerSpeed = speed
        self.chosenEvent = event
    }
    
    override func didMove(to view: SKView) {
        let backgroundTexture = SKTexture(imageNamed: "background")
        let background = SKSpriteNode(texture: backgroundTexture)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.size
        background.zPosition = -100
        addChild(background)
        
        setupNodes()
    }
    
    
    
    func setupNodes() {
        //BEGINNER
        let beginnerButton = SKSpriteNode(color: .white, size: CGSize(width: 90, height: 40))
        beginnerButton.name = "beginnerButton"
        beginnerButton.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        beginnerButton.zPosition = GameConstants.zPositions.hudZ
        addChild(beginnerButton)
        
        let borderBeginner = SKShapeNode(rectOf: CGSize(width: 90+borderWidth, height: 40+borderWidth), cornerRadius: 2.0)
        borderBeginner.strokeColor = .black
        borderBeginner.lineWidth = borderWidth
        borderBeginner.fillColor = .clear
        borderBeginner.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        borderBeginner.zPosition = GameConstants.zPositions.hudZ + 0.1
        borderBeginner.isUserInteractionEnabled = false
        
        addChild(borderBeginner)
        
        let beginnerLabel = SKLabelNode(text: "Beginner")
        beginnerLabel.fontName = "Helvetica-Bold"
        beginnerLabel.fontColor = .black
        beginnerLabel.fontSize = 12
        beginnerLabel.verticalAlignmentMode = .center
        beginnerLabel.position = CGPoint(x: 0, y: 0)
        borderBeginner.addChild(beginnerLabel)
        
        
        //AMATEUR
        let amateurButton = SKSpriteNode(color: .white, size: CGSize(width: 90, height: 40))
        amateurButton.name = "amateurButton"
        amateurButton.position = CGPoint(x: frame.midX, y: frame.midY + 50 )
        amateurButton.zPosition = GameConstants.zPositions.hudZ
        addChild(amateurButton)
        
        let borderAmateur = SKShapeNode(rectOf: CGSize(width: 90+borderWidth, height: 40+borderWidth), cornerRadius: 2.0)
        borderAmateur.strokeColor = .black
        borderAmateur.lineWidth = borderWidth
        borderAmateur.fillColor = .clear
        borderAmateur.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        borderAmateur.zPosition = GameConstants.zPositions.hudZ + 0.1
        borderAmateur.isUserInteractionEnabled = false
        
        addChild(borderAmateur)
        
        let amateurLabel = SKLabelNode(text: "Amateur")
        amateurLabel.fontName = "Helvetica-Bold"
        amateurLabel.fontColor = .black
        amateurLabel.fontSize = 12
        amateurLabel.verticalAlignmentMode = .center
        amateurLabel.position = CGPoint(x: 0, y: 0)
        borderAmateur.addChild(amateurLabel)
        
        
        //INTERMEDIATE
        let interButton = SKSpriteNode(color: .white, size: CGSize(width: 90, height: 40))
        interButton.name = "interButton"
        interButton.position = CGPoint(x: frame.midX, y: frame.midY)
        interButton.zPosition = GameConstants.zPositions.hudZ
        addChild(interButton)
        
        let borderInter = SKShapeNode(rectOf: CGSize(width: 90+borderWidth, height: 40+borderWidth), cornerRadius: 2.0)
        borderInter.strokeColor = .black
        borderInter.lineWidth = borderWidth
        borderInter.fillColor = .clear
        borderInter.position = CGPoint(x: frame.midX, y: frame.midY)
        borderInter.zPosition = GameConstants.zPositions.hudZ + 0.1
        borderInter.isUserInteractionEnabled = false
        
        addChild(borderInter)
        
        let interLabel = SKLabelNode(text: "Intermediate")
        interLabel.fontName = "Helvetica-Bold"
        interLabel.fontColor = .black
        interLabel.fontSize = 12
        interLabel.verticalAlignmentMode = .center
        interLabel.position = CGPoint(x: 0, y: 0)
        borderInter.addChild(interLabel)
        
        
        //PROFESSIONAL
        let proButton = SKSpriteNode(color: .white, size: CGSize(width: 90, height: 40))
        proButton.name = "proButton"
        proButton.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        proButton.zPosition = GameConstants.zPositions.hudZ
        addChild(proButton)
        
        let borderPro = SKShapeNode(rectOf: CGSize(width: 90+borderWidth, height: 40+borderWidth), cornerRadius: 2.0)
        borderPro.strokeColor = .black
        borderPro.lineWidth = borderWidth
        borderPro.fillColor = .clear
        borderPro.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        borderPro.zPosition = GameConstants.zPositions.hudZ + 0.1
        borderPro.isUserInteractionEnabled = false
        
        addChild(borderPro)
        
        let proLabel = SKLabelNode(text: "Professional")
        proLabel.fontName = "Helvetica-Bold"
        proLabel.fontColor = .black
        proLabel.fontSize = 12
        proLabel.verticalAlignmentMode = .center
        proLabel.position = CGPoint(x: 0, y: 0)
        borderPro.addChild(proLabel)
        
        
        //ELITE
        let eliteButton = SKSpriteNode(color: .white, size: CGSize(width: 90, height: 40))
        eliteButton.name = "eliteButton"
        eliteButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        eliteButton.zPosition = GameConstants.zPositions.hudZ
        addChild(eliteButton)
        
        let borderElite = SKShapeNode(rectOf: CGSize(width: 90+borderWidth, height: 40+borderWidth), cornerRadius: 2.0)
        borderElite.strokeColor = .black
        borderElite.lineWidth = borderWidth
        borderElite.fillColor = .clear
        borderElite.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        borderElite.zPosition = GameConstants.zPositions.hudZ + 0.1
        borderElite.isUserInteractionEnabled = false
        
        addChild(borderElite)
        
        
        let eliteLabel = SKLabelNode(text: "Elite")
        eliteLabel.fontName = "Helvetica-Bold"
        eliteLabel.fontColor = .black
        eliteLabel.fontSize = 12
        eliteLabel.verticalAlignmentMode = .center
        eliteLabel.position = CGPoint(x: 0, y: 0)
        borderElite.addChild(eliteLabel)
        
    }
    
    func toJavelin(difficulty: Difficulty, strength: Double, skill: Double) {
        let transition = SKTransition.fade(withDuration: 1.0)
        let gameScene = JavelinScene(size: self.size, numberOfThrows: 0, previousThrows: [], difficulty: difficulty, strength: strength, skill: skill)
        view?.presentScene(gameScene, transition: transition)
    }

    func toHundred(difficulty: Difficulty, skill: Double, speed: Double) {
        let transition = SKTransition.fade(withDuration: 1.0)
        let gameScene = HundredScene(size: self.size, difficulty: difficulty, skill: skill, speed: speed)
        
        view?.presentScene(gameScene, transition: transition)
    }
    
    func navigate(difficulty: Difficulty) {
        if chosenEvent == "Hundred" {
            toHundred(difficulty: .beginner, skill: playerSkill, speed: playerSpeed)
        } else if chosenEvent == "Javelin" {
            toJavelin(difficulty: .beginner, strength: playerStrength, skill: playerSkill)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        let node = self.atPoint(location)
        
        print("\(node.name ?? "Nil") clicked")
        
        if node.name == "beginnerButton" {
            
//            if chosenEvent == "Hundred" {
//                toHundred(difficulty: .beginner, skill: playerSkill, speed: playerSpeed)
//            } else if chosenEvent == "Javelin" {
//                toJavelin(difficulty: .beginner, strength: playerStrength, skill: playerSkill)
//            }
            
            navigate(difficulty: .beginner)
            
        } else if node.name == "amateurButton" {
            
            navigate(difficulty: .amateur)
            
        } else if node.name == "interButton" {
            
            navigate(difficulty: .intermediate)
            
        } else if node.name == "proButton" {
            
            navigate(difficulty: .professional)
            
        } else if node.name == "eliteButton" {
            
            navigate(difficulty: .elite)
            
        }
    }
}

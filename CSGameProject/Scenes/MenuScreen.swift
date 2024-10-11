//
//  MenuScreen.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 11/10/2024.
//

import SpriteKit
import Foundation

class MenuScene: SKScene {
    
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
        
//        
//        let javelinButton = SKLabelNode(text: "Javelin (Coming Soon)")
//        javelinButton.fontSize = 30
//        javelinButton.fontColor = .gray
//        javelinButton.position = CGPoint(x: frame.midX, y: frame.midY - 50)
//        addChild(javelinButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == GameConstants.StringConstants.hundredLinker {
            
            let transition = SKTransition.fade(withDuration: 1.0)
            let gameScene = HundredScene(size: self.size)
            view?.presentScene(gameScene, transition: transition)
        }
    }
}

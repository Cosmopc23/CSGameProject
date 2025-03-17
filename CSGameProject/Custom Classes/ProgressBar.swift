//
//  ProgressBar.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 12/10/2024.
//

import SpriteKit

class ProgressBar: SKNode {
    var bar: SKSpriteNode
    var label: SKLabelNode
    let userDefaultsKey: String


    init(labelText: String, key: String) {
        self.userDefaultsKey = key
        

        self.bar = SKSpriteNode(color: .green, size: CGSize(width: 0, height: 20))
        self.label = SKLabelNode(text: labelText)

        super.init()


        // Background bar (gray container)
        let background = SKSpriteNode(color: .darkGray, size: CGSize(width: 200, height: 20))
        self.addChild(background)


        // Configure the progress indicator with left-aligned anchor point
        self.bar.anchorPoint = CGPoint(x: 0, y: 0)
        self.addChild(self.bar)


        self.label.fontSize = 14
        self.label.fontColor = .red
        self.label.position = CGPoint(x: 10, y: 0)
        self.addChild(self.label)


        // Load saved progress value from UserDefaults
        let initialValue = UserDefaults.standard.float(forKey: userDefaultsKey)
        self.updateProgress(to: CGFloat(initialValue))
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateProgress(to value: CGFloat) {
        // Clamp value between 0-100 and scale to width
        let clampedValue = max(0, min(100, value))
        let width = 200 * (clampedValue / 100)
        bar.size.width = width


        UserDefaults.standard.set(clampedValue, forKey: userDefaultsKey)
    }
}

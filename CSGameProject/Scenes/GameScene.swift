//
//  GameScene.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 07/09/2024.
//

import SpriteKit


enum GameState {
    case ready, ongoing, finished
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var worldLayer: Layer!
    var backgroundLayer: RepeatingLayer!
    var mapNode: SKNode!
    var tileMap: SKTileMapNode!
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    // running bar
    var progressBar: SKSpriteNode!
    var currentValue: CGFloat = 0.0
    var maxValue: CGFloat = 100.0
    var minValue: CGFloat = 40.0
    var decreaseRate: CGFloat = 4
    var timer: Timer?
    
    let targetMinValue: CGFloat = 60
    let targetMaxValue: CGFloat = 80
    
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
    
    var touch = false
    

    

    
    
    var characterSpeed: CGFloat = 0.0 {
        didSet{
            updateLayerVelocities()
        }
    }
    
    
    var gameState = GameState.ready {
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

    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -4)
        
        physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY), to: CGPoint(x: frame.maxX, y: frame.minY))
        physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.frameCategory
        physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.playerCategory
        
        createLayers()
        
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
        
        
    }
    
    func printSceneGraph(for node: SKNode, level: Int = 0) {
        let indent = String(repeating: "  ", count: level)
        let nodeName = node.name ?? "unnamed"
        print("\(indent)\(nodeName) (Position: \(node.position), zPosition: \(node.zPosition))")
        for child in node.children {
            printSceneGraph(for: child, level: level + 1)
        }
    }
    
    
    func createLayers() {
        worldLayer = Layer()
        worldLayer.zPosition = GameConstants.zPositions.worldZ
        
        addChild(worldLayer)
        worldLayer.layerVelocity =  CGPoint(x: -200.0, y: 0.0)
        
        backgroundLayer = RepeatingLayer()
        backgroundLayer.zPosition = GameConstants.zPositions.backgroundZ
        addChild(backgroundLayer)
        
        for i in 0...1 {
            let backgroundImage = SKSpriteNode(imageNamed: GameConstants.StringConstants.worldBackgroundName)
            backgroundImage.name = String(i)
            backgroundImage.scale(to: frame.size, width: false, multiplier: 1.0)
            backgroundImage.anchorPoint = CGPoint.zero
            backgroundImage.position = CGPoint(x: 0.0 + CGFloat(i) * backgroundImage.size.width, y: 0.0)
            backgroundLayer.addChild(backgroundImage)
        }
        
        backgroundLayer.layerVelocity = CGPoint(x: -75.0, y: 0.0)
        
        load(level: "100m")
    }
    
    func load(level: String) {
        if let levelNode = SKNode.unarchiveFromFile(file: level) {
            mapNode = levelNode
            worldLayer.addChild(mapNode)
            loadTileMap()
        }
    }
    
    func loadTileMap() {
        if let groundTiles = mapNode.childNode(withName: GameConstants.StringConstants.groundTilesName) as? SKTileMapNode {
            tileMap = groundTiles
            
            
            tileMap.scale(to: frame.size, width: false, multiplier: 1.0)
            
            PhysicsHelper.addPhysicsBody(to: tileMap, and: "ground")
            for child in groundTiles.children {
                if let sprite = child as? SKSpriteNode, sprite.name != nil {
                    ObjectHelper.handleChild(sprite: sprite, with: sprite.name!)
                }
            }
        }
        addPlayer()
        addCompetitor1()
        addCompetitor2()
        addCompetitor3()
    }
    
    
    
    
    // Adds player object by adding an idle image, scaling the size relative to the frame, adding a physics body, putting its initial position, loading the textures and setting the player state to idle so that the animation does not show the character running when it is not moving.
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
        
        print("player is hidden: \(player.isHidden)")
        
    }
    
    func addCompetitor1() {
        competitor1 = Competitor1(imageNamed: GameConstants.StringConstants.competitor1ImageName)
        competitor1.scale(to: frame.size, width: false, multiplier: 0.4)
        competitor1.name = GameConstants.StringConstants.competitor1Name
        PhysicsHelper.addPhysicsBody(to: competitor1, with: competitor1.name!)
        competitor1.position = CGPoint(x: frame.midX/2.0, y: frame.midY)
        competitor1.zPosition = GameConstants.zPositions.competitor1Z
        competitor1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
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
        
        var yOffSet: CGFloat = 100
        
        for (character,time) in sortedResults {
            let resultLabel = SKLabelNode(text: "\(character.capitalized): \(String(format: "%.2f", time)) seconds")
            resultLabel.fontSize = 24
            resultLabel.fontColor = .white
            resultLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 150 - yOffSet)
            resultLabel.zPosition = GameConstants.zPositions.topZ
            self.addChild(resultLabel)
            
            yOffSet -= 30
        }
        
        
        let restartButton = SKLabelNode(text: "Tap to Restart")
        restartButton.fontSize = 30
        restartButton.fontColor = .yellow
        restartButton.position = CGPoint(x: self.size.width / 2, y: 100)
        restartButton.zPosition = GameConstants.zPositions.topZ
        restartButton.name = "restartButton"
        self.addChild(restartButton)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        printSceneGraph(for: player)
//        printSceneGraph(for: competitor1)
        
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
            if nodeAtPoint.name == "restartButton"{
                restartRace()
            }
        }
//        printSceneGraph(for: player)
        
        
//        print("Current value: \(currentValue)")
        
        
    }
    
    func restartRace() {
        
        
        finishTimes.removeAll()
        finishers = 0
        gameState = .ready
        
        let transition = SKTransition.fade(withDuration: 1.0)
        let scene = GameScene(size: self.size)
        scene.scaleMode = .aspectFill
        self.view?.presentScene(scene, transition: transition)
        
        player.position = CGPoint(x: frame.midX / 2.0, y: frame.midY)
        competitor1.position = CGPoint(x: frame.midX / 2.0, y: frame.midY)
        competitor2.position = CGPoint(x: frame.midX / 2.0, y: frame.midY)
        competitor3.position = CGPoint(x: frame.midX / 2.0, y: frame.midY)
    }
    
    @objc func decreaseValue(){
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
    
    func adjustSpeed(){
        if currentValue == 0 {
            characterSpeed = 0
        } else if currentValue < targetMinValue/2 {
            characterSpeed = 16.0
        } else if currentValue < targetMinValue {
            characterSpeed = 40.0
        } else if currentValue > targetMaxValue {
            characterSpeed = 50.0
        } else {
            characterSpeed = 80.0
        }
    }
    
    func updateLayerVelocities(){
        let worldLayerSpeedFactor: CGFloat = 10.0
        let backgroundLayerSpeedFactor: CGFloat = 5
        
        worldLayer.layerVelocity = CGPoint(x: -characterSpeed * worldLayerSpeedFactor, y: 0.0)
        backgroundLayer.layerVelocity = CGPoint(x: -characterSpeed * backgroundLayerSpeedFactor, y: 0.0)
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
            
            let speedDifference1 = characterSpeed - competitor1.competitor1Speed
            competitor1.position.x -= speedDifference1 * CGFloat(deltaTime) * 3
            
            let speedDifference2 = characterSpeed - competitor2.competitor2Speed
            competitor2.position.x -= speedDifference2 * CGFloat(deltaTime) * 3
            
            let speedDifference3 = characterSpeed - competitor3.competitor3Speed
            competitor3.position.x -= speedDifference3 * CGFloat(deltaTime) * 3

        } else if gameState == .finished {
            backgroundLayer.layerVelocity = CGPoint(x: -75.0, y: 0.0)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
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
            finishTimes["Competitor 1"] = competitor1Time
            
            
            finishers += 1
            competitor1.competitor1Speed = 0
            competitor1.state = .idle
            print("Competitor1 Finish")
        }
        if (bodyA.categoryBitMask == GameConstants.PhysicsCategories.competitor2Category) && (bodyB.categoryBitMask == GameConstants.PhysicsCategories.finishCategory) || (bodyA.categoryBitMask == GameConstants.PhysicsCategories.finishCategory) &&  (bodyB.categoryBitMask == GameConstants.PhysicsCategories.competitor2Category) {
            
            let currentTime = CACurrentMediaTime()
            competitor2Time = raceStartTime - currentTime
            finishTimes["Competitor 2"] = competitor2Time
            
            
            finishers += 1
            competitor2.competitor2Speed = 0
            competitor2.state = .idle
            print("Competitor2 Finish")
        }
        if (bodyA.categoryBitMask == GameConstants.PhysicsCategories.competitor3Category) && (bodyB.categoryBitMask == GameConstants.PhysicsCategories.finishCategory) || (bodyA.categoryBitMask == GameConstants.PhysicsCategories.finishCategory) &&  (bodyB.categoryBitMask == GameConstants.PhysicsCategories.competitor3Category) {
            
            let currentTime = CACurrentMediaTime()
            competitor3Time = raceStartTime - currentTime
            finishTimes["Competitor 3"] = competitor3Time
            
            
            finishers += 1
            competitor3.competitor3Speed = 0
            competitor3.state = .idle
            print("Competitor3 Finish")
        }
        
        if finishers == 4 {
            print("Finish")
            handleFinish()
        }
    }
}

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
    
    var player: Player!
    var competitor1: Competitor1!
    
    var touch = false
    
    
    let targetMinValue: CGFloat = 60
    let targetMaxValue: CGFloat = 80
    
    var targetMinIndicator: SKSpriteNode!
    var targetMaxIndicator: SKSpriteNode!
    
    
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
            case .ongoing:
                player.state = .running
                competitor1.state = .running
            case .finished:
                player.state = .idle
                competitor1.state = .idle
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

    
    
    func handleFinish() {
        gameState = .finished
        print("End")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        printSceneGraph(for: player)
        printSceneGraph(for: competitor1)
        
        switch gameState {
        case .ready:
            gameState = .ongoing
        case .ongoing:
            touch = true
        default:
            break
        }
        currentValue += 8
        if currentValue > maxValue {
            currentValue = maxValue
        }
        updateProgressBar()
        printSceneGraph(for: player)
        
        
        print("Current value: \(currentValue)")
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
            characterSpeed = 16.0 + (currentValue - minValue) / (maxValue - minValue) * (80.0 - 16.0)
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
            
            let speedDifference = characterSpeed - competitor1.competitor1Speed
            competitor1.position.x -= speedDifference * CGFloat(deltaTime) * 3

        } else if gameState == .finished {
            backgroundLayer.layerVelocity = CGPoint(x: -75.0, y: 0.0)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask == GameConstants.PhysicsCategories.playerCategory) && (bodyB.categoryBitMask == GameConstants.PhysicsCategories.finishCategory) || (bodyA.categoryBitMask == GameConstants.PhysicsCategories.finishCategory) &&  (bodyB.categoryBitMask == GameConstants.PhysicsCategories.playerCategory) {
            handleFinish()
        }
    }
    
}

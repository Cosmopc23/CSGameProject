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
    
    // For scrolling selection areas
    var previousCoachTouchY: CGFloat?
    var previousSponsorTouchY: CGFloat?
    
    let xBuffer: CGFloat = 100
    let yBuffer: CGFloat = 30
    
    let outerLayer = SKNode()
    let trainingLayer = SKNode()
    let sponsorshipLayer = SKNode()
    let calendarLayer = SKNode()
    
    let borderWidth: CGFloat = 2.0
    
    let scrollableArea = SKSpriteNode(color: .lightGray, size: CGSize(width: 1000, height: 400))
    let coachesNode = SKNode()
    
    var currentCoach: Coach = coaches[0]
    
    let scrollableSponsors = SKSpriteNode(color: .lightGray, size: CGSize(width: 1000, height: 400))
    let sponsorsNode = SKNode()
    
    var currentSponsor: Sponsor = sponsors[0]
    
    
    var speedProgressBar: SKSpriteNode!
    var speedCurrentValue: Double = 10
    var maxValue: Double = 100
    
    var skillProgressBar: SKSpriteNode!
    var skillCurrentValue: Double = 10
    
    
    var strengthProgressBar: SKSpriteNode!
    var strengthCurrentValue: Double = 10
    
    var reputationProgressBar: SKSpriteNode!
    
    var reputationCurrentValue: Double = 0
    var reputationCurrentLevel: Int = 0
    
    var previousTouchPositionY: CGFloat? = CGFloat(0)
    
    
    let backgroundTexture: SKTexture? = SKTexture(imageNamed: "background")
    
    let playerTexture = SKTexture(imageNamed: GameConstants.StringConstants.playerImageName)
    
    var isFirstTime: Bool = false
    
    var playerName: String = "Player"

    var countryFlag: FlagNode!
    
    var playerCountry: String = "BR"
    
    
    var difficulty: Int = 1
    
    
    convenience init(size: CGSize, difficulty: Int) {
        self.init(size: size)
        self.difficulty = difficulty
    }
    
    
    override func didMove(to view: SKView) {
        // FOR TESTING
//        MenuScene.saveBankBalance(10000)
        
        let backgroundTexture = SKTexture(imageNamed: "background")
        let background = SKSpriteNode(texture: backgroundTexture)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.size
        background.zPosition = -100
        addChild(background)
        
        
//        if isFirstTime == false {
//            playerName = getPlayerName()
//            playerCountry = getPlayerCountry()
//        } else {
//            print("First Time")
//            setupStartScreen()
//        }
        
        playerCountry = "GB"
        
        addChild(outerLayer)
        
        setupOuterLayer()
        
        
        addChild(trainingLayer)
        addChild(sponsorshipLayer)
        addChild(calendarLayer)
        
        setupTrainingLayer()
        setupSponsorLayer()
        setupCalendarLayer()
        
        showLayer(calendarLayer)
        
        updateMenu()
        
    }
    

    
    func setupStartScreen() {
        let startScreen = SKSpriteNode(color: .black, size: CGSize(width: self.size.width, height: self.size.height))
        startScreen.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        startScreen.zPosition = GameConstants.zPositions.topZ + 1
        self.addChild(startScreen)
        
        let titleLabel = SKLabelNode(text: "Welcome")
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        titleLabel.fontColor = .yellow
        titleLabel.fontSize = 30
        titleLabel.zPosition = GameConstants.zPositions.topZ + 2
        self.addChild(titleLabel)
        
        
    }

    
    // Updates stats based on current coach
    func updateMenu(){
//        print(getCurrentCoachIndex()!)
        currentCoach = coaches[getCurrentCoachIndex() ?? 0]
        
        saveStat(currentCoach.speedBoost, key: GameConstants.Keys.speedKey)
        saveStat(currentCoach.skillBoost, key: GameConstants.Keys.skillKey)
        saveStat(currentCoach.strengthBoost, key: GameConstants.Keys.strengthKey)
        
        speedCurrentValue = MenuScene.getStat(key: GameConstants.Keys.speedKey)
        skillCurrentValue = MenuScene.getStat(key: GameConstants.Keys.skillKey)
        strengthCurrentValue = MenuScene.getStat(key: GameConstants.Keys.strengthKey)
        
        
        updateProgressbar(progressBar: speedProgressBar, currentValue: speedCurrentValue)
        updateProgressbar(progressBar: skillProgressBar, currentValue: skillCurrentValue)
        updateProgressbar(progressBar: strengthProgressBar, currentValue: strengthCurrentValue)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
    
        
        print("Touch began at: \(location)")
        print("scrollableSponsors frame: \(scrollableSponsors.frame)")
        print("scrollableSponsors position: \(scrollableSponsors.position)")
        print("Is scrollableSponsors hidden? \(scrollableSponsors.isHidden)")
        print("Is sponsorshipLayer hidden? \(sponsorshipLayer.isHidden)")
        
        
        let node = self.atPoint(location)
        
        // Store touch location for scrolling
        if scrollableArea.contains(location) {
            previousCoachTouchY = location.y
        }
        if scrollableSponsors.contains(location) {
            print("Touch detected within scrollableSponsors")
            previousSponsorTouchY = location.y
        }
        
        if node.name == GameConstants.StringConstants.hundredLinker {
            let transition = SKTransition.fade(withDuration: 1.0)
            // let gameScene = HundredScene(size: self.size, difficulty: .elite, skill: skillCurrentValue, speed: speedCurrentValue)
            let gameScene = DifficultySelector(size: self.size, event: "Hundred", skill: skillCurrentValue, strength: strengthCurrentValue, speed: speedCurrentValue)
            view?.presentScene(gameScene, transition: transition)
        } else if node.name == GameConstants.StringConstants.javelinLinker {
            let transition = SKTransition.fade(withDuration: 1.0)
//            let gameScene = JavelinScene(size: self.size, numberOfThrows: 0, previousThrows: [], difficulty: .intermediate, strength: strengthCurrentValue, skill: skillCurrentValue)
            let gameScene = DifficultySelector(size: self.size, event: "Javelin", skill: skillCurrentValue, strength: strengthCurrentValue, speed: speedCurrentValue)
            view?.presentScene(gameScene, transition: transition)
        } else if node.name == "trainingButton" {
            showLayer(trainingLayer)
        } else if node.name == "sponsorshipButton" {
            showLayer(sponsorshipLayer)
        } else if node.name == "calendarButton" {
            showLayer(calendarLayer)
        } else if node.name == "coachDetailNode" {
            // Delay to prevent accidental clicks
            isUserInteractionEnabled = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.scrollableArea.isHidden = false
                self.isUserInteractionEnabled = true
            }
            print("Coach button hit")
            
        } else if node.name == "sponsorDetailNode" {
            // Delay to prevent accidental clicks
            isUserInteractionEnabled = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.scrollableSponsors.isHidden = false
                self.isUserInteractionEnabled = true
            }
            print("Sponsor button hit")
            
        } else if node.name == "BackCoach" {
            scrollableArea.isHidden = true
        } else if node.name == "BackSponsor" {
            scrollableSponsors.isHidden = true
        } else if let name = node.name, coaches.contains(where: { $0.name == name }) {
            // Handle coach selection
            var i = 0
            for coach in coaches {
                if coach.name == node.name {
                    showAlertForCoach(coach: coach) { confirmed in
                        if confirmed {
                            if MenuScene.transaction(amount: coach.price) {
                                self.newCoach(oldCoach: self.currentCoach, newCoach: coach)
                                self.saveCurrentCoachIndex(i)
                                
                                let transition = SKTransition.fade(withDuration: 0.3)
                                let scene = MenuScene(size: self.size)
                                scene.scaleMode = .aspectFill
                                self.view?.presentScene(scene, transition: transition)
                                
                                self.updateMenu()
                            } else {
                                let alert = UIAlertController(
                                    title: "Insufficient Funds",
                                    message: "You do not have enough money to make this transaction",
                                    preferredStyle: .alert
                                )
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                
                                
                                if let viewController = self.view?.window?.rootViewController {
                                    viewController.present(alert, animated: true, completion: nil)
                                    self.scrollableArea.isHidden = true
                                    
                                }
                            }
                        }
                    }
                    updateMenu()
                    break
                }
                i += 1
            }
        } else if let name = node.name, sponsors.contains(where: { $0.name == name }) {
            // Handle sponsor selection
            var i = 0
            for sponsor in sponsors {
                if sponsor.name == node.name {
                    showAlertForSponsor(sponsor: sponsor) { confirmed in
                        if confirmed {
                            if MenuScene.checkReputationLevel(newReputation: sponsor.reputationRequirement) {
                                self.saveCurrentSponsorIndex(i)
                                
                                let transition = SKTransition.fade(withDuration: 0.3)
                                let scene = MenuScene(size: self.size)
                                scene.scaleMode = .aspectFill
                                self.view?.presentScene(scene, transition: transition)
                                
                                self.updateMenu()
                            } else {
                                let alert = UIAlertController(title: "Insufficient Reputation", message: "Your reputation is too low for this sponsor", preferredStyle: .alert
                                )
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                
                                
                                if let viewController = self.view?.window?.rootViewController {
                                    viewController.present(alert, animated: true, completion: nil)
                                    self.scrollableSponsors.isHidden = true
                                    
                                }
                                
                            }
                        }
                    }
                    updateMenu()
                    break
                }
                i += 1
            }
        }
    }
   
    // Handle scrolling for coach and sponsor lists
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        

        if scrollableArea.contains(touchLocation), let previousY = previousCoachTouchY {
            let deltaY = touchLocation.y - previousY
            print("COACHES before move: \(coachesNode.position.y)")
            coachesNode.position.y += deltaY
            print("COACHES after move: \(coachesNode.position.y)")
            previousCoachTouchY = touchLocation.y
        }
        if scrollableSponsors.contains(touchLocation), let previousY = previousSponsorTouchY {
            let deltaY = touchLocation.y - previousY
            print("SPONSORS before move: \(sponsorsNode.position.y)")
            sponsorsNode.position.y += deltaY
            print("SPONSORS after move: \(sponsorsNode.position.y)")
            previousSponsorTouchY = touchLocation.y
        }
    }
    
    func showAlertForCoach(coach: Coach, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Confirm Coach",
                                      message: "Do you want to hire \(coach.name) for \(coach.price) currency?",
                                      preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Yes", style: .default) { _ in
            completion(true)
        }

        let cancelAction = UIAlertAction(title: "No", style: .cancel) { _ in
            completion(false)
        };

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        if let viewController = self.scene?.view?.window?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertForSponsor(sponsor: Sponsor, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Confirm Sponsor", message: "Do you want to accept \(sponsor.name)'s offer?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { _ in
            completion(true)
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { _ in
            completion(false)
        };
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        if let viewController = self.scene?.view?.window?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func getPlayerName() -> String {
        return UserDefaults.standard.string(forKey: GameConstants.Keys.playerNameKey) ?? "Player (nil)"
    }
    
    func savePlayerName(name: String) {
        UserDefaults.standard.set(name, forKey: GameConstants.Keys.playerNameKey)
    }
    
    func getFirstTime() -> Bool {
        return UserDefaults.standard.bool(forKey: GameConstants.Keys.isFirstTimeKey)
    }
    
    func saveFirstTime(currentTimeValue: Bool) {
        UserDefaults.standard.set(currentTimeValue, forKey: GameConstants.Keys.isFirstTimeKey)
    }
    
    func savePlayerCountry(_ country: String) {
        UserDefaults.standard.set(country, forKey: GameConstants.Keys.countryKey)
    }

    func getPlayerCountry() -> String {
        return UserDefaults.standard.string(forKey: GameConstants.Keys.countryKey) ?? "GB"
    }

    
    func setupOuterLayer() {
        
        let playerSprite = SKSpriteNode(texture: playerTexture)
        playerSprite.position = CGPoint(x: frame.minX + xBuffer, y: frame.maxY - yBuffer * 5)
        playerSprite.size = CGSize(width: 150, height: 150)
        playerSprite.zPosition = GameConstants.zPositions.topZ
        outerLayer.addChild(playerSprite)
        
        let name = getPlayerName()
        let nameLabel = SKLabelNode(text: "\(name)")
        nameLabel.position = CGPoint(x: frame.minX + xBuffer, y: frame.maxY - yBuffer * 15/2)
        nameLabel.fontSize = 12
        nameLabel.fontName = "Helvetica-Bold"
        nameLabel.fontColor = .white
        outerLayer.addChild(nameLabel)
        
        speedProgressBar = SKSpriteNode(color: .blue, size: CGSize(width: 150, height: 15))
        
        skillProgressBar = SKSpriteNode(color: .blue, size: CGSize(width: 150, height: 15))
        
        strengthProgressBar = SKSpriteNode(color: .blue, size: CGSize(width: 150, height: 15))
        
        reputationProgressBar = SKSpriteNode(color: .yellow, size: CGSize(width: 150, height: 15))
        
        backgroundColor = .white
        
        let olympicGold = UIColor(red: 227/255, green: 192/255, blue: 66/255, alpha: 1.0)

        
        let titleLabel = SKLabelNode(text: "OLYMPUS")
        titleLabel.fontName = "Helvetica-Bold"
        titleLabel.fontSize = 40
        titleLabel.fontColor = olympicGold
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 150)
        outerLayer.addChild(titleLabel)
    
        
        let balanceLabel = SKLabelNode(text: "Balance: \(MenuScene.getBankBalance()) ")
        balanceLabel.fontName = "Helvetica-Bold"
        balanceLabel.fontSize = 15
        balanceLabel.fontColor = .white
        balanceLabel.zPosition = GameConstants.zPositions.topZ + 100
        balanceLabel.position = CGPoint(x: frame.minX + xBuffer, y: frame.maxY - yBuffer)
        
        outerLayer.addChild(balanceLabel)
        
        addLabel(label: "Speed", positionX: (frame.midX/4.0) - 40, positionY: ((frame.midY/3.0) + yBuffer - 5))
        addLabel(label: "Skill", positionX: (frame.midX/4.0) - 40, positionY: (frame.midY/3.0) - 5)
        addLabel(label: "Strength", positionX: (frame.midX/4.0) - 40, positionY: ((frame.midY/3.0) - yBuffer - 5))
        addLabel(label: "Reputation", positionX: (frame.midX/4.0) - 45, positionY: ((frame.midY/3.0) + (2 * yBuffer) - 5))
        
        
        speedCurrentValue = MenuScene.getStat(key: GameConstants.Keys.speedKey)
        skillCurrentValue = MenuScene.getStat(key: GameConstants.Keys.skillKey)
        strengthCurrentValue = MenuScene.getStat(key: GameConstants.Keys.skillKey)
        
        reputationCurrentValue = MenuScene.getReputationBar()
        reputationCurrentLevel = MenuScene.getReputationLevel()
        
        
        addProgressBar(progressBar: speedProgressBar, positionX: (frame.midX/4.0), positionY: (frame.midY/3.0) + yBuffer)
        addProgressBar(progressBar: skillProgressBar, positionX: frame.midX/4.0, positionY: (frame.midY/3.0))
        addProgressBar(progressBar: strengthProgressBar, positionX: frame.midX/4.0, positionY: ((frame.midY/3.0) - yBuffer))
        
        addProgressBar(progressBar: reputationProgressBar, positionX: frame.midX/4.0, positionY: ((frame.midY/3.0) + (2 * yBuffer)))
        
        addLabel(label: "\(MenuScene.getReputationLevel())", positionX: frame.midX/4.0 + 75, positionY: ((frame.midY/3.0) + (2 * yBuffer) - 6))
        
        updateProgressbar(progressBar: speedProgressBar, currentValue: speedCurrentValue)
        updateProgressbar(progressBar: skillProgressBar, currentValue: skillCurrentValue)
        updateProgressbar(progressBar: strengthProgressBar, currentValue: strengthCurrentValue)
        updateProgressbar(progressBar: reputationProgressBar, currentValue: reputationCurrentValue)
        
        
        
        
        // training, sponsorship and calendar buttons
        
        let trainingButton = SKSpriteNode(color: .white, size: CGSize(width: 90, height: 40))
        trainingButton.name = "trainingButton"
        trainingButton.position = CGPoint(x: frame.midX-60, y: frame.midY/4.0)
        trainingButton.zPosition = GameConstants.zPositions.hudZ
        outerLayer.addChild(trainingButton)
        
        let border1 = SKShapeNode(rectOf: CGSize(width: 90+borderWidth, height: 40+borderWidth), cornerRadius: 2.0)
        border1.strokeColor = .black
        border1.lineWidth = borderWidth
        border1.fillColor = .clear
        border1.position = CGPoint(x: frame.midX-60, y: frame.midY/4.0)
        border1.zPosition = GameConstants.zPositions.hudZ - 0.1
        
        outerLayer.addChild(border1)
        
        
        let sponsorshipButton = SKSpriteNode(color: .white, size: CGSize(width: 90, height: 40))
        sponsorshipButton.name = "sponsorshipButton"
        sponsorshipButton.position = CGPoint(x: frame.midX + 60, y: frame.midY/4.0)
        sponsorshipButton.zPosition = GameConstants.zPositions.hudZ
        outerLayer.addChild(sponsorshipButton)
        
        let border2 = SKShapeNode(rectOf: CGSize(width: 90+borderWidth, height: 40+borderWidth), cornerRadius: 2.0)
        border2.strokeColor = .black
        border2.lineWidth = borderWidth
        border2.fillColor = .clear
        border2.position = CGPoint(x: frame.midX + 60, y: frame.midY/4.0)
        border2.zPosition = GameConstants.zPositions.hudZ - 0.1
        
        outerLayer.addChild(border2)
        
        let calendarButton = SKShapeNode(circleOfRadius: 45)
        calendarButton.name = "calendarButton"
        calendarButton.position = CGPoint(x: frame.midX + 320, y: frame.midY/3.0)
        calendarButton.zPosition = GameConstants.zPositions.hudZ
        calendarButton.fillColor = olympicGold
        calendarButton.strokeColor = .black
        calendarButton.lineWidth = borderWidth
        outerLayer.addChild(calendarButton)
        
        
        //labels for buttons
        let trainingLabel = SKLabelNode(text: "Training")
        trainingLabel.fontName = "Helvetica-Bold"
        trainingLabel.fontColor = .black
        trainingLabel.fontSize = 12
        trainingLabel.verticalAlignmentMode = .center
        trainingLabel.position = CGPoint(x: 0, y: 0)
        trainingButton.addChild(trainingLabel)
        
        let sponsorshipLabel = SKLabelNode(text: "Sponsorships")
        sponsorshipLabel.fontName = "Helvetica-Bold"
        sponsorshipLabel.fontColor = .black
        sponsorshipLabel.fontSize = 12
        sponsorshipLabel.verticalAlignmentMode = .center
        sponsorshipLabel.position = CGPoint(x: 0, y: 0)
        sponsorshipButton.addChild(sponsorshipLabel)
        
        let calendarLabel = SKLabelNode(text: "Continue")
        calendarLabel.fontName = "Helvetica-Bold"
        calendarLabel.fontColor = .black
        calendarLabel.fontSize = 12
        calendarLabel.verticalAlignmentMode = .center
        calendarLabel.position = CGPoint(x: 0, y: 0)
        calendarButton.addChild(calendarLabel)
        
        let flagSize = CGSize(width: 100, height: 60)
        countryFlag = FlagNode(country: playerCountry, size: flagSize)
        countryFlag.position = CGPoint(x: frame.minX + xBuffer/2, y: frame.maxY - yBuffer * 5)
        countryFlag.zPosition = GameConstants.zPositions.hudZ
        outerLayer.addChild(countryFlag)
        
    }
    
    func setupTrainingLayer () {
        trainingLayer.name = "TrainingLayer"

        trainingLayer.zPosition = GameConstants.zPositions.topZ
        
        setupCurrentCoachNode()
    }
    
    func setupSponsorLayer () {
        sponsorshipLayer.name = "SponsorshipLayer"
        sponsorshipLayer.zPosition = GameConstants.zPositions.topZ
        
        setupCurrentSponsorNode()
    }
    
    func setupCalendarLayer () {
        calendarLayer.name = "CalendarLayer"
        let startButton = SKLabelNode(text: "Start 100m Race")
        startButton.fontSize = 30
        startButton.fontName = "Helvetica-Bold"
        startButton.fontColor = .white
        startButton.position = CGPoint(x: frame.midX, y: frame.midY)
        startButton.name = GameConstants.StringConstants.hundredLinker
        calendarLayer.addChild(startButton)
        
        
        let javelinButton = SKLabelNode(text: "Start Javelin")
        javelinButton.fontSize = 30
        javelinButton.fontName = "Helvetica-Bold"
        javelinButton.fontColor = .white
        javelinButton.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        javelinButton.name = GameConstants.StringConstants.javelinLinker
        calendarLayer.addChild(javelinButton)
    }
    
    // Toggle between different menu layers
    func showLayer(_ layer: SKNode) {
        trainingLayer.isHidden = true
        sponsorshipLayer.isHidden = true
        calendarLayer.isHidden = true
        
        layer.isHidden = false
        
        print("\(layer.name ?? "Layer") is now visible")
//        print("\(trainingLayer.isHidden) ")
//        print("trainingLayer frame: \(trainingLayer.frame)")
    }
    
    func setupCurrentCoachNode() {
        if (getCurrentCoachIndex() ?? 0) > 26 {
            saveCurrentCoachIndex(0)
        }
        currentCoach = coaches[getCurrentCoachIndex() ?? 0]
        
        
        let borderCoach = SKShapeNode(rectOf: CGSize(width: 130+borderWidth, height: 60+borderWidth), cornerRadius: 2.0)
        borderCoach.strokeColor = .black
        borderCoach.lineWidth = borderWidth
        borderCoach.fillColor = .white
        borderCoach.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        borderCoach.zPosition = GameConstants.zPositions.hudZ - 0.1
        borderCoach.name = "coachDetailNode"
        trainingLayer.addChild(borderCoach)
        
        let coachText = "\(currentCoach.name)\n Speed Boost: \(currentCoach.speedBoost)\n Skill Boost: \(currentCoach.skillBoost) \n StrengthBoost: \(currentCoach.strengthBoost)"
        let coachDetailNode = createMultilineLabel(text: coachText, fontSize: 12, position: CGPoint(x: frame.midX, y: frame.midY + 65))
        coachDetailNode.zPosition = GameConstants.zPositions.hudZ
        coachDetailNode.isUserInteractionEnabled = false
        trainingLayer.addChild(coachDetailNode)
        
        
        setupScrollableArea()
    }
    
    func setupCurrentSponsorNode() {
        if (getCurrentSponsorIndex() ?? 0) > 26 {
            saveCurrentSponsorIndex(0)
        }
        currentSponsor = sponsors[getCurrentSponsorIndex() ?? 0]
        
        
        let borderSponsor = SKShapeNode(rectOf: CGSize(width: 150+borderWidth, height: 60+borderWidth), cornerRadius: 2.0)
        borderSponsor.lineWidth = borderWidth
        borderSponsor.fillColor = .white
        borderSponsor.strokeColor = .black
        borderSponsor.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        borderSponsor.zPosition = GameConstants.zPositions.hudZ - 0.1
        borderSponsor.name = "sponsorDetailNode"
        sponsorshipLayer.addChild(borderSponsor)
        
        let sponsorText = "\(currentSponsor.name)\n Reputation Required: \(currentSponsor.reputationRequirement)\n Contract Length: \(currentSponsor.lengthOfContract)\n Reward Multiplier: \(currentSponsor.rewardMultiplier)"
        let sponsorDetailNode = createMultilineLabel(text: sponsorText, fontSize: 12, position: CGPoint(x: frame.midX, y: frame.midY + 65))
        sponsorDetailNode.zPosition = GameConstants.zPositions.hudZ
        sponsorDetailNode.isUserInteractionEnabled = false
        sponsorshipLayer.addChild(sponsorDetailNode)
        
        setupScrollableSponsors()
    }
    
    // Set up scrollable coach selection area
    func setupScrollableArea() {
        scrollableArea.position = CGPoint(x: frame.midX, y: frame.midY)
        scrollableArea.isHidden = true
        scrollableArea.zPosition = GameConstants.zPositions.topZ
        trainingLayer.addChild(scrollableArea)
        
        coachesNode.position = CGPoint(x: 0, y: -scrollableArea.size.height / 2)
        scrollableArea.addChild(coachesNode)
        
        var yOffset = 10.0
        for coach in coaches {
            let coachNode = SKLabelNode(text: "\(coach.name): Price: \(coach.price), Speed: \(coach.speedBoost), Skill: \(coach.skillBoost), Strength: \(coach.strengthBoost)")
            coachNode.zPosition = GameConstants.zPositions.topZ + 0.1
            coachNode.position = CGPoint(x: frame.minX + 20, y: frame.maxY - yOffset)
            coachNode.fontSize = 15
            coachNode.fontName = "Helvetica-Bold"
            coachesNode.addChild(coachNode)
            
            let border = SKShapeNode(rectOf: CGSize(width: (frame.maxX - 330)+borderWidth, height: 20+borderWidth), cornerRadius: 2.0)
            border.strokeColor = .black
            border.lineWidth = borderWidth
            border.fillColor = .clear
            border.position = CGPoint(x: frame.minX + 30, y: frame.maxY - yOffset + 3)
            border.zPosition = GameConstants.zPositions.topZ + 0.2
            border.name = coach.name
            coachesNode.addChild(border)
            yOffset -= 40
                       
                       coachesNode.position.y = -CGFloat(coaches.count * 40) / 2
                   }
                   
                   makeBackButton(name: "BackCoach", parent: scrollableArea, sizeW: 90, sizeH: 40, posX: frame.minX - 300, posY: frame.midY - 300)
               }
        
    // Create a back button for selection screens
    func makeBackButton(name: String, parent: SKSpriteNode, sizeW: Int, sizeH: Int, posX: CGFloat, posY: CGFloat) {
       let backButton = SKSpriteNode(color: .white, size: CGSize(width: sizeW, height: sizeH))
       backButton.name = name
       backButton.position = CGPoint(x: posX, y: posY)
       backButton.zPosition = GameConstants.zPositions.hudZ + 0.1
       parent.addChild(backButton)
       
       let border = SKShapeNode(rectOf: CGSize(width: sizeW, height: sizeH), cornerRadius: 2.0)
       border.strokeColor = .black
       border.lineWidth = borderWidth
       border.fillColor = .clear
       border.position = CGPoint(x: posX, y: posY)
       border.zPosition = GameConstants.zPositions.hudZ - 0.1
       parent.addChild(border)
       
       let backLabel = SKLabelNode(text: "Back")
       backLabel.fontName = "Helvetica-Bold"
       backLabel.fontColor = .black
       backLabel.fontSize = 12
       backLabel.verticalAlignmentMode = .center
       backLabel.position = CGPoint(x: posX, y: posY)
       backLabel.zPosition = GameConstants.zPositions.hudZ + 0.2
       parent.addChild(backLabel)
    }
               
       // Set up scrollable sponsor selection area
       func setupScrollableSponsors() {
           scrollableSponsors.position = CGPoint(x: frame.midX, y: frame.midY)
           scrollableSponsors.isHidden = true
           scrollableSponsors.zPosition = GameConstants.zPositions.topZ
           sponsorshipLayer.addChild(scrollableSponsors)
           
           sponsorsNode.position = CGPoint(x: 0, y: -scrollableSponsors.size.height / 2)
           scrollableSponsors.addChild(sponsorsNode)
           
           var yOffset = 10.0
           for sponsor in sponsors {
               let sponsorNode = SKLabelNode(text: "\(sponsor.name): Reputation Required: \(sponsor.reputationRequirement), Contract Length: \(sponsor.lengthOfContract), Reward Multiplier: \(sponsor.rewardMultiplier)")
               sponsorNode.zPosition = GameConstants.zPositions.topZ + 0.1
               sponsorNode.position = CGPoint(x: frame.minX + 10, y: frame.maxY - yOffset)
               sponsorNode.fontSize = 15
               sponsorNode.fontName = "Helvetica-Bold"
               sponsorsNode.addChild(sponsorNode)
               
               let border = SKShapeNode(rectOf: CGSize(width: (frame.maxX - 180)+borderWidth, height: 20+borderWidth), cornerRadius: 2.0)
               border.strokeColor = .black
               border.lineWidth = borderWidth
               border.fillColor = .clear
               border.position = CGPoint(x: frame.minX + 30, y: frame.maxY - yOffset + 3)
               border.zPosition = GameConstants.zPositions.topZ + 0.2
               border.name = sponsor.name
               sponsorsNode.addChild(border)
               
               yOffset -= 40
               
               sponsorsNode.position.y = -CGFloat(sponsors.count * 40) / 2
           }
           
           makeBackButton(name: "BackSponsor", parent: scrollableSponsors, sizeW: 90, sizeH: 40, posX: frame.minX - 350, posY: frame.midY - 300)
       }
       
       // Create multi-line text from a string with newlines
       func createMultilineLabel(text: String, fontSize: CGFloat, position: CGPoint) -> SKNode {
           let lines = text.components(separatedBy: "\n")
           let labelNode = SKNode()

           for (index, line) in lines.enumerated() {
               let lineNode = SKLabelNode(text: line)
               lineNode.fontSize = fontSize
               lineNode.fontColor = .black
               lineNode.fontName = "Helvetica-Bold"
               lineNode.position = CGPoint(x: 0, y: -CGFloat(index) * fontSize - 1)
               labelNode.addChild(lineNode)
           }

           labelNode.position = position
           return labelNode
       }

       
       static func saveBankBalance(_ balance: Double) {
           UserDefaults.standard.set(balance, forKey: GameConstants.Keys.bankBalanceKey)
       }
       
       static func getBankBalance() -> Double {
           return UserDefaults.standard.double(forKey: GameConstants.Keys.bankBalanceKey)
       }
       
       static func increaseReputationLevel() {
           var currentReputationLevel = getReputationLevel()
           currentReputationLevel += 1
           UserDefaults.standard.set(currentReputationLevel, forKey: GameConstants.Keys.reputationKey)
       }
       
       static func getReputationLevel() -> Int {
           return UserDefaults.standard.integer(forKey: GameConstants.Keys.reputationKey)
       }
       
       // Handle reputation bar increase with level up
       static func increaseReputationBar(_ amount: Double) {
           let currentReputationBar = getReputationBar()
           
           var newReputation: Double = 0
           if currentReputationBar + amount < 100 {
               newReputation = currentReputationBar + amount
           } else {
               increaseReputationLevel()
               newReputation = (currentReputationBar + amount) - 100
           }
           UserDefaults.standard.set(newReputation, forKey: GameConstants.Keys.reputationBarKey)
       }
       
       static func getReputationBar() -> Double {
           return UserDefaults.standard.double(forKey: GameConstants.Keys.reputationBarKey)
       }
       
       static func reward(amount: Double) {
           var currentBalance = getBankBalance()
           currentBalance += amount
           saveBankBalance(currentBalance)
       }
       
       // Process money transactions with balance check
       static func transaction(amount: Double) -> Bool {
           var currentBalance = getBankBalance()
           if amount <= currentBalance {
               currentBalance -= amount
               saveBankBalance(currentBalance)
               print(getBankBalance())
               return true
           } else {
               return false
           }
       }
       
       // Check if player's reputation level meets requirement
       static func checkReputationLevel(newReputation: Int) -> Bool {
           let currentReputation = getReputationLevel()
           if newReputation <= currentReputation {
               return true
           } else {
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
       
       static func getStat(key: String) -> Double {
           return UserDefaults.standard.double(forKey: key)
       }
       
       func changeStat(amount: Double, key: String) {
           var currentValue = MenuScene.getStat(key: key)
           currentValue += amount
           saveStat(currentValue, key: key)
       }
       
       // Update stats when changing coaches
       func newCoach(oldCoach: Coach, newCoach: Coach) {
           let currentSpeedStat = MenuScene.getStat(key: GameConstants.Keys.speedKey) - oldCoach.speedBoost
           let currentSkillStat = MenuScene.getStat(key: GameConstants.Keys.skillKey) - oldCoach.skillBoost
           let currentStrengthStat = MenuScene.getStat(key: GameConstants.Keys.strengthKey) - oldCoach.strengthBoost
           
           let newSpeedStat = currentSpeedStat + newCoach.speedBoost
           let newSkillStat = currentSkillStat + newCoach.skillBoost
           let newStrengthStat = currentStrengthStat + newCoach.strengthBoost
           
           saveStat(newSpeedStat, key: GameConstants.Keys.speedKey)
           saveStat(newSkillStat, key: GameConstants.Keys.skillKey)
           saveStat(newStrengthStat, key: GameConstants.Keys.strengthKey)
       }
       
       func saveCurrentCoachIndex(_ index: Int) {
           UserDefaults.standard.set(index, forKey: GameConstants.Keys.coachKey)
       }
       
       func getCurrentCoachIndex() -> Int? {
           return UserDefaults.standard.value(forKey: GameConstants.Keys.coachKey) as? Int
       }
       
       func saveCurrentSponsorIndex(_ index: Int) {
           UserDefaults.standard.set(index, forKey: GameConstants.Keys.sponsorKey)
       }
       
       func getCurrentSponsorIndex() -> Int? {
           return UserDefaults.standard.value(forKey: GameConstants.Keys.sponsorKey) as? Int
       }

       
       func addProgressBar(progressBar: SKSpriteNode, positionX: CGFloat, positionY: CGFloat) {
           progressBar.position = CGPoint(x: positionX, y: positionY)
           progressBar.zPosition = GameConstants.zPositions.hudZ
           progressBar.anchorPoint = CGPoint(x: 0, y: 0.5)
           outerLayer.addChild(progressBar)
           
           let borderWidth: CGFloat = 2.0
           let border = SKShapeNode(rectOf: CGSize(width: 150 + borderWidth, height: 15 + borderWidth), cornerRadius: 2.0)
           border.strokeColor = .black
           border.lineWidth = borderWidth
           border.fillColor = .clear
           border.position = CGPoint(x: positionX + progressBar.size.width/2, y: positionY)
           border.zPosition = GameConstants.zPositions.hudZ - 0.1
           
           outerLayer.addChild(border)
       }
       
       func addLabel(label: String, positionX: CGFloat, positionY: CGFloat) {
           let finishedLabel = SKLabelNode(text: label)
           finishedLabel.fontName = "Helvetica-Bold"
           finishedLabel.fontSize = 15
           finishedLabel.fontColor = .white
           finishedLabel.position = CGPoint(x: positionX, y: positionY)
           finishedLabel.zPosition = GameConstants.zPositions.topZ
           
           
           outerLayer.addChild(finishedLabel)
       }
       
       // Get current sponsor's reward multiplier
       static func getCurrentSponsorMultiplier() -> Double {
           let sponsorIndex = UserDefaults.standard.integer(forKey: GameConstants.Keys.sponsorKey)
           return sponsors[sponsorIndex].rewardMultiplier
       }
    }

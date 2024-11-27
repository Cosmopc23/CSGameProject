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
    
    var previousCoachTouchY: CGFloat?
    var previousSponsorTouchY: CGFloat?
    
    let xBuffer: CGFloat = 100
    let yBuffer: CGFloat = 30
    
    let outerLayer = SKNode()
    let trainingLayer = SKNode()
    let sponsorshipLayer = SKNode()
    let calendarLayer = SKNode()
    let tier1Layer = SKNode()
    let tier2Layer = SKNode()
    let tier3Layer = SKNode()
    let tier4Layer = SKNode()
    let tier5Layer = SKNode()
    let tier6Layer = SKNode()
    let tier7Layer = SKNode()
    
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
    
    var reputationCurrentValue: Double = 0
    
    var previousTouchPositionY: CGFloat? = CGFloat(0)
    
    
    override func didMove(to view: SKView) {
//        MenuScene.saveBankBalance(10000)
        
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
    
    func updateMenu(){
//        print(getCurrentCoachIndex()!)
        currentCoach = coaches[getCurrentCoachIndex() ?? 0]
        
        saveStat(currentCoach.speedBoost, key: GameConstants.Keys.speedKey)
        saveStat(currentCoach.skillBoost, key: GameConstants.Keys.skillKey)
        saveStat(currentCoach.strengthBoost, key: GameConstants.Keys.strengthKey)
        saveReputation(GameConstants.Keys.reputationKey)
        
        speedCurrentValue = getStat(key: GameConstants.Keys.speedKey)
        skillCurrentValue = getStat(key: GameConstants.Keys.skillKey)
        strengthCurrentValue = getStat(key: GameConstants.Keys.strengthKey)
        
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
        
        if scrollableArea.contains(location) {
            previousCoachTouchY = location.y
        }
        if scrollableSponsors.contains(location) {
            print("Touch detected within scrollableSponsors")
            previousSponsorTouchY = location.y
        }
        
        if node.name == GameConstants.StringConstants.hundredLinker {
            let transition = SKTransition.fade(withDuration: 1.0)
            let gameScene = HundredScene(size: self.size)
            view?.presentScene(gameScene, transition: transition)
        } else if node.name == GameConstants.StringConstants.javelinLinker {
            let transition = SKTransition.fade(withDuration: 1.0)
            let gameScene = JavelinScene(size: self.size)
            view?.presentScene(gameScene, transition: transition)
        } else if node.name == "trainingButton" {
            showLayer(trainingLayer)
        } else if node.name == "sponsorshipButton" {
            showLayer(sponsorshipLayer)
        } else if node.name == "calendarButton" {
            showLayer(calendarLayer)
        } else if node.name == "coachDetailNode" {
            isUserInteractionEnabled = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.scrollableArea.isHidden = false
                self.isUserInteractionEnabled = true
            }
            print("Coach button hit")
            
        } else if node.name == "sponsorDetailNode" {
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
            var i = 0
            for coach in coaches {
                if coach.name == node.name {
                    showAlertForCoach(coach: coach) { confirmed in
                        if confirmed {
                            if MenuScene.transaction(amount: coach.price) {
                                self.newCoach(oldCoach: self.currentCoach, newCoach: coach)
                                self.saveCurrentCoachIndex(i)
                                self.scrollableArea.isHidden = true
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
            var i = 0
            for sponsor in sponsors {
                if sponsor.name == node.name {
                    showAlertForSponsor(sponsor: sponsor) { confirmed in
                        if confirmed {
                            if MenuScene.checkReputation(newReputation: sponsor.reputationRequirement) {
                                self.saveCurrentSponsorIndex(i)
                                self.scrollableSponsors.isHidden = true
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

    
    func setupOuterLayer() {
        
        speedProgressBar = SKSpriteNode(color: .blue, size: CGSize(width: 150, height: 15))
        
        skillProgressBar = SKSpriteNode(color: .blue, size: CGSize(width: 150, height: 15))
        
        strengthProgressBar = SKSpriteNode(color: .blue, size: CGSize(width: 150, height: 15))
        
        backgroundColor = .white
        
        let titleLabel = SKLabelNode(text: "Olympics Game")
        titleLabel.fontName = "Helvetica-Bold"
        titleLabel.fontSize = 40
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 150)
        outerLayer.addChild(titleLabel)
    
        
        let balanceLabel = SKLabelNode(text: "Balance: \(MenuScene.getBankBalance()) ")
        balanceLabel.fontName = "Helvetica-Bold"
        balanceLabel.fontSize = 15
        balanceLabel.fontColor = .black
        balanceLabel.zPosition = GameConstants.zPositions.topZ + 100
        balanceLabel.position = CGPoint(x: frame.minX + xBuffer, y: frame.maxY - yBuffer)
        
        outerLayer.addChild(balanceLabel)
        
        addLabel(label: "Speed", positionX: (frame.midX/4.0) - 40, positionY: ((frame.midY/3.0) + yBuffer - 5))
        addLabel(label: "Skill", positionX: (frame.midX/4.0) - 40, positionY: (frame.midY/3.0) - 5)
        addLabel(label: "Strength", positionX: (frame.midX/4.0) - 40, positionY: ((frame.midY/3.0) - yBuffer - 5))
        
        
        speedCurrentValue = getStat(key: GameConstants.Keys.speedKey)
        skillCurrentValue = getStat(key: GameConstants.Keys.skillKey)
        strengthCurrentValue = getStat(key: GameConstants.Keys.skillKey)
        reputationCurrentValue = getReputation()
        
        
        addProgressBar(progressBar: speedProgressBar, positionX: (frame.midX/4.0), positionY: (frame.midY/3.0) + yBuffer)
        addProgressBar(progressBar: skillProgressBar, positionX: frame.midX/4.0, positionY: (frame.midY/3.0))
        addProgressBar(progressBar: strengthProgressBar, positionX: frame.midX/4.0, positionY: ((frame.midY/3.0) - yBuffer))
        
        updateProgressbar(progressBar: speedProgressBar, currentValue: speedCurrentValue)
        updateProgressbar(progressBar: skillProgressBar, currentValue: skillCurrentValue)
        updateProgressbar(progressBar: strengthProgressBar, currentValue: strengthCurrentValue)
        
        
        
        
        // training, sponsorship and calendar buttons
        
        let trainingButton = SKSpriteNode(color: .white, size: CGSize(width: 90, height: 40))
        trainingButton.name = "trainingButton"
        trainingButton.position = CGPoint(x: frame.midX-80, y: frame.midY/4.0)
        trainingButton.zPosition = GameConstants.zPositions.hudZ
        outerLayer.addChild(trainingButton)
        
        let border1 = SKShapeNode(rectOf: CGSize(width: 90+borderWidth, height: 40+borderWidth), cornerRadius: 2.0)
        border1.strokeColor = .black
        border1.lineWidth = borderWidth
        border1.fillColor = .clear
        border1.position = CGPoint(x: frame.midX-80, y: frame.midY/4.0)
        border1.zPosition = GameConstants.zPositions.hudZ - 0.1
        
        outerLayer.addChild(border1)
        
        
        let sponsorshipButton = SKSpriteNode(color: .white, size: CGSize(width: 90, height: 40))
        sponsorshipButton.name = "sponsorshipButton"
        sponsorshipButton.position = CGPoint(x: frame.midX + 20, y: frame.midY/4.0)
        sponsorshipButton.zPosition = GameConstants.zPositions.hudZ
        outerLayer.addChild(sponsorshipButton)
        
        let border2 = SKShapeNode(rectOf: CGSize(width: 90+borderWidth, height: 40+borderWidth), cornerRadius: 2.0)
        border2.strokeColor = .black
        border2.lineWidth = borderWidth
        border2.fillColor = .clear
        border2.position = CGPoint(x: frame.midX + 20, y: frame.midY/4.0)
        border2.zPosition = GameConstants.zPositions.hudZ - 0.1
        
        outerLayer.addChild(border2)
        
        let calendarButton = SKSpriteNode(color: .white, size: CGSize(width: 90, height: 40))
        calendarButton.name = "calendarButton"
        calendarButton.position = CGPoint(x: frame.midX + 120, y: frame.midY/4.0)
        calendarButton.zPosition = GameConstants.zPositions.hudZ
        outerLayer.addChild(calendarButton)
        
        let border3 = SKShapeNode(rectOf: CGSize(width: 90+borderWidth, height: 40+borderWidth), cornerRadius: 2.0)
        border3.strokeColor = .black
        border3.lineWidth = borderWidth
        border3.fillColor = .clear
        border3.position = CGPoint(x: frame.midX + 120, y: frame.midY/4.0)
        border3.zPosition = GameConstants.zPositions.hudZ - 0.1
        
        outerLayer.addChild(border3)
        
        
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
        
        let calendarLabel = SKLabelNode(text: "Calendar")
        calendarLabel.fontName = "Helvetica-Bold"
        calendarLabel.fontColor = .black
        calendarLabel.fontSize = 12
        calendarLabel.verticalAlignmentMode = .center
        calendarLabel.position = CGPoint(x: 0, y: 0)
        calendarButton.addChild(calendarLabel)
        
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
        startButton.fontColor = .blue
        startButton.position = CGPoint(x: frame.midX, y: frame.midY)
        startButton.name = GameConstants.StringConstants.hundredLinker
        calendarLayer.addChild(startButton)
        
        
        let javelinButton = SKLabelNode(text: "Javelin")
        javelinButton.fontSize = 30
        javelinButton.fontColor = .gray
        javelinButton.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        javelinButton.name = GameConstants.StringConstants.javelinLinker
        calendarLayer.addChild(javelinButton)
    }
    
    func showLayer(_ layer: SKNode) {
        trainingLayer.isHidden = true
        sponsorshipLayer.isHidden = true
        calendarLayer.isHidden = true
        tier1Layer.isHidden = true
        tier2Layer.isHidden = true
        tier3Layer.isHidden = true
        tier4Layer.isHidden = true
        tier5Layer.isHidden = true
        tier6Layer.isHidden = true
        tier7Layer.isHidden = true
        
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
        
        let coachText = "\(currentCoach.name)\n Speed Boost: \(currentCoach.speedBoost)\n Skill Boost: \(currentCoach.skillBoost) \n StrengthBoost: \(currentCoach.strengthBoost)"
        let coachDetailNode = createMultilineLabel(text: coachText, fontSize: 12, position: CGPoint(x: frame.midX, y: frame.midY + 65))
        coachDetailNode.zPosition = GameConstants.zPositions.hudZ - 0.1
        trainingLayer.addChild(coachDetailNode)
        
        
        let borderCoach = SKShapeNode(rectOf: CGSize(width: 130+borderWidth, height: 60+borderWidth), cornerRadius: 2.0)
        borderCoach.strokeColor = .black
        borderCoach.lineWidth = borderWidth
        borderCoach.fillColor = .clear
        borderCoach.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        borderCoach.zPosition = GameConstants.zPositions.hudZ
        borderCoach.name = "coachDetailNode"
        trainingLayer.addChild(borderCoach)
        
        
        setupScrollableArea()
    }
    
    func setupCurrentSponsorNode() {
        if (getCurrentSponsorIndex() ?? 0) > 26 {
            saveCurrentSponsorIndex(0)
        }
        currentSponsor = sponsors[getCurrentSponsorIndex() ?? 0]
        
        let sponsorText = "\(currentSponsor.name)\n Reputation Required: \(currentSponsor.reputationRequirement)\n Contract Length: \(currentSponsor.lengthOfContract)\n Reward Multiplier: \(currentSponsor.rewardMultiplier)"
        let sponsorDetailNode = createMultilineLabel(text: sponsorText, fontSize: 12, position: CGPoint(x: frame.midX, y: frame.midY + 65))
        sponsorDetailNode.zPosition = GameConstants.zPositions.hudZ - 0.1
        sponsorshipLayer.addChild(sponsorDetailNode)
        
        let borderSponsor = SKShapeNode(rectOf: CGSize(width: 150+borderWidth, height: 60+borderWidth), cornerRadius: 2.0)
        borderSponsor.lineWidth = borderWidth
        borderSponsor.fillColor = .clear
        borderSponsor.strokeColor = .black
        borderSponsor.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        borderSponsor.zPosition = GameConstants.zPositions.hudZ
        borderSponsor.name = "sponsorDetailNode"
        sponsorshipLayer.addChild(borderSponsor)
        
        setupScrollableSponsors()
    }
    
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
    
    static func saveReputation(_ level: Double) {
        UserDefaults.standard.set(level, forKey: GameConstants.Keys.reputationKey)
    }
    
    static func getReputation() -> Double {
        return UserDefaults.standard.double(forKey: GameConstants.Keys.reputationKey)
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
            print(getBankBalance())
            return true
        } else {
            return false
        }
    }
    
    static func checkReputation(newReputation: Double) -> Bool {
        var currentReputation = getReputation()
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
    
    func getStat(key: String) -> Double {
        return UserDefaults.standard.double(forKey: key)
    }
    
    func changeStat(amount: Double, key: String) {
        var currentValue = getStat(key: key)
        currentValue += amount
        saveStat(currentValue, key: key)
    }
    
    func newCoach(oldCoach: Coach, newCoach: Coach) {
        let currentSpeedStat = getStat(key: GameConstants.Keys.speedKey) - oldCoach.speedBoost
        let currentSkillStat = getStat(key: GameConstants.Keys.skillKey) - oldCoach.skillBoost
        let currentStrengthStat = getStat(key: GameConstants.Keys.strengthKey) - oldCoach.strengthBoost
        
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
        finishedLabel.fontColor = .black
        finishedLabel.position = CGPoint(x: positionX, y: positionY)
        
        
        outerLayer.addChild(finishedLabel)
    }
}

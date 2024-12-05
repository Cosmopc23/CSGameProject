//
//  Country Flags.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 04/12/2024.
//

import Foundation
import SpriteKit

class FlagNode: SKSpriteNode {
    init(country: String, size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        
        switch country {
        case "GB": 
            print("Creating GB flag")
            createGBFlag()
        case "FR":
            createFRFlag()
            print("Creating FR flag")
        case "DE": createGermanyFlag()
        case "IT": createItalyFlag()
        case "US": createUSFlag()
        case "CA": createCanadaFlag()
        case "BR": createBrazilFlag()
        case "MX": createMexicoFlag()
        case "JP": createJapanFlag()
        case "CN": createChinaFlag()
        case "KR": createSouthKoreaFlag()
        case "IN": createIndiaFlag()
        case "AU": createAustraliaFlag()
        case "NZ": createNewZealandFlag()
        case "RU": createRussiaFlag()
        case "ES": createSpainFlag()
        case "SE": createSwedenFlag()
        case "NL": createNetherlandsFlag()
        case "CH": createSwitzerlandFlag()
        case "BE": createBelgiumFlag()
        default: 
            createGBFlag()
            print("Using default case")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addBorder() {
        let border = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        border.fillColor = .clear
        border.strokeColor = UIColor.black
        border.lineWidth = 1.0
        addChild(border)
    }


    private func createGBFlag() {
        // Navy background
        let background = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        background.fillColor = UIColor(red: 1/255, green: 33/255, blue: 105/255, alpha: 1.0)
        background.strokeColor = .clear
        addChild(background)
        
        // White diagonals with clipping
        let clipNode = SKCropNode()
        let clipShape = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        clipShape.fillColor = .black
        clipNode.maskNode = clipShape
        addChild(clipNode)
        
        let whitePath = UIBezierPath()
        whitePath.move(to: CGPoint(x: 0, y: 0))
        whitePath.addLine(to: CGPoint(x: size.width, y: size.height))
        whitePath.move(to: CGPoint(x: 0, y: size.height))
        whitePath.addLine(to: CGPoint(x: size.width, y: 0))
        let whiteDiagonals = SKShapeNode(path: whitePath.cgPath)
        whiteDiagonals.strokeColor = .white
        whiteDiagonals.lineWidth = size.width * 0.2
        clipNode.addChild(whiteDiagonals)
        
        // White cross
        let vertical = SKShapeNode(rect: CGRect(x: size.width * 0.4, y: 0, width: size.width * 0.2, height: size.height))
        vertical.fillColor = .white
        vertical.strokeColor = .clear
        addChild(vertical)
        
        let horizontal = SKShapeNode(rect: CGRect(x: 0, y: size.height * 0.4, width: size.width, height: size.height * 0.2))
        horizontal.fillColor = .white
        horizontal.strokeColor = .clear
        addChild(horizontal)
        
        // Red diagonals with clipping
        let redClipNode = SKCropNode()
        redClipNode.maskNode = clipShape.copy() as? SKShapeNode
        addChild(redClipNode)
        
        let redPath = UIBezierPath()
        redPath.move(to: CGPoint(x: 0, y: 0))
        redPath.addLine(to: CGPoint(x: size.width, y: size.height))
        redPath.move(to: CGPoint(x: 0, y: size.height))
        redPath.addLine(to: CGPoint(x: size.width, y: 0))
        let redDiagonals = SKShapeNode(path: redPath.cgPath)
        redDiagonals.strokeColor = UIColor(red: 200/255, green: 16/255, blue: 46/255, alpha: 1.0)
        redDiagonals.lineWidth = size.width * 0.1
        redClipNode.addChild(redDiagonals)
        
        // Red cross
        let redVertical = SKShapeNode(rect: CGRect(x: size.width * 0.45, y: 0, width: size.width * 0.1, height: size.height))
        redVertical.fillColor = UIColor(red: 200/255, green: 16/255, blue: 46/255, alpha: 1.0)
        redVertical.strokeColor = .clear
        addChild(redVertical)
        
        let redHorizontal = SKShapeNode(rect: CGRect(x: 0, y: size.height * 0.45, width: size.width, height: size.height * 0.1))
        redHorizontal.fillColor = UIColor(red: 200/255, green: 16/255, blue: 46/255, alpha: 1.0)
        redHorizontal.strokeColor = .clear
        addChild(redHorizontal)
        
        addBorder()
    }

    
    private func createFRFlag() {
        let colors: [UIColor] = [
            UIColor(red: 0/255, green: 35/255, blue: 149/255, alpha: 1.0),
            .white,
            UIColor(red: 237/255, green: 41/255, blue: 57/255, alpha: 1.0)
        ]
        
        for i in 0..<3 {
            let stripe = SKShapeNode(rect: CGRect(x: CGFloat(i)*size.width/3, y: 0, width: size.width/3, height: size.height))
            stripe.fillColor = colors[i]
            stripe.strokeColor = .clear
            addChild(stripe)
        }
        
        addBorder()
    }
    
    private func createGermanyFlag() {
        let colors: [UIColor] = [.black, UIColor(red: 221/255, green: 0/255, blue: 0/255, alpha: 1.0), UIColor(red: 255/255, green: 206/255, blue: 0/255, alpha: 1.0)]
        
        for i in 0..<3 {
            let stripe = SKShapeNode(rect: CGRect(x: 0, y: CGFloat(2-i)*size.height/3, width: size.width, height: size.height/3))
            stripe.fillColor = colors[i]
            stripe.strokeColor = .clear
            addChild(stripe)
        }
        
        addBorder()
    }
    
    private func createItalyFlag() {
        let colors: [UIColor] = [
            UIColor(red: 0/255, green: 146/255, blue: 70/255, alpha: 1.0),
            .white,
            UIColor(red: 206/255, green: 43/255, blue: 55/255, alpha: 1.0)
        ]
        
        for i in 0..<3 {
            let stripe = SKShapeNode(rect: CGRect(x: CGFloat(i)*size.width/3, y: 0, width: size.width/3, height: size.height))
            stripe.fillColor = colors[i]
            stripe.strokeColor = .clear
            addChild(stripe)
        }
        
        addBorder()
    }
    
    private func createUSFlag() {
        let background = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        background.fillColor = .white
        background.strokeColor = .clear
        addChild(background)
        
        let canton = SKShapeNode(rect: CGRect(x: 0, y: size.height * 0.48, width: size.width * 0.4, height: size.height * 0.52))
        canton.fillColor = UIColor(red: 0/255, green: 40/255, blue: 104/255, alpha: 1.0)
        canton.strokeColor = .clear
        addChild(canton)
        
        for i in 0..<13 {
            if i % 2 == 0 {
                let stripe = SKShapeNode(rect: CGRect(x: 0, y: CGFloat(i) * size.height/13, width: size.width, height: size.height/13))
                stripe.fillColor = UIColor(red: 191/255, green: 10/255, blue: 48/255, alpha: 1.0)
                stripe.strokeColor = .clear
                addChild(stripe)
            }
        }
        
        addBorder()
    }
    
    private func createCanadaFlag() {
        // White background
        let background = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        background.fillColor = .white
        background.strokeColor = .clear
        addChild(background)
        
        // Red stripes
        let redColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
        
        let leftStripe = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width * 0.25, height: size.height))
        leftStripe.fillColor = redColor
        leftStripe.strokeColor = .clear
        addChild(leftStripe)
        
        let rightStripe = SKShapeNode(rect: CGRect(x: size.width * 0.75, y: 0, width: size.width * 0.25, height: size.height))
        rightStripe.fillColor = redColor
        rightStripe.strokeColor = .clear
        addChild(rightStripe)
        
        // Create simple square leaf
        let leafNode = SKShapeNode()
        let leafPath = UIBezierPath()
        
        let centerX = size.width * 0.5
        let centerY = size.height * 0.5
        let leafWidth = size.width * 0.15
        let leafHeight = size.height * 0.4
        
        // Main square body
        leafPath.move(to: CGPoint(x: centerX - leafWidth/2, y: centerY - leafHeight/2))
        leafPath.addLine(to: CGPoint(x: centerX + leafWidth/2, y: centerY - leafHeight/2))
        leafPath.addLine(to: CGPoint(x: centerX + leafWidth/2, y: centerY + leafHeight/2))
        leafPath.addLine(to: CGPoint(x: centerX - leafWidth/2, y: centerY + leafHeight/2))
        leafPath.close()
        
        // Top triangle
        let triangleHeight = leafHeight * 0.2
        leafPath.move(to: CGPoint(x: centerX - leafWidth/3, y: centerY + leafHeight/2))
        leafPath.addLine(to: CGPoint(x: centerX, y: centerY + leafHeight/2 + triangleHeight))
        leafPath.addLine(to: CGPoint(x: centerX + leafWidth/3, y: centerY + leafHeight/2))
        
        leafNode.path = leafPath.cgPath
        leafNode.fillColor = redColor
        leafNode.strokeColor = .clear
        addChild(leafNode)
        
        addBorder()
    }
    
    private func createBrazilFlag() {
        let background = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        background.fillColor = UIColor(red: 0/255, green: 156/255, blue: 59/255, alpha: 1.0)
        background.strokeColor = .clear
        addChild(background)
        
        let diamond = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: size.width/2, y: size.height*0.1))
        path.addLine(to: CGPoint(x: size.width*0.9, y: size.height/2))
        path.addLine(to: CGPoint(x: size.width/2, y: size.height*0.9))
        path.addLine(to: CGPoint(x: size.width*0.1, y: size.height/2))
        path.closeSubpath()
        diamond.path = path
        diamond.fillColor = UIColor(red: 254/255, green: 223/255, blue: 0/255, alpha: 1.0)
        diamond.strokeColor = .clear
        addChild(diamond)
        
        let circle = SKShapeNode(circleOfRadius: size.width * 0.15)
        circle.position = CGPoint(x: size.width/2, y: size.height/2)
        circle.fillColor = UIColor(red: 0/255, green: 39/255, blue: 118/255, alpha: 1.0)
        circle.strokeColor = .clear
        addChild(circle)
        
        addBorder()
    }
    
    private func createMexicoFlag() {
        // Tricolor background
        let colors: [UIColor] = [
            UIColor(red: 0/255, green: 104/255, blue: 71/255, alpha: 1.0),    // Green
            .white,
            UIColor(red: 206/255, green: 17/255, blue: 38/255, alpha: 1.0)    // Red
        ]
        
        for i in 0..<3 {
            let stripe = SKShapeNode(rect: CGRect(x: CGFloat(i)*size.width/3, y: 0, width: size.width/3, height: size.height))
            stripe.fillColor = colors[i]
            stripe.strokeColor = .clear
            addChild(stripe)
        }
        
        // Simplified coat of arms in the center
        let centerX = size.width * 0.5
        let centerY = size.height * 0.5
        let emblemSize = min(size.width * 0.2, size.height * 0.3)
        
        // Brown branch/perch (simplified)
        let branch = SKShapeNode(rect: CGRect(x: centerX - emblemSize/2,
                                            y: centerY - emblemSize/6,
                                            width: emblemSize,
                                            height: emblemSize/8))
        branch.fillColor = UIColor(red: 101/255, green: 67/255, blue: 33/255, alpha: 1.0)
        branch.strokeColor = .clear
        addChild(branch)
        
        // Eagle body (simplified as a triangle)
        let eaglePath = UIBezierPath()
        eaglePath.move(to: CGPoint(x: centerX, y: centerY + emblemSize/2))
        eaglePath.addLine(to: CGPoint(x: centerX - emblemSize/3, y: centerY - emblemSize/4))
        eaglePath.addLine(to: CGPoint(x: centerX + emblemSize/3, y: centerY - emblemSize/4))
        eaglePath.close()
        
        let eagle = SKShapeNode(path: eaglePath.cgPath)
        eagle.fillColor = UIColor.darkGray
        eagle.strokeColor = .clear
        addChild(eagle)
        
        // Snake (simplified as a curved line)
        let snakePath = UIBezierPath()
        snakePath.move(to: CGPoint(x: centerX - emblemSize/4, y: centerY))
        snakePath.addCurve(to: CGPoint(x: centerX + emblemSize/4, y: centerY),
                          controlPoint1: CGPoint(x: centerX, y: centerY + emblemSize/6),
                          controlPoint2: CGPoint(x: centerX, y: centerY - emblemSize/6))
        
        let snake = SKShapeNode(path: snakePath.cgPath)
        snake.strokeColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        snake.lineWidth = size.width * 0.02
        addChild(snake)
        
        addBorder()
    }
    
    private func createJapanFlag() {
        let background = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        background.fillColor = .white
        background.strokeColor = .clear
        addChild(background)
        
        let circle = SKShapeNode(circleOfRadius: size.width * 0.18)
        circle.position = CGPoint(x: size.width/2, y: size.height/2)
        circle.fillColor = UIColor(red: 188/255, green: 0/255, blue: 45/255, alpha: 1.0)
        circle.strokeColor = .clear
        addChild(circle)
        
        addBorder()
    }
    
    private func createChinaFlag() {
        let background = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        background.fillColor = UIColor(red: 238/255, green: 28/255, blue: 37/255, alpha: 1.0)
        background.strokeColor = .clear
        addChild(background)
        
        let bigStar = SKShapeNode(rectOf: CGSize(width: size.width * 0.2, height: size.width * 0.2))
        bigStar.position = CGPoint(x: size.width * 0.2, y: size.height * 0.7)
        bigStar.fillColor = UIColor(red: 255/255, green: 222/255, blue: 0/255, alpha: 1.0)
        bigStar.strokeColor = .clear
        addChild(bigStar) 
        
        addBorder()
    }
    
    private func createSouthKoreaFlag() {
       // White background
       let background = SKShapeNode(rect: CGRect(origin: .zero, size: size))
       background.fillColor = .white
       background.strokeColor = .clear
       addChild(background)
       
       // Top right lines (3)
       for i in 0..<3 {
           let line = SKShapeNode()
           let path = CGMutablePath()
           path.move(to: CGPoint(x: size.width * 0.6, y: size.height * (0.7 - CGFloat(i) * 0.15)))
           path.addLine(to: CGPoint(x: size.width * 0.9, y: size.height * (0.7 - CGFloat(i) * 0.15)))
           line.path = path
           line.strokeColor = .black
           line.lineWidth = size.width * 0.04
           addChild(line)
       }
       
       // Bottom right lines (3)
       for i in 0..<3 {
           let line = SKShapeNode()
           let path = CGMutablePath()
           path.move(to: CGPoint(x: size.width * 0.6, y: size.height * (0.3 + CGFloat(i) * 0.15)))
           path.addLine(to: CGPoint(x: size.width * 0.9, y: size.height * (0.3 + CGFloat(i) * 0.15)))
           line.path = path
           line.strokeColor = .black
           line.lineWidth = size.width * 0.04
           addChild(line)
       }

       // Top left lines (3)
       for i in 0..<3 {
           let line = SKShapeNode()
           let path = CGMutablePath()
           path.move(to: CGPoint(x: size.width * 0.1, y: size.height * (0.7 - CGFloat(i) * 0.15)))
           path.addLine(to: CGPoint(x: size.width * 0.4, y: size.height * (0.7 - CGFloat(i) * 0.15)))
           line.path = path
           line.strokeColor = .black
           line.lineWidth = size.width * 0.04
           addChild(line)
       }
       
       // Bottom left lines (3)
       for i in 0..<3 {
           let line = SKShapeNode()
           let path = CGMutablePath()
           path.move(to: CGPoint(x: size.width * 0.1, y: size.height * (0.3 + CGFloat(i) * 0.15)))
           path.addLine(to: CGPoint(x: size.width * 0.4, y: size.height * (0.3 + CGFloat(i) * 0.15)))
           line.path = path
           line.strokeColor = .black
           line.lineWidth = size.width * 0.04
           addChild(line)
       }
       
       // Red circle part
       let leftPath = UIBezierPath(arcCenter: CGPoint(x: size.width/2, y: size.height/2),
                                 radius: size.width * 0.25,
                                 startAngle: 0,
                                 endAngle: .pi,
                                 clockwise: true)
       let leftCircle = SKShapeNode(path: leftPath.cgPath)
       leftCircle.fillColor = UIColor(red: 198/255, green: 12/255, blue: 48/255, alpha: 1.0)
       leftCircle.strokeColor = .clear
       addChild(leftCircle)
       
       // Blue circle part
       let rightPath = UIBezierPath(arcCenter: CGPoint(x: size.width/2, y: size.height/2),
                                  radius: size.width * 0.25,
                                  startAngle: .pi,
                                  endAngle: 2 * .pi,
                                  clockwise: true)
       let rightCircle = SKShapeNode(path: rightPath.cgPath)
       rightCircle.fillColor = UIColor(red: 0/255, green: 71/255, blue: 160/255, alpha: 1.0)
       rightCircle.strokeColor = .clear
       addChild(rightCircle)
        
        addBorder()
    }
    
    private func createIndiaFlag() {
        let colors: [UIColor] = [
            UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 1.0),
            .white,
            UIColor(red: 19/255, green: 136/255, blue: 8/255, alpha: 1.0)
        ]
        
        for i in 0..<3 {
            let stripe = SKShapeNode(rect: CGRect(x: 0, y: CGFloat(2-i)*size.height/3, width: size.width, height: size.height/3))
            stripe.fillColor = colors[i]
            stripe.strokeColor = .clear
            addChild(stripe)
        }
        
        let wheel = SKShapeNode(circleOfRadius: size.width * 0.1)
        wheel.position = CGPoint(x: size.width/2, y: size.height/2)
        wheel.strokeColor = UIColor(red: 0/255, green: 0/255, blue: 128/255, alpha: 1.0)
        wheel.lineWidth = 1
        addChild(wheel)
        
        addBorder()
    }
    
    private func createAustraliaFlag() {
        // Navy background
        let background = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        background.fillColor = UIColor(red: 0/255, green: 36/255, blue: 125/255, alpha: 1.0)
        background.strokeColor = .clear
        addChild(background)
        
        // Create GB flag in canton
        let gbNode = FlagNode(country: "GB", size: CGSize(width: size.width * 0.4, height: size.height * 0.5))
        gbNode.position = CGPoint(x: 0, y: size.height * 0.5)
        addChild(gbNode)
        
        // Commonwealth Star (7-pointed) - represented as a square
        let commonwealthStar = SKShapeNode(rectOf: CGSize(width: size.width * 0.08, height: size.width * 0.08))
        commonwealthStar.position = CGPoint(x: size.width * 0.2, y: size.height * 0.35)  // Positioned under the Union Jack
        commonwealthStar.fillColor = .white
        commonwealthStar.strokeColor = .clear
        addChild(commonwealthStar)
        
        // Southern Cross star positions
        let starPositions = [
            CGPoint(x: 0.75, y: 0.75),  // Alpha Crucis
            CGPoint(x: 0.75, y: 0.35),  // Beta Crucis
            CGPoint(x: 0.85, y: 0.55),  // Gamma Crucis
            CGPoint(x: 0.65, y: 0.55),  // Delta Crucis
            CGPoint(x: 0.6, y: 0.45)    // Epsilon Crucis (smaller)
        ]
        
        let starSizes = [0.06, 0.06, 0.06, 0.06, 0.04] // Epsilon Crucis is smaller
        
        // Create the Southern Cross stars
        for (index, position) in starPositions.enumerated() {
            let star = SKShapeNode(rectOf: CGSize(width: size.width * starSizes[index],
                                                 height: size.width * starSizes[index]))
            star.position = CGPoint(x: size.width * position.x, y: size.height * position.y)
            star.fillColor = .white
            star.strokeColor = .clear
            addChild(star)
        }
        
        addBorder()
    }
    
    private func createNewZealandFlag() {
       // Navy background
       let background = SKShapeNode(rect: CGRect(origin: .zero, size: size))
       background.fillColor = UIColor(red: 0/255, green: 36/255, blue: 125/255, alpha: 1.0)
       background.strokeColor = .clear
       addChild(background)
       
       // Create miniature GB flag in canton
       let gbNode = FlagNode(country: "GB", size: CGSize(width: size.width * 0.4, height: size.height * 0.5))
       gbNode.position = CGPoint(x: 0, y: size.height * 0.5)
       addChild(gbNode)
       
        // Southern Cross stars
       let starPositions = [
           CGPoint(x: 0.75, y: 0.75),  // Alpha Crucis (bottom star)
           CGPoint(x: 0.75, y: 0.35),  // Beta Crucis (top star)
           CGPoint(x: 0.85, y: 0.55),  // Gamma Crucis (left star)
           CGPoint(x: 0.65, y: 0.55),  // Delta Crucis (right star)
           CGPoint(x: 0.6, y: 0.45)    // Epsilon Crucis (smaller star)
       ]
       
       let starSizes = [0.06, 0.06, 0.06, 0.06, 0.04] // Epsilon Crucis is smaller
       
       for (index, position) in starPositions.enumerated() {
           // Create white border star
           let outerStar = SKShapeNode(rectOf: CGSize(width: size.width * starSizes[index] * 1.2,
                                                     height: size.width * starSizes[index] * 1.2))
           outerStar.position = CGPoint(x: size.width * position.x, y: size.height * position.y)
           outerStar.fillColor = .white
           outerStar.strokeColor = .clear
           addChild(outerStar)
           
           // Create red inner star
           let innerStar = SKShapeNode(rectOf: CGSize(width: size.width * starSizes[index],
                                                     height: size.width * starSizes[index]))
           innerStar.position = CGPoint(x: size.width * position.x, y: size.height * position.y)
           innerStar.fillColor = UIColor(red: 200/255, green: 16/255, blue: 46/255, alpha: 1.0)
           innerStar.strokeColor = .clear
           addChild(innerStar)
       }
        
        addBorder()
    }
        
    private func createRussiaFlag() {
        let colors: [UIColor] = [
            .white,
            UIColor(red: 0/255, green: 57/255, blue: 166/255, alpha: 1.0),
            UIColor(red: 213/255, green: 43/255, blue: 30/255, alpha: 1.0)
        ]
        
        for i in 0..<3 {
            let stripe = SKShapeNode(rect: CGRect(x: 0, y: CGFloat(2-i)*size.height/3, width: size.width, height: size.height/3))
            stripe.fillColor = colors[i]
            stripe.strokeColor = .clear
            addChild(stripe)
        }
        
        addBorder()
    }
        
    private func createSpainFlag() {
    // Red background
        let background = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        background.fillColor = UIColor(red: 170/255, green: 21/255, blue: 27/255, alpha: 1.0)  // Red
        background.strokeColor = .clear
        addChild(background)
        
        // Yellow middle stripe (taking up 1/2 of height)
        let middleStripe = SKShapeNode(rect: CGRect(x: 0,
                                                  y: size.height * 0.25,
                                                  width: size.width,
                                                  height: size.height * 0.5))
        middleStripe.fillColor = UIColor(red: 250/255, green: 198/255, blue: 8/255, alpha: 1.0)  // Yellow
        middleStripe.strokeColor = .clear
        addChild(middleStripe)
        
        let centerX = size.width * 0.35
        let centerY = size.height * 0.5
        let emblemSize = size.height * 0.5
        
        // Crown (simplified as a rectangle with small points)
        let crownBase = SKShapeNode(rect: CGRect(x: centerX - emblemSize * 0.3, y: centerY + emblemSize * 0.1, width: emblemSize * 0.6, height: emblemSize * 0.15))
        crownBase.fillColor = UIColor(red: 128/255, green: 0/255, blue: 0/255, alpha: 1.0)
        crownBase.strokeColor = .clear
        addChild(crownBase)
        
        // Main shield (simplified as a rectangle)
        let shield = SKShapeNode(rect: CGRect(x: centerX - emblemSize * 0.25, y: centerY - emblemSize * 0.3, width: emblemSize * 0.5, height: emblemSize * 0.4))
        shield.fillColor = UIColor(red: 128/255, green: 0/255, blue: 0/255, alpha: 1.0)
        shield.strokeColor = .clear
        addChild(shield)
        
        // Two small pillars on sides
        let leftPillar = SKShapeNode(rect: CGRect(x: centerX - emblemSize * 0.35, y: centerY - emblemSize * 0.25, width: emblemSize * 0.08, height: emblemSize * 0.3))
        leftPillar.fillColor = UIColor(red: 139/255, green: 69/255, blue: 19/255, alpha: 1.0)
        leftPillar.strokeColor = .clear
        addChild(leftPillar)
        
        let rightPillar = SKShapeNode(rect: CGRect(x: centerX + emblemSize * 0.27, y: centerY - emblemSize * 0.25, width: emblemSize * 0.08, height: emblemSize * 0.3))
        rightPillar.fillColor = UIColor(red: 139/255, green: 69/255, blue: 19/255, alpha: 1.0)
        rightPillar.strokeColor = .clear
        addChild(rightPillar)
        
        addBorder()
    }
        
        private func createSwedenFlag() {
            let background = SKShapeNode(rect: CGRect(origin: .zero, size: size))
            background.fillColor = UIColor(red: 0/255, green: 106/255, blue: 167/255, alpha: 1.0)
            background.strokeColor = .clear
            addChild(background)
            
            let verticalStripe = SKShapeNode(rect: CGRect(x: size.width * 0.3125, y: 0, width: size.width * 0.1875, height: size.height))
            verticalStripe.fillColor = UIColor(red: 254/255, green: 204/255, blue: 0/255, alpha: 1.0)
            verticalStripe.strokeColor = .clear
            addChild(verticalStripe)
            
            let horizontalStripe = SKShapeNode(rect: CGRect(x: 0, y: size.height * 0.4375, width: size.width, height: size.height * 0.125))
            horizontalStripe.fillColor = UIColor(red: 254/255, green: 204/255, blue: 0/255, alpha: 1.0)
            horizontalStripe.strokeColor = .clear
            addChild(horizontalStripe)
            
            addBorder()
        }
        
        private func createNetherlandsFlag() {
            let colors: [UIColor] = [
                UIColor(red: 174/255, green: 28/255, blue: 40/255, alpha: 1.0),
                .white,
                UIColor(red: 33/255, green: 70/255, blue: 139/255, alpha: 1.0)
            ]
            
            for i in 0..<3 {
                let stripe = SKShapeNode(rect: CGRect(x: 0, y: CGFloat(2-i)*size.height/3, width: size.width, height: size.height/3))
                stripe.fillColor = colors[i]
                stripe.strokeColor = .clear
                addChild(stripe)
            }
            
            addBorder()
        }
        
        private func createSwitzerlandFlag() {
            let background = SKShapeNode(rect: CGRect(origin: .zero, size: size))
            background.fillColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
            background.strokeColor = .clear
            addChild(background)
            
            let verticalStripe = SKShapeNode(rect: CGRect(x: size.width * 0.45, y: size.height * 0.2, width: size.width * 0.1, height: size.height * 0.6))
            verticalStripe.fillColor = .white
            verticalStripe.strokeColor = .clear
            addChild(verticalStripe)
            
            let horizontalStripe = SKShapeNode(rect: CGRect(x: size.width * 0.2, y: size.height * 0.45, width: size.width * 0.6, height: size.height * 0.1))
            horizontalStripe.fillColor = .white
            horizontalStripe.strokeColor = .clear
            addChild(horizontalStripe)
            
            addBorder()
        }
        
        private func createBelgiumFlag() {
            let colors: [UIColor] = [
                .black,
                UIColor(red: 255/255, green: 223/255, blue: 0/255, alpha: 1.0),
                UIColor(red: 239/255, green: 51/255, blue: 64/255, alpha: 1.0)
            ]
            
            for i in 0..<3 {
                let stripe = SKShapeNode(rect: CGRect(x: CGFloat(i)*size.width/3, y: 0, width: size.width/3, height: size.height))
                stripe.fillColor = colors[i]
                stripe.strokeColor = .clear
                addChild(stripe)
            }
            
            addBorder()
        }
    }

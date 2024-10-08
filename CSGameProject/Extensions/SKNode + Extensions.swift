//
//  SKNode + Extensions.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 11/09/2024.
//

import Foundation

import SpriteKit

extension SKNode {
    
    
//    
    class func unarchiveFromFile(file: String) -> SKNode? {
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            let url = URL(fileURLWithPath: path)
            do {
                let sceneData = try Data(contentsOf: url, options: .mappedIfSafe)
                let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! SKNode
                archiver.finishDecoding()
                return scene
            } catch {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }

// scale a node so that it is a good size proportional to the screensize. This is more effective than hardcoding a size because it can be used effectively and consistently across multiple devices. E.g. Phones and iPads
    func scale(to screenSize: CGSize, width: Bool, multiplier: CGFloat) {
        let scale = width ? (screenSize.width * multiplier) / self.frame.size.width : (screenSize.height * multiplier) / self.frame.size.height
        self.setScale(scale)
    }
    
// Turn on gravity so a body falls towards the bottom of the screen
    func turnGravity(on value: Bool) {
        physicsBody?.affectedByGravity = value
    }
    
}

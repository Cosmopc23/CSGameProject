//
//  GameViewController.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 07/09/2024.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            // Initialize with the menu scene
            let scene = MenuScene(size: view.bounds.size)
                
            scene.scaleMode = .aspectFill
                
            // Present the scene
            view.presentScene(scene)
            
            // Enable debugging options
            view.ignoresSiblingOrder = true
            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    // Hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Hide the home indicator on iPhone X and newer
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    // Helper method to present alerts from any scene
    func showAlert(_ alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }

}

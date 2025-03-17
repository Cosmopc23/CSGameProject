//
//  AnimationHelper.swift
//  CSGameProject
//
//  Created by Cosmo Page-Croft on 11/09/2024.
//

import SpriteKit


class AnimationHelper {
    // Loads a sequence of textures from a texture atlas for animation
    static func loadTextures(from atlas: SKTextureAtlas, withName name: String) -> [SKTexture] {
        var textures = [SKTexture]()
        for index in 0..<atlas.textureNames.count {
            let textureName = name + String(index)
            textures.append(atlas.textureNamed(textureName))
        }
        return textures
    }
}

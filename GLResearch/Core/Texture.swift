//
//  TextureLoader.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/10/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit
import GLKit

final class Texture {
    
    private let fileName: String
    private var textureInfo: GLKTextureInfo?
    
    private var name: GLuint {
        return textureInfo!.name
    }
    
    func activeTextureAt(slot: Int32) {
        glActiveTexture(GLenum(GL_TEXTURE0 + slot))
    }
    
    private var target: GLenum {
        return textureInfo!.target
    }

    init(fileName: String) {
        self.fileName = fileName
    }
    
    func uploadTextureToGPU() -> Bool {
        
        guard let textureFileUrl = Bundle.main.url(forResource: fileName, withExtension: nil) else { return false }
        
        guard let textureInfo = try? GLKTextureLoader.texture(withContentsOf: textureFileUrl, options: [GLKTextureLoaderOriginBottomLeft: true, GLKTextureLoaderApplyPremultiplication: false]) else {
            return false
        }
        
        self.textureInfo = textureInfo
        
        glBindTexture(GLenum(GL_TEXTURE_2D), name)
        
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        
        glBindTexture(GLenum(GL_TEXTURE_2D), 0)
        
        return true
        
    }
    
    func bind() {
        glBindTexture(GLenum(GL_TEXTURE_2D), name)
    }
    
    func unbind() {
        glBindTexture(target, 0)
    }
    
    func release() {
        textureInfo = nil
    }
}

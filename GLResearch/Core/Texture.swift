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
    private let fileType: String
    
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

    init(name: String, type: String) {
        self.fileName = name
        self.fileType = type
    }
    
    func uploadTextureToGPU() -> Bool {
        
         let textureFileUrl = Bundle.main.url(forResource: self.fileName, withExtension: self.fileType)!
        
        let textureInfo = try! GLKTextureLoader.texture(withContentsOf: textureFileUrl, options: [GLKTextureLoaderOriginBottomLeft: true, GLKTextureLoaderApplyPremultiplication: false])
        
        
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
        glBindTexture(GLenum(GL_TEXTURE_2D), 0)
    }
    
    func release() {
        textureInfo = nil
    }
}

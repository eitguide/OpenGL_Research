//
//  TextureLoader.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/18/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import Foundation
import OpenGLES
import CoreGraphics
import ImageIO

final class Texture {
    private var textureId: GLuint = 0
    private let fileName: String
    private let antialias: Bool
    private let flipVertical: Bool

    init(fileName: String, antialias: Bool, flipVertical: Bool) {
        self.fileName = fileName
        self.antialias = antialias
        self.flipVertical = flipVertical
    }
    
    convenience init(fileName: String) {
        self.init(fileName: fileName, antialias: false, flipVertical: false)
    }
    
    func genTexture() {
        glGenTextures(1, &textureId)
    }
    
    func activeTextureAt(slot: Int32) {
        glActiveTexture(GLenum(GL_TEXTURE0 + slot))
    }
    
    func bind() {
        if textureId > 0 {
            glBindTexture(GLenum(GL_TEXTURE_2D), textureId)
        }
    }
    
    func unbind() {
        if textureId > 0 {
            glBindTexture(GLenum(GL_TEXTURE_2D), 0)
        }
    }
    
    func load() {
        guard let imageInfo = loadImageDataFrom(fileName: fileName, flipVertical: flipVertical) else { return }
        
        bind()
        
        if antialias {
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR_MIPMAP_LINEAR)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        } else {
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST)
        }
        
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_MIRRORED_REPEAT)
        
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(imageInfo.1), GLsizei(imageInfo.2), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), imageInfo.0)
        
        if antialias {
            glGenerateMipmap(GLenum(GL_TEXTURE_2D))
        }
        
        free(imageInfo.0)
    }
    
    func loadImageDataFrom(fileName: String, flipVertical: Bool) -> (UnsafeMutableRawPointer, Int, Int)? {
        
        let url = CFBundleCopyResourceURL(CFBundleGetMainBundle(), fileName as NSString, "" as CFString?, nil)
        
        let imageSource = CGImageSourceCreateWithURL(url!, nil)
        guard let image = CGImageSourceCreateImageAtIndex(imageSource!, 0, nil) else { return nil }
        
        let width = image.width
        let height = image.height
    
        let zero: CGFloat = 0
        let rect = CGRect(x: zero, y: zero, width: CGFloat(image.width), height: CGFloat(image.height))
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let imageData: UnsafeMutableRawPointer = malloc(Int(width * height * 4))
        guard let ctx = CGContext(data: imageData,
                                  width: Int(width),
                                  height: Int(height),
                                  bitsPerComponent: 8,
                                  bytesPerRow: Int(width * 4),
                                  space: colorSpace,
                                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return nil }

        if flipVertical {
            ctx.translateBy(x: zero, y: CGFloat(Int(height)))
            ctx.scaleBy(x: 1, y: -1)
        }
        
        ctx.setBlendMode(CGBlendMode.copy)
        ctx.draw(image, in: rect)

        return (imageData, width, height)
        
        
    
    }
}

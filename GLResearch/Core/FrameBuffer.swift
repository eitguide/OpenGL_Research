//
//  FrameBuffer.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/10/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import Foundation
import OpenGLES
import CoreGraphics

final class FrameBuffer {
    
    private var frameBuffer: GLuint = 0
    private var colorRendererBuffer: GLuint = 0
    private var textureRendererBuffer: GLuint = 0
    
    private let width: CGFloat
    private let height: CGFloat
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        
        generate()
    }
    
    func generate() {
        glGenFramebuffers(1, &frameBuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)
    }
    
    func attachColorRenderer() {
        glGenRenderbuffers(1, &colorRendererBuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRendererBuffer)
        glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_RGBA8), GLsizei(self.width), GLsizei(self.height))
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), colorRendererBuffer)
       
    }
    
    func attachTextureRenderer() {
        glGenTextures(1, &textureRendererBuffer)
        glBindTexture(GLenum(GL_TEXTURE_2D), textureRendererBuffer)
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(self.width), GLsizei(self.height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), nil)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_TEXTURE_2D), textureRendererBuffer, 0)
    }
    
    func shareFrameBuffer(forEAGLDrawable: EAGLDrawable, with context: EAGLContext) {
        glGenRenderbuffers(1, &colorRendererBuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRendererBuffer)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), colorRendererBuffer)
        context.renderbufferStorage(Int(GLenum(GL_RENDERBUFFER)), from: forEAGLDrawable)
    }
    
    func activeFrameForRendering() {
        glViewport(0, 0, GLsizei(width), GLsizei(height))
    }
    
    func detachColorRenderer() {
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), 0)
    }
    
    func detachTextureRenderer() {
        glFramebufferTexture2D(GLenum(GL_TEXTURE_2D), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_TEXTURE_2D), 0, 0)
    }
    
    func unbind() {
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), 0)
    }
    
    func bind() {
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)
    }
    
    
    func validate() {
        let frameBufferStatus = glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER))
        
        if frameBufferStatus == GLenum(GL_FRAMEBUFFER_COMPLETE) {
            print("Init Frame buffer success")
        } else {
            print("Init FrameBuffer failed")
            glBindFramebuffer(GLenum(GL_FRAMEBUFFER), 0)
        }
    }
    
    func release() {
        glDeleteRenderbuffers(1, &colorRendererBuffer)
        glDeleteTextures(1, &textureRendererBuffer)
        glDeleteFramebuffers(1, &frameBuffer)
    }

    
    
}

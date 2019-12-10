//
//  OpenGLView.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/9/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import Foundation
import UIKit
import OpenGLES
import GLKit
import CoreGraphics

final class OpenGLView: UIView {
    
    private var context: EAGLContext!
    private var shaderProgram: Shader!
    
    private var frameBuffer: GLuint! = 0
    private var colorRendererBuffer: GLuint! = 0
    private var texture: GLuint! = 0
    private var indexVertexBuffer: GLuint! = 0
    private var vertexBuffer: GLuint! = 0
    private var vao: GLuint! = 0
    
    
    private var postitionSlot: GLuint = 0
    private var colorSlot: GLuint = 0
    private var texCoordSlot: GLuint = 0
    private var sampleSlot: GLuint = 0
    
    private var glLayer: CAEAGLLayer!
    private var displayLink: CADisplayLink!
    private var textureInfo: GLKTextureInfo!
    
    private var screenFrameBuffer: GLuint = 0
    private var screenColorRendererBuffer: GLuint = 0
    
    private var vertices: [Vertex] = [
        Vertex(position: Position(x: -1, y: -1, z: 1), color: Color(r: 1, g: 0, b: 0, a: 1), textCoord: TextCoord(u: 0, v: 0)),
        Vertex(position: Position(x: 1, y: -1, z: 1), color: Color(r: 0, g: 1, b: 0, a: 1), textCoord: TextCoord(u: 1, v: 0)),
        Vertex(position: Position(x: 1, y: 1, z: 1), color: Color(r: 0, g: 0, b: 1, a: 1), textCoord: TextCoord(u: 1, v: 1)),
        Vertex(position: Position(x: -1, y: 1, z: 1), color: Color(r: 0, g: 0, b: 0.5, a: 1), textCoord: TextCoord(u: 0, v: 1))
    ]
    
    private let indices: [GLubyte] = [0, 1, 2, 2, 3, 0]

    
    override class var layerClass: AnyClass {
        return CAEAGLLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initOpenGLComponent()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initOpenGLComponent() {
        initOpenGLContext()
        initShader()
        initVertexData()
        initFrameBuffer()
//        uploadTexture()
        setupRunLoop()
    }
    
    private func setupRunLoop() {
        displayLink = CADisplayLink(target: self, selector: #selector(render))
        displayLink.add(to: .current, forMode: .default)
    }
    
    private func initOpenGLContext() {
        context = EAGLContext(api: .openGLES2)
        guard let openGLContext = context else { return }
        EAGLContext.setCurrent(openGLContext)
        
        self.glLayer = self.layer as? CAEAGLLayer
        self.glLayer.isOpaque = true
        
    }
    
    private func initFrameBuffer() {
        
        let size = UIScreen.main.bounds.size
         
        
        glGenFramebuffers(1, &frameBuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)

        glGenRenderbuffers(1, &colorRendererBuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRendererBuffer)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0),GLenum(GL_RENDERBUFFER), colorRendererBuffer)
        glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_RGBA8), GLsizei(size.width), GLsizei(size.height))
        
//        self.context.renderbufferStorage(Int(GL_RENDERBUFFER), from: self.glLayer)
        
      
        glGenTextures(1, &texture)
        glBindTexture(GLenum(GL_TEXTURE_2D), texture)
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(size.width), GLsizei(size.height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), nil)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_TEXTURE_2D), texture, 0)
    
        
        let frameBufferStatus = glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER))

        print(frameBufferStatus)
        
        if frameBufferStatus == GLenum(GL_FRAMEBUFFER_COMPLETE) {
            print("Init Frame buffer success")
        } else {
            print("Init FrameBuffer failed")
            glBindFramebuffer(GLenum(GL_FRAMEBUFFER), 0)
        }
        
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), 0)

        glGenFramebuffers(1, &screenFrameBuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), screenFrameBuffer)

        glGenRenderbuffers(1, &screenColorRendererBuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), screenColorRendererBuffer)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), screenColorRendererBuffer)
        self.context.renderbufferStorage(Int(GLenum(GL_RENDERBUFFER)), from: self.glLayer)

        let screenframeBufferStatus = glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER))
        if screenframeBufferStatus == GLenum(GL_FRAMEBUFFER_COMPLETE) {
            print("Init Screen Frame buffer success")
        } else {
            print("Init Screen FrameBuffer failed")
            glBindFramebuffer(GLenum(GL_FRAMEBUFFER), 0)
        }
        
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), 0)
        
        glViewport(0, 0, GLint(size.width), GLint(size.height))
        
    }
    
    private func initVertexData() {
        
        glGenVertexArrays(1, &vao)
        glBindVertexArray(vao)
        
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), 4 * MemoryLayout<Vertex>.size, vertices, GLenum(GL_STATIC_DRAW))
       
        glEnableVertexAttribArray(postitionSlot)
        glVertexAttribPointer(postitionSlot, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.size), nil)
        glDisableVertexAttribArray(postitionSlot)
        
        glEnableVertexAttribArray(colorSlot)
        glVertexAttribPointer(colorSlot, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE),
                              GLsizei(MemoryLayout<Vertex>.size), UnsafePointer(bitPattern: MemoryLayout<GLfloat>.size * 3))
        glDisableVertexAttribArray(colorSlot)
        
        glEnableVertexAttribArray(texCoordSlot)
        glVertexAttribPointer(texCoordSlot, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.size), UnsafePointer(bitPattern: MemoryLayout<GLfloat>.size * 7))
        glDisableVertexAttribArray(texCoordSlot)
        
        glGenBuffers(1, &indexVertexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexVertexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indices.count * MemoryLayout<GLubyte>.size, indices, GLenum(GL_STATIC_DRAW))
        
        glActiveTexture(GLenum(GL_TEXTURE4))
        
        glBindVertexArray(0)
    }

    private func initShader() {
        shaderProgram = Shader(vertexShaderFile: "vertextShader.vsh", fragmentShaderFile: "fragmentShader.fsh")
        postitionSlot = GLuint(glGetAttribLocation(shaderProgram.program, "aPosition"))
        colorSlot = GLuint(glGetAttribLocation(shaderProgram.program, "aColor"))
        texCoordSlot = GLuint(glGetAttribLocation(shaderProgram.program, "aTexCoord"))
//         sampleSlot = GLuint(glGetUniformLocation(shaderProgram.program, "sTexture"))
    }
    
    private func uploadTexture() {
        
        guard let textureFileUrl = Bundle.main.url(forResource: "texture", withExtension: "jpg") else { return }
        
        glEnable(GLenum(GL_TEXTURE_2D))
        glActiveTexture(GLenum(GL_TEXTURE0))
        glUniform1i(GLint(sampleSlot), 0)


//        textureInfo = try! GLKTextureLoader.texture(withContentsOf: textureFileUrl, options: [GLKTextureLoaderOriginBottomLeft: true, GLKTextureLoaderApplyPremultiplication: false])
        
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        
//        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_REPEAT)
//        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_REPEAT)
        
    }
    
    @objc func render() {
        
//        print(#function)
        
        shaderProgram.use()
        
       
        
        glClearColor(0, 0, 1, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        
        
        glBindVertexArray(vao)
        glEnableVertexAttribArray(postitionSlot)
        glEnableVertexAttribArray(colorSlot)
        glEnableVertexAttribArray(texCoordSlot)
        
        
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), 0)
        
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), screenFrameBuffer)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
        
        context.presentRenderbuffer(Int(GL_RENDERBUFFER))
        
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), 0)
        
        glBindVertexArray(0)
        glDisableVertexAttribArray(postitionSlot)
        glDisableVertexAttribArray(colorSlot)
        glDisableVertexAttribArray(texCoordSlot)
        
        
        

    }
}




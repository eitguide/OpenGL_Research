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

    private var glLayer: CAEAGLLayer!
    private var displayLink: CADisplayLink!
    
    private var context: EAGLContext!
    private var shader: Shader!
    
    private var vertexDataBuffer: VertexBuffer!
    private var offscreenFrameBuffer: FrameBuffer!
    private var renderToTextureFrameBuffer: FrameBuffer!
    private var viewFrameBuffer: FrameBuffer!
    private var renderer: Renderer!
    private let profileTexture = Texture(fileName: "wall.jpg")
    
    
    private var vertices: [Vertex] = [
        Vertex(position: Position(x: -1, y: -1, z: 0.5), color: Color(r: 1, g: 0, b: 0, a: 1), textCoord: TextCoord(u: 0, v: 0)),
        Vertex(position: Position(x: 1, y: -1, z: 0.5), color: Color(r: 0, g: 1, b: 0, a: 1), textCoord: TextCoord(u: 1, v: 0)),
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
        initVertexBufferAndFrameBuffer()
        initTexture()
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
    
    private func initShader() {
        
        shader = Shader(vertexShaderFile: "vertextShader.vsh", fragmentShaderFile: "fragmentShader.fsh")
        
        shader.addAttribute(name: "aPosition")
        shader.addAttribute(name: "aColor")
        shader.addAttribute(name: "aTexCoord")
        
        shader.addUniform(name: "sTexture")
        
    }
    
    private func initVertexBufferAndFrameBuffer() {
        
        vertexDataBuffer = VertexBuffer(vertexData: vertices, indiceData: indices)
        vertexDataBuffer.bind()
        
        vertexDataBuffer.configVertexBufferAndUploadToGPU(
            positionIndex: GLuint(shader.attributeLocationBy(name: "aPosition")),
            colorIndex: GLuint(shader.attributeLocationBy(name: "aColor")),
            texCoordIndex: GLuint(shader.attributeLocationBy(name: "aTexCoord"))
        )
        
        vertexDataBuffer.unbind()
        

        let size = UIScreen.main.bounds.size
        
        offscreenFrameBuffer = FrameBuffer(width: size.width, height: size.height)
        offscreenFrameBuffer.bind()
        offscreenFrameBuffer.attachColorRenderer()
        offscreenFrameBuffer.validate()
        offscreenFrameBuffer.unbind()
    
        renderToTextureFrameBuffer = FrameBuffer(width: size.width, height: size.height)
        renderToTextureFrameBuffer.bind()
        renderToTextureFrameBuffer.attachTextureRenderer()
        renderToTextureFrameBuffer.validate()
        renderToTextureFrameBuffer.unbind()
        
        viewFrameBuffer = FrameBuffer(width: size.width, height: size.height)
        viewFrameBuffer.bind()
        viewFrameBuffer.shareFrameBuffer(forEAGLDrawable: glLayer, with: context)
        viewFrameBuffer.activeFrameForRendering()
        viewFrameBuffer.validate()
        viewFrameBuffer.unbind()
        
        renderer = Renderer(shader: shader, vertexBuffer: vertexDataBuffer)
        

    }

    private func initTexture() {
        profileTexture.activeTextureAt(slot: 6)
        if(profileTexture.uploadTextureToGPU() ) {
            print("Upload local texture to GPU success")
        } else {
            print("Upload local texture to GPU failed")
        }
        shader.setUniform1i(name: "sTexture", value: 6)
    }
    
    @objc func render() {
        
        renderer.prepare()
        renderer.clear()
        
        vertexDataBuffer.bind()
        profileTexture.bind()
        
        profileTexture.activeTextureAt(slot: 6)
        shader.setUniform1i(name: "sTexture", value: 6)
        
        renderToTextureFrameBuffer.bind()
        renderer.draw()
        renderToTextureFrameBuffer.unbind()
        
        viewFrameBuffer.bind()
        renderer.draw()
        context.presentRenderbuffer(Int(GL_RENDERBUFFER))
        
        profileTexture.unbind()
        viewFrameBuffer.unbind()
        vertexDataBuffer.unbind()
        
    }
}




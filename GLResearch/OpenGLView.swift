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
    private let profileTexture = Texture(name: "texture", type: "jpg")
    private let flowerTexture = Texture(name: "tree", type: "png")
    
    private var vertices: [GLfloat] = [
        -0.5, -0.5, 1.0,          1.0, 0.0, 0.0, 1.0,            0.0, 0.0,
        0.5, -0.5, 1.0,           0.0, 1.0, 0.0, 1.0,            1.0, 0.0,
        0.5, 0.5, -1.0,           0.0, 0.0, 1.0, 1.0,            1.0, 1.0,
        -0.5, 0.5, -1.0,          0.0, 0.0, 0.5, 1.0,            0.0, 1.0
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
        displayLink.preferredFramesPerSecond = 30
        displayLink.add(to: .current, forMode: .default)
    }
    
    private func initOpenGLContext() {
        context = EAGLContext(api: .openGLES2)
        guard let openGLContext = context else { return }
        EAGLContext.setCurrent(openGLContext)
        
        self.glLayer = self.layer as? CAEAGLLayer
        self.glLayer.isOpaque = true
        self.glLayer.drawableProperties = [kEAGLDrawablePropertyRetainedBacking: true, kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8]
    }
    
    private func initShader() {
        
        shader = Shader(vertexShaderFile: "vertextShader.vsh", fragmentShaderFile: "fragmentShader.fsh")
        
        shader.addAttribute(name: "aPosition")
        shader.addAttribute(name: "aColor")
        shader.addAttribute(name: "aTexCoord")
        
        shader.addUniform(name: "sTexture1")
        shader.addUniform(name: "sTexture2")
        shader.addUniform(name: "uModelViewMatrix")
        shader.addUniform(name: "uProjectionMatrix")
        
    }
    
    private func initVertexBufferAndFrameBuffer() {
        
        vertexDataBuffer = VertexBuffer(vertexData: vertices, indiceData: indices, numberElementPerVertext: 9)
        vertexDataBuffer.bind()
        
        vertexDataBuffer.genVertextBuffer()
        vertexDataBuffer.addConfigVertexBuffer(forIndex: GLuint(shader.attributeLocationBy(name: "aPosition")), numberOfComponent: 3)
        vertexDataBuffer.addConfigVertexBuffer(forIndex: GLuint(shader.attributeLocationBy(name: "aColor")), numberOfComponent: 4)
        vertexDataBuffer.addConfigVertexBuffer(forIndex: GLuint(shader.attributeLocationBy(name: "aTexCoord")), numberOfComponent: 2)
        vertexDataBuffer.genElementBuffer()
        
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

    func modelMatrix() -> GLKMatrix4 {
        var matrix = GLKMatrix4Identity
//        matrix = GLKMatrix4Translate(matrix, Float(sin(CACurrentMediaTime() * 2 * Double.pi / 2)), 0, 0)
        matrix = GLKMatrix4Translate(matrix, 0.5, 0, 0)
        return matrix
    }
    
    func viewMatrix() -> GLKMatrix4 {
        return GLKMatrix4MakeTranslation(-0.5, -0.5, -1.1)
    }
    
    func viewModelMatrix() -> GLKMatrix4 {
        return GLKMatrix4Multiply(viewMatrix(), modelMatrix())
    }
    
    func projectionMatrix() -> GLKMatrix4 {
        return GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), GLfloat(self.bounds.size.width / self.bounds.size.height), 1, 150)
    }
    
    private func initTexture() {
        
        profileTexture.activeTextureAt(slot: 6)
        if(profileTexture.uploadTextureToGPU() ) {
            print("Upload profile local texture to GPU success")
        } else {
            print("Upload profile local texture to GPU failed")
        }
        profileTexture.unbind()
        
        
        flowerTexture.activeTextureAt(slot: 4)
        if(flowerTexture.uploadTextureToGPU()) {
            print("Upload flower local texture to GPU success")
        } else {
           print("Upload flower local texture to GPU failed")
        }
        flowerTexture.unbind()
        
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
    
        
    }
    
    @objc func render() {
        print(#function)
        viewFrameBuffer.bind()
        renderer.clear()
        
        renderer.prepare()
        vertexDataBuffer.bind()
        
        profileTexture.activeTextureAt(slot: 6)
        profileTexture.bind()
        
        flowerTexture.activeTextureAt(slot: 4)
        flowerTexture.bind()
        
        renderToTextureFrameBuffer.bind()
        renderer.draw()
        renderToTextureFrameBuffer.unbind()

        glUniformMatrix4fv(shader.uniformLocationBy(name: "uModelViewMatrix"), 1, GLboolean(GLenum(GL_FALSE)), viewModelMatrix().array)
        glUniformMatrix4fv(shader.uniformLocationBy(name: "uProjectionMatrix"), 1, GLboolean(GLenum(GL_FALSE)), projectionMatrix().array)
        
        shader.setUniform1i(name: "sTexture1", value: 6)
        shader.setUniform1i(name: "sTexture2", value: 4)
        
        viewFrameBuffer.bind()
    
        renderer.draw()
        
        context.presentRenderbuffer(Int(GL_RENDERBUFFER))
        
        profileTexture.unbind()
        vertexDataBuffer.unbind()
        viewFrameBuffer.unbind()
        
    }
}




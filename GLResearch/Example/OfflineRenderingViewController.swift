//
//  OfflineRendering.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/18/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import UIKit

final class OfflineRenderingViewController: UIViewController {
    
    private let glView = GLView(frame: UIScreen.main.bounds)
       
    private let vertices: [GLfloat] = [
       -1.0, -1.0, 1.0,        0.0, 0.0,
       1.0, -1.0, 1.0,         1.0, 0.0,
       1.0, 1.0, 1.0,          1.0, 1.0,
       -1.0, 1.0, 1.0,         0.0, 1.0,
    ]
    
    private let indices: [GLubyte] = [0, 1, 2, 2, 3, 0]
       
    private var vertexBuffer: VertexBuffer!
    private var shader: Shader!
    private var renderer: Renderer!
    private var texture: Texture!
    private var offlineFrameBuffer: FrameBuffer!
       
    override func viewDidLoad() {
       super.viewDidLoad()
       
       let context = EAGLContext(api: .openGLES2)
       EAGLContext.setCurrent(context!)
       glView.context = context
       
       view.addSubview(glView)
       
       glView.delegate = self
       
       shader = Shader(vertexShaderFile: "textureVertexShader.vsh", fragmentShaderFile: "textureFragmentShader.fsh")
       shader.addAttribute(name: "aPosition")
       shader.addAttribute(name: "aTexCoord")
    
       shader.addUniform(name: "sTexture")
       
       vertexBuffer = VertexBuffer(vertexData: vertices, indiceData: indices, numberElementPerVertext: 5)
       vertexBuffer.genVertextBuffer()
       vertexBuffer.addConfigVertexBuffer(forIndex: GLuint(shader.attributeLocationBy(name: "aPosition")), numberOfComponent: 3)
       vertexBuffer.addConfigVertexBuffer(forIndex: GLuint(shader.attributeLocationBy(name: "aTexCoord")), numberOfComponent: 2)
       vertexBuffer.genElementBuffer()
       vertexBuffer.unbind()
       
       renderer = Renderer(shader: shader, vertexBuffer: vertexBuffer)
       renderer.clearColor = (0.0, 1.0, 0.5, 1.0)
       
        texture = Texture(fileName: "wall.jpg")
        texture.activeTextureAt(slot: 2)
        texture.genTexture()
        texture.load()
        texture.bind()
       
        
        
        let size = UIScreen.main.bounds
        offlineFrameBuffer = FrameBuffer(width: size.width, height: size.height)
        offlineFrameBuffer.generate()
        offlineFrameBuffer.bind()
        offlineFrameBuffer.attachColorRenderer()
        offlineFrameBuffer.validate()
        offlineFrameBuffer.unbind()
    }
}

extension OfflineRenderingViewController: GLViewDrawDelegate {
   func drawOpenGL() {
        renderer.clear()
        shader.use()
        shader.setUniform1i(name: "sTexture", value: 2)
        texture.bind()
        vertexBuffer.bind()
        offlineFrameBuffer.bind()
        renderer.draw()
        glView.activeBuffer = true
        renderer.draw()
   }
}
    

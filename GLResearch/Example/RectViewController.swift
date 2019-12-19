//
//  RectViewController.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/18/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import UIKit
import SnapKit

class RectViewController: GLViewController {
    
    private let vertices: [GLfloat] = [
        -1.0, 1.0, 1.0,      1.0, 1.0, 0.5, 1.0,
        -1.0, -1.0, 1.0,    1.0, 0.5, 1.0, 1.0,
        1.0, -1.0, 1.0,     0.5, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0,     0.5, 0.5, 1.0, 1.0
    ]
    
    private let indices: [GLubyte] = [0, 1, 2, 2, 3, 0]
    
    private var vertexBuffer: VertexBuffer!
    private var shader: Shader!
    private var renderer: Renderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = EAGLContext(api: .openGLES2)
        EAGLContext.setCurrent(context!)
        glView.context = context
        
        shader = Shader(vertexShaderFile: "colorVertexShader.vsh", fragmentShaderFile: "colorFragmentShader.fsh")
        shader.addAttribute(name: "aPosition")
        shader.addAttribute(name: "aColor")
        
        vertexBuffer = VertexBuffer(vertexData: vertices, indiceData: indices, numberElementPerVertext: 7)
        vertexBuffer.genVertextBuffer()
        vertexBuffer.addConfigVertexBuffer(forIndex: GLuint(shader.attributeLocationBy(name: "aPosition")), numberOfComponent: 3)
        vertexBuffer.addConfigVertexBuffer(forIndex: GLuint(shader.attributeLocationBy(name: "aColor")), numberOfComponent: 4)
        vertexBuffer.genElementBuffer()
        vertexBuffer.unbind()
        
        renderer = Renderer(shader: shader, vertexBuffer: vertexBuffer)
        renderer.clearColor = (0.0, 1.0, 0.5, 1.0)
    }
    
    override func glDraw(view: GLView) {
        renderer.clear()
        shader.use()
        vertexBuffer.bind()
        renderer.draw()
    }
}


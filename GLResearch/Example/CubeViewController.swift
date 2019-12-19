//
//  CubeViewController.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/16/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import Foundation
import UIKit


final class CubeViewController: UIViewController {
    
    private let glView = GLView(frame: UIScreen.main.bounds)
        
        private let vertices: [GLfloat] = [
            // Front
            1, -1, 1,       1, 0, 0, 1,     1, 0, // 0
            1,  1, 1,       0, 1, 0, 1,     1, 1, // 1
           -1,  1, 1,       0, 0, 1, 1,     0, 1, // 2
           -1, -1, 1,       0, 0, 0, 1,     0, 0, // 3
            
            // Back
           -1, -1, -1,      0, 0, 1, 1,     1, 0, // 4
           -1,  1, -1,      0, 1, 0, 1,     1, 1, // 5
            1,  1, -1,      1, 0, 0, 1,     0, 1, // 6
            1, -1, -1,      0, 0, 0, 1,     0, 0, // 7
            
            // Left
            -1, -1,  1,     1, 0, 0, 1,     1, 0, // 8
            -1,  1,  1,     0, 1, 0, 1,     1, 1, // 9
            -1,  1, -1,     0, 0, 1, 1,     0, 1, // 10
            -1, -1, -1,     0, 0, 0, 1,     0, 0, // 11
            
            // Right
            1, -1, -1,      1, 0, 0, 1,     1, 0, // 12
            1,  1, -1,      0, 1, 0, 1,     1, 1, // 13
            1,  1,  1,      0, 0, 1, 1,     0, 1, // 14
            1, -1,  1,      0, 0, 0, 1,     0, 0, // 15
            
            // Top
            1,  1,  1,      1, 0, 0, 1,     1, 0, // 16
            1,  1, -1,      0, 1, 0, 1,     1, 1, // 17
            -1,  1, -1,     0, 0, 1, 1,     0, 1, // 18
           -1,  1,  1,      0, 0, 0, 1,     0, 0, // 19
            
            // Bottom
            1, -1, -1,      1, 0, 0, 1,     1, 0, // 20
            1, -1,  1,      0, 1, 0, 1,     1, 1, // 21
            -1, -1,  1,     0, 0, 1, 1,     0, 1, // 22
           -1, -1, -1,      0, 0, 0, 1,     0, 0, //
        ]
    
        private let indices: [GLubyte] = [
            // Front
            0, 1, 2,
            2, 3, 0,
            
            // Back
            4, 5, 6,
            6, 7, 4,
            
            // Left
            8, 9, 10,
            10, 11, 8,
            
            // Right
            12, 13, 14,
            14, 15, 12,
            
            // Top
            16, 17, 18,
            18, 19, 16,
            
            // Bottom
            20, 21, 22,
            22, 23, 20
        ]
        
        private var vertexBuffer: VertexBuffer!
        private var shader: Shader!
        private var renderer: Renderer!
        private var texture: Texture!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let context = EAGLContext(api: .openGLES2)
            EAGLContext.setCurrent(context!)
            glView.context = context
            
            view.addSubview(glView)
            
            glView.delegate = self
            
            shader = Shader(vertexShaderFile: "cubeVertexShader.vsh", fragmentShaderFile: "cubeFragmentShader.fsh")
            shader.addAttribute(name: "aPosition")
            shader.addAttribute(name: "aColor")
            shader.addAttribute(name: "aTexCoord")
            
            shader.addUniform(name: "sTexture")
            
            vertexBuffer = VertexBuffer(vertexData: vertices, indiceData: indices, numberElementPerVertext: 9)
            vertexBuffer.genVertextBuffer()
            vertexBuffer.addConfigVertexBuffer(forIndex: GLuint(shader.attributeLocationBy(name: "aPosition")), numberOfComponent: 3)
            vertexBuffer.addConfigVertexBuffer(forIndex: GLuint(shader.attributeLocationBy(name: "aColor")), numberOfComponent: 4)
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
            
        }
    }

    extension CubeViewController: GLViewDrawDelegate {
        func drawOpenGL() {
            renderer.clear()
            shader.use()
            shader.setUniform1i(name: "sTexture", value: 2)
            texture.bind()
            vertexBuffer.bind()
            renderer.draw()
        }
    }


    
    
    


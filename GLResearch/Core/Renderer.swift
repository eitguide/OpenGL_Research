//
//  Renderer.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/10/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import Foundation
import OpenGLES

protocol IRenderer {
    func prepare()
    func clear()
    func draw()
}

final class Renderer: IRenderer {
    
    let shader: Shader
    let vertexBuffer: VertexBuffer
    
    init(shader: Shader, vertexBuffer: VertexBuffer) {
        self.shader = shader
        self.vertexBuffer = vertexBuffer
        glClearColor(1.0, 0.0, 1.0, 1.0)
    }
    
    func prepare() {
        shader.use()
    }
    
    func clear() {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
    }
    
    func draw() {
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(vertexBuffer.indiceCount), GLenum(GL_UNSIGNED_BYTE), nil)
    }

}

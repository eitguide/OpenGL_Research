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
    
    var clearColor: Color = Color(r: 1, g: 0, b: 0, a: 1)
    
    let shader: Shader
    let vertexBuffer: VertexBuffer
    
    init(shader: Shader, vertexBuffer: VertexBuffer) {
        self.shader = shader
        self.vertexBuffer = vertexBuffer
    }
    
    func prepare() {
        shader.use()
    }
    
    func clear() {
        glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    }
    
    func draw() {
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(vertexBuffer.indiceCount), GLenum(GL_UNSIGNED_BYTE), nil)
    }

}

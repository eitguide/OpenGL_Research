//
//  VertexBuffer.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/11/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import Foundation
import OpenGLES

final class VertexBuffer {
    private var vertexData = [Vertex]()
    private var indiceData = [GLubyte]()
    
    private var vao: GLuint = 0
    private var vertexBuffer: GLuint = 0
    private var indiceBuffer: GLuint = 0
    
    var indiceCount: Int {
        return indiceData.count
    }
    
    init(vertexData: [Vertex], indiceData: [GLubyte]) {
        self.vertexData.append(contentsOf: vertexData)
        self.indiceData.append(contentsOf: indiceData)
    }
    
    func configVertexBufferAndUploadToGPU(positionIndex: GLuint, colorIndex: GLuint, texCoordIndex: GLuint) {
        
        glGenVertexArrays(1, &vao)
        glBindVertexArray(vao)
        
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<Vertex>.size * vertexData.count, vertexData, GLenum(GL_STATIC_DRAW))
        
        glEnableVertexAttribArray(positionIndex)
        glVertexAttribPointer(positionIndex, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.size), nil)
        
        glEnableVertexAttribArray(colorIndex)
        glVertexAttribPointer(colorIndex, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE),
                              GLsizei(MemoryLayout<Vertex>.size), UnsafePointer(bitPattern: MemoryLayout<GLfloat>.size * 3))
      
        glEnableVertexAttribArray(texCoordIndex)
        glVertexAttribPointer(texCoordIndex, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.size), UnsafePointer(bitPattern: MemoryLayout<GLfloat>.size * 7))

        glGenBuffers(1, &indiceBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indiceBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), MemoryLayout<GLubyte>.size * indiceData.count, indiceData, GLenum(GL_STATIC_DRAW))
    }
    
    func bind() {
        glBindVertexArray(vao)
    }
    
    func unbind() {
        glBindVertexArray(0)
    }
    
    func release() {
        unbind()
        vertexData.removeAll()
        indiceData.removeAll()
        glDeleteVertexArrays(1, &vao)
        glDeleteBuffers(1, &vertexBuffer)
        glDeleteBuffers(1, &indiceBuffer)
        
    }
}

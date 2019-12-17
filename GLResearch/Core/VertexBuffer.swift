//
//  VertexBuffer.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/11/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit

final class VertexBuffer {
    private var vertexData = [GLfloat]()
    private var indiceData = [GLubyte]()
    
    private var vao: GLuint = 0
    private var vertexBuffer: GLuint = 0
    private var indiceBuffer: GLuint = 0
    private let numberElementPerVertext: Int
    
    private var currentIndex: Int = 0
    
    
    var indiceCount: Int {
        return indiceData.count
    }
    
    init(vertexData: [GLfloat], indiceData: [GLubyte], numberElementPerVertext: Int) {
        self.vertexData.append(contentsOf: vertexData)
        self.indiceData.append(contentsOf: indiceData)
        self.numberElementPerVertext = numberElementPerVertext
    }
    
    func genVertextBuffer() {
        
        glGenVertexArrays(1, &vao)
        glBindVertexArray(vao)
        
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * vertexData.count, vertexData, GLenum(GL_STATIC_DRAW))
    }
    
    func addConfigVertexBuffer(forIndex: GLuint, numberOfComponent: GLuint) {
        glEnableVertexAttribArray(forIndex)
        glVertexAttribPointer(forIndex, GLint(numberOfComponent), GLenum(GL_FLOAT), GLboolean(GL_FALSE),  GLsizei(MemoryLayout<GLfloat>.size * numberElementPerVertext), UnsafePointer(bitPattern: MemoryLayout<GLfloat>.size * currentIndex))
        
        currentIndex += Int(numberOfComponent)
    }
    
    func genElementBuffer() {
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

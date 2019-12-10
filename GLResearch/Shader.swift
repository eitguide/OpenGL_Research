//
//  Shader.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/9/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import Foundation
import OpenGLES

final class Shader {
    
    private var shaderProgram: GLuint = 0
    
    var program: GLuint {
        return shaderProgram
    }
    
    init(vertexShaderString: String, fragmentShaderString: String) {
         _ = createProgramWith(vertexShaderString: vertexShaderString, fragmentShaderString: fragmentShaderString)
    }
    
    init(vertexShaderFile: String, fragmentShaderFile: String) {
        let vertexSourcePath = Bundle.main.path(forResource: vertexShaderFile, ofType: nil)!
        let fragmentSourcePath = Bundle.main.path(forResource: fragmentShaderFile, ofType: nil)!
        
        let vertexShaderString = try! String(contentsOf: URL(fileURLWithPath: vertexSourcePath))
        let fragmentShaderString = try! String(contentsOf: URL(fileURLWithPath: fragmentSourcePath))
        
        _ = createProgramWith(vertexShaderString: vertexShaderString, fragmentShaderString: fragmentShaderString)
    }
    
    private func createProgramWith(vertexShaderString: String, fragmentShaderString: String) -> GLuint {
        let vertextShader = createShader(shaderType: GLenum(GL_VERTEX_SHADER), shaderSource: vertexShaderString)
        let fragmentShader = createShader(shaderType: GLenum(GL_FRAGMENT_SHADER), shaderSource: fragmentShaderString)
        
        shaderProgram = glCreateProgram()
        glAttachShader(shaderProgram, GLuint(vertextShader))
        glAttachShader(shaderProgram, GLuint(fragmentShader))
        glLinkProgram(shaderProgram)
        
        glValidateProgram(shaderProgram)
        glUseProgram(shaderProgram)
        
        return shaderProgram
    }
    
    
    func use() {
        glUseProgram(shaderProgram)
    }
    
    private func createShader(shaderType: GLenum, shaderSource: String) -> GLint {
        let shader = GLint(glCreateShader(shaderType))
        shaderSource.withCString { glString in
            var tempString: UnsafePointer<GLchar>? = glString
            glShaderSource(GLuint(shader), 1, &tempString, nil)
            glCompileShader(GLuint(shader))
        }
        
        var compileStatus: GLint = 1
        glGetShaderiv(GLuint(shader), GLenum(GL_COMPILE_STATUS), &compileStatus)
        if compileStatus != 1 {
            var logLength: GLint = 0
            glGetShaderiv(GLuint(shader), GLenum(GL_INFO_LOG_LENGTH), &logLength)
            if logLength > 0 {
                var compileLog = [CChar](repeating: 0, count: Int(logLength))
                glGetShaderInfoLog(GLuint(shader), logLength, &logLength, &compileLog)
                print("OpenGL compile log: \(String(cString: compileLog))")
                
                switch shaderType {
                case GLenum(GL_VERTEX_SHADER):
                    print("OpenGL vertex shader compile error: \(String(cString: compileLog))")
                case GLenum(GL_FRAGMENT_SHADER):
                     print("OpenGL fragment shader compile error: \(String(cString: compileLog))")
                default:
                    break
                }
            }
        }
        
        return shader
        
    }
    
    func clean() {
        glDeleteProgram(program)
    
    }
}

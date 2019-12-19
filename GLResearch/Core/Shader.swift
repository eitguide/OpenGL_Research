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
    
    private var program: GLuint = 0
    
    var attributeLocationDic = [String: GLint]()
    var uniformLocationDic = [String: GLint]()
    
    var vertexShaderId: GLint = 0
    var fragmentShaderId: GLint = 0

    
    init(vertexShaderString: String, fragmentShaderString: String) {
         createShaderWith(vertexShaderString: vertexShaderString, fragmentShaderString: fragmentShaderString)
    }
    
    init(vertexShaderFile: String, fragmentShaderFile: String) {
        let vertexSourcePath = Bundle.main.path(forResource: vertexShaderFile, ofType: nil)!
        let fragmentSourcePath = Bundle.main.path(forResource: fragmentShaderFile, ofType: nil)!
        
        let vertexShaderString = try! String(contentsOf: URL(fileURLWithPath: vertexSourcePath))
        let fragmentShaderString = try! String(contentsOf: URL(fileURLWithPath: fragmentSourcePath))
        
        createShaderWith(vertexShaderString: vertexShaderString, fragmentShaderString: fragmentShaderString)
    }
    
    private func createShaderWith(vertexShaderString: String, fragmentShaderString: String) {
        vertexShaderId = createShader(shaderType: GLenum(GL_VERTEX_SHADER), shaderSource: vertexShaderString)
        fragmentShaderId = createShader(shaderType: GLenum(GL_FRAGMENT_SHADER), shaderSource: fragmentShaderString)
        
        program = glCreateProgram()
        glAttachShader(program, GLuint(vertexShaderId))
        glAttachShader(program, GLuint(fragmentShaderId))
        link()
    }
    
    private func link() {
        glLinkProgram(program)
        
        var linkStatus: GLint = 0
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &linkStatus)
        if linkStatus == 0 {
            var logLenght: GLint = 0
            glGetProgramiv(program, GLenum(GL_INFO_LOG_LENGTH), &logLenght)
            if logLenght > 0 {
                var compileLog = [CChar](repeating: 0, count: Int(logLenght))
                glGetProgramInfoLog(program, logLenght, &logLenght, &compileLog)
                print("Link log: \(String(cString:compileLog))")
            } else {
                print("Link Error")
            }
        } else {
            glValidateProgram(program)
        }
    }
    
    func use() {
        glUseProgram(program)
    
    }

    
    func addUniform(name: String) {
        if name.isEmpty { return }
        
        let uniformLocation = glGetUniformLocation(program, name)
        uniformLocationDic[name] = uniformLocation
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
    
    func addAttribute(name: String) {
        if name.isEmpty {
            return
        }
        
        let attributeLocation = glGetAttribLocation(program, name)
        attributeLocationDic[name] = attributeLocation
    }

    func setUniform1i(name: String, value: GLint) {
        let uniformLocation = glGetUniformLocation(program, name)
        if uniformLocation != -1 {
            glUniform1i(uniformLocation, value)
        }
    }
    
    func attributeLocationBy(name: String) -> GLint {
        return attributeLocationDic[name] ?? 0
    }
    
    func uniformLocationBy(name: String) -> GLint {
        return uniformLocationDic[name] ?? 0
    }
        
}

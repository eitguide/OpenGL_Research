//
//  Vertex.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/9/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import Foundation
import OpenGLES

struct Position {
    let x: GLfloat
    let y: GLfloat
    let z: GLfloat
}

struct Color {
    let r: GLfloat
    let g: GLfloat
    let b: GLfloat
    let a: GLfloat
}

struct TextCoord {
    let u: GLfloat
    let v: GLfloat
}

struct Vertex {
    let position: Position
    let color: Color
    let textCoord: TextCoord
}

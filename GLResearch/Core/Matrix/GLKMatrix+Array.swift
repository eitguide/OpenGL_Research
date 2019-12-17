//
//  GLKMatrix+Array.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/13/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import Foundation
import GLKit

extension GLKMatrix2 {
    var array: [Float] {
        return (0..<4).map { i in
            self[i]
        }
    }
}

extension GLKMatrix3 {
    var array: [Float] {
        return (0..<9).map { i in
            self[i]
        }
    }
}

extension GLKMatrix4 {
    var array: [Float] {
        return (0..<16).map { i in
            self[i]
        }
    }
}

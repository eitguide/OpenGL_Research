//
//  GLViewController.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/18/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import UIKit

class GLViewController: UIViewController {
    let glView = GLView(frame: UIScreen.main.bounds)
        
    var context: EAGLContext? {
       didSet {
            glView.context = context
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glView.delegate = self
        view.addSubview(glView)
    
    }
    
    func glDraw(view: GLView) {
        
    }
}

extension GLViewController: GLViewDrawDelegate {
    func drawOpenGL() {
        glDraw(view: glView)
    }
}



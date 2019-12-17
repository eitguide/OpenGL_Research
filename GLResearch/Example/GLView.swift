//
//  GLView.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/16/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import Foundation
import OpenGLES
import UIKit

class GLView: UIView {
    private var context: EAGLContext!
    private var viewFrameBuffer: FrameBuffer!
    private var displayLink: CADisplayLink!
    
    override class var layerClass: AnyClass {
        return CAEAGLLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        context = EAGLContext(api: .openGLES2)
        EAGLContext.setCurrent(context)
        
        let glLayer = self.layer as! CAEAGLLayer
        glLayer.drawableProperties = [kEAGLDrawablePropertyRetainedBacking: true, kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8]
        
        viewFrameBuffer = FrameBuffer(width: frame.width, height: frame.height)
        viewFrameBuffer.bind()
        viewFrameBuffer.attachColorRenderer()
        viewFrameBuffer.shareFrameBuffer(forEAGLDrawable: glLayer, with: context)
        viewFrameBuffer.activeFrameForRendering()
//        viewFrameBuffer.unbind()
        
        displayLink = CADisplayLink(target: self, selector: #selector(drawGL))
        displayLink.add(to: .current, forMode: .default)
        displayLink.preferredFramesPerSecond = 60
        
        glClearColor(1.0, 1.0, 0.0, 1.0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func drawGL() {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        context.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }
    
    
    
    
}

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

protocol GLViewDrawDelegate: class {
    func drawOpenGL()
}

class GLView: UIView {
    
    private var viewFrameBuffer: FrameBuffer!
    private var displayLink: CADisplayLink!
    
    weak var delegate: GLViewDrawDelegate?
    
    override class var layerClass: AnyClass {
        return CAEAGLLayer.self
    }
    
    var activeBuffer: Bool = true {
        didSet {
            viewFrameBuffer.bind()
        }
    }
    
    var context: EAGLContext? {
        didSet {
            let glLayer = self.layer as! CAEAGLLayer
            glLayer.drawableProperties = [kEAGLDrawablePropertyRetainedBacking: true, kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8]
            
            viewFrameBuffer = FrameBuffer(width: frame.width, height: frame.height)
            viewFrameBuffer.bind()
            viewFrameBuffer.attachColorRenderer()
            viewFrameBuffer.shareFrameBuffer(forEAGLDrawable: glLayer, with: context!)
            viewFrameBuffer.activeFrameForRendering()
            viewFrameBuffer.validate()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        context = EAGLContext(api: .openGLES2)
        EAGLContext.setCurrent(context)
        
        displayLink = CADisplayLink(target: self, selector: #selector(drawGL))
        displayLink.add(to: .current, forMode: .default)
        displayLink.preferredFramesPerSecond = 60
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func drawGL() {
        delegate?.drawOpenGL()
        context?.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }
    
    deinit {
        viewFrameBuffer.release()
    }
    
    
}

//
//  ViewController.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/9/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import UIKit
import OpenGLES

final class ViewController: UIViewController {

    private let openGLView = OpenGLView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(openGLView)
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    

}


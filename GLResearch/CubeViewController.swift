//
//  CubeViewController.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/16/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import Foundation
import UIKit


final class CubeViewController: UIViewController {
    
    private let glView = GLView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(glView)
    }
    
    
    
    
}

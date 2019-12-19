//
//  DemoViewController.swift
//  GLResearch
//
//  Created by Nguyen Van Nghia on 12/17/19.
//  Copyright © 2019 Nguyen Van Nghia. All rights reserved.
//

import UIKit
import SnapKit

final class DemoViewController: UIViewController {
    
    private let colorTriangleButton = UIButton()
    private let colorRectButton = UIButton()
    private let textureButton = UIButton()
    private let cubeButton = UIButton()
    private let offlineRenderingButton = UIButton()
    private let renderToTextureButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(colorTriangleButton)
        view.addSubview(colorRectButton)
        view.addSubview(textureButton)
        view.addSubview(cubeButton)
        view.addSubview(offlineRenderingButton)
        view.addSubview(renderToTextureButton)
    
        visualize()
        setupConstraint()
        
    }
    
    func visualize() {
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        colorTriangleButton.backgroundColor = .darkGray
        colorTriangleButton.setTitle("Triangle", for: .normal)
        colorTriangleButton.setTitleColor(.white, for: .normal)
        colorTriangleButton.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
        
        colorRectButton.backgroundColor = .darkGray
        colorRectButton.setTitle("Rect", for: .normal)
        colorRectButton.setTitleColor(.white, for: .normal)
        colorRectButton.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
        
        
        textureButton.backgroundColor = .darkGray
        textureButton.setTitle("Texture", for: .normal)
        textureButton.setTitleColor(.white, for: .normal)
        textureButton.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
        
        cubeButton.backgroundColor = .darkGray
        cubeButton.setTitle("Cube", for: .normal)
        cubeButton.setTitleColor(.white, for: .normal)
        cubeButton.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
        
        offlineRenderingButton.backgroundColor = .darkGray
        offlineRenderingButton.setTitle("Offline Rendering", for: .normal)
        offlineRenderingButton.setTitleColor(.white, for: .normal)
        offlineRenderingButton.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
        
        renderToTextureButton.backgroundColor = .darkGray
        renderToTextureButton.setTitle("Render To Texture", for: .normal)
        renderToTextureButton.setTitleColor(.white, for: .normal)
        renderToTextureButton.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
        
        offlineRenderingButton.isHidden = true
        renderToTextureButton.isHidden = true
        
    }
    
    func setupConstraint() {
        
        colorTriangleButton.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(60)
        }
        
        colorRectButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(colorTriangleButton)
            make.top.equalTo(colorTriangleButton.snp.bottom).offset(6)
            make.height.equalTo(60)
        }
        
        textureButton.snp.makeConstraints { (make) in
           make.leading.trailing.equalTo(colorTriangleButton)
           make.top.equalTo(colorRectButton.snp.bottom).offset(6)
           make.height.equalTo(60)
        }
        
        cubeButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(colorTriangleButton)
            make.top.equalTo(textureButton.snp.bottom).offset(6)
            make.height.equalTo(60)
        }
        
        offlineRenderingButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(colorTriangleButton)
            make.top.equalTo(cubeButton.snp.bottom).offset(6)
            make.height.equalTo(60)
        }
    
        
        renderToTextureButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(colorTriangleButton)
            make.top.equalTo(offlineRenderingButton.snp.bottom).offset(6)
            make.height.equalTo(60)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "OpenGL Example"
        navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc func click(sender: UIButton) {
        if sender == colorTriangleButton {
            let vc = TriangleViewController()
            present(vc, animated: true, completion: nil)
        } else if sender == colorRectButton {
            let vc = RectViewController()
            present(vc, animated: true, completion: nil)
        } else if sender == textureButton {
            let vc = TextureViewController()
            present(vc, animated: true, completion: nil)
        } else if sender == cubeButton {
            let vc = CubeViewController()
            present(vc, animated: true, completion: nil)
        } else if sender == offlineRenderingButton {
            let vc = OfflineRenderingViewController()
            present(vc, animated: true, completion: nil)
        } else if sender == renderToTextureButton {
            let vc = RenderToTextureViewController()
            present(vc, animated: true, completion: nil)
        }
    }
    
}


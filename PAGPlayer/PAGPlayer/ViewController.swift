//
//  ViewController.swift
//  PAGPlayer
//
//  Created by AUthor on 2023/9/26.
//

import UIKit

class ViewController: UIViewController {
    lazy var pagView :LXYPAGView = {
        let pagView = LXYPAGView()
        
        return pagView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = LXYPAGConfig()
        if let path = Bundle.main.path(forResource: "like", ofType: ".pag") {
            config.resourceStr = path
        }
        
        config.loop = 2
        pagView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        self.pagView.playAnim(config)
        
        view.addSubview(pagView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}


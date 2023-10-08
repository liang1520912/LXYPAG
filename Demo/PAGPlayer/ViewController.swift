//
//  ViewController.swift
//  PAGPlayer
//
//  Created by AUthor on 2023/9/26.
//

import UIKit
import LXYPAGPlayerSDK
class ViewController: UIViewController {
    lazy var pagView :LXYPAGView = {
        let pagView = LXYPAGView()
        
        return pagView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        playOnlineResource()
        pagView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(pagView)
        
    }
    
    //MARK: - 播放线上资源
    private func playOnlineResource(){
        let config = LXYPAGConfig()
        //这里要换成线上路径
        config.resourceStr =  "http://xxx/like.pag"
        pagView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        self.pagView.playAnim(config)
    }
    
    //MARK: - 区间播放
    private func playInFrame(){
        let config = LXYPAGConfig()
        if let path = Bundle.main.path(forResource: "login_page_animation", ofType: ".pag") {
            config.resourceStr = path
            config.speed = 2
            config.loop = 0
        }
        pagView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        self.pagView.playAnim(config)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}


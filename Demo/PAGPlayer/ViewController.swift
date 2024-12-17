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
        view.backgroundColor = .gray.withAlphaComponent(0.3)
        view.addSubview(pagView)
        replaceImage(isReplace: false)
        //AJTODO: 测试入口
        let btn = UIButton(type: .custom)
        btn.setTitle("替换图片", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.backgroundColor = .yellow
        view.addSubview(btn)
        let X = (UIScreen.main.bounds.width - 120)*0.5
        btn.frame = CGRect(x: X, y: pagView.frame.maxY + 80, width: 120, height: 30)
        btn.addTarget(self, action: #selector(testBtnClick), for: .touchUpInside)
    }
    
    //MARK: - 播放线上资源
    private func playOnlineResource(){
        let config = LXYPAGConfig()
        //这里要换成线上路径
        config.resourceStr =  "http://xxx/like.pag"
        pagView.frame = CGRect(x: 0, y: 100, width: 300, height: 300)
        self.pagView.playAnim(config)
    }
    @objc func testBtnClick() {
        replaceImage(isReplace: true)
    }
    //MARK: - 区间播放
    private func playInFrame(){
        let config = LXYPAGConfig()
        if let path = Bundle.main.path(forResource: "like", ofType: ".pag") {
            config.resourceStr = path
            config.speed = 2
            config.loop = 0
        }
        pagView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        self.pagView.playAnim(config)
    }
    //MARK: - 替换图片资源
    private func replaceImage(isReplace: Bool = false) {
        let config = LXYPAGConfig()
        if let path = Bundle.main.path(forResource: "replace_Image", ofType: ".pag") {
            config.resourceStr = path
            if isReplace {
                let entity = LXYDynamicEntity()
                entity.dynamicImageMap.updateValue(UIImage(named: "ic_room_egg_7")!, forKey: "user")
                config.dynamicEntity = entity
            }
        }
        pagView.frame = CGRect(x: 100, y: 120, width: 300, height: 300)
        self.pagView.playAnim(config)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}


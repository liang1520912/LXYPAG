//
//  LXYPAGPlayerProtocol.swift
//  LXYPAGPlayerSDK
//
//  Created by 梁爱军 on 2023/9/25.
//

import Foundation
import libpag
import UIKit
@objc  protocol LXYPAGPlayerProtocol {
    
    @objc weak var delegate: LXYPAGPlayDelegate?{set get}
    ///传入config开始播放
    @objc func playAnim(_ config: LXYPAGConfig)
    
    ///停止播放特性
    @objc func stopPlay()
    
    ///是否在播放
   @objc func isPlaying()->Bool
    
   @objc func replay(_ speed:CGFloat)
}

@objc public protocol LXYPAGPlayDelegate: NSObjectProtocol{
    ///开始播放
    @objc optional func startPlayOnView(_ view: UIView)
    ///播放停止,包括播放完成、取消播放
    @objc optional func stopPlayOnView(_ view: UIView)
    ///取消播放回调,回调后会调用 func stopPlayOnView(_ view: UIView)
    @objc optional func canclePlayOnView(_ view: UIView)
    
    ///播放异常回调
    @objc optional func playErroronView(_ view: UIView, _ error: NSError?)
    /// 重播
    @objc optional func onAnimationRepeat(_ view: UIView)
    /// 动效更新
    @objc optional func onAnimationUpdate(_ view: UIView)
}

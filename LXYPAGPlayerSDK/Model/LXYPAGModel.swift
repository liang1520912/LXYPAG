//
//  LXYPAGModel.swift
//  LXYPAGPlayerSDK
//
//  Created by 梁爱军 on 2023/9/25.
//

import Foundation
import UIKit
open class LXYPAGConfig: NSObject {
    ///本地路径或者线上路径
   @objc public var resourceStr:String = ""
    ///列表并且是小尺寸资源建议为true，打尺寸建议为false
   @objc public var useDiskCache: Bool = false
    ///循环次数，<= 0 无限循环，默认为1
   @objc public var loop: Int32 = 1
    ///播放速度
   @objc public var speed :CGFloat = 1
    ///播放区间
   @objc public var InFramePlayRange:NSRange = NSRange(location: 0, length: 0)
    
    
}


 class LXYPAGDownloadConfig:NSObject{
    @objc public var diskCacheBasePath:String = {
        let  paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        guard  paths.count > 0 , let path = paths.first else{
            return ""
        }
        return (((path as NSString).appendingPathComponent("PAG")) as NSString).appendingPathComponent("Download")
    }()
    @objc public var maxDiskSize = 1024 * 1024 * 200
    //单位秒
    @objc public var timeoutIntervalForRequest: Double = 30
    @objc public var timeoutInterForResource: Double = 30
    
    
}

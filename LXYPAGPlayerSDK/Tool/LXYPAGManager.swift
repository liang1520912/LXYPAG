//
//  LXYPAGManager.swift
//  LXYPAGPlayerSDK
//
//  Created by 梁爱军 on 2023/9/25.
//

import UIKit

class LXYPAGManager: NSObject {
   static let shareInstance = LXYPAGManager()
    var downloader: LXYDownloader = LXYDownloader()
    var downLoadConfig :LXYPAGDownloadConfig = LXYPAGDownloadConfig()
}

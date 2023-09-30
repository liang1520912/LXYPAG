//
//  PAGSDKTool.swift
//  LXYPAGPlayerSDK
//
//  Created by AUthor on 2023/9/25.
//

import Foundation
import CommonCrypto


func LXYPrint(items:Any){
    #if DEBUG
        print(items)
    #else
        // Release 模式下不打印输出
    #endif
}
struct PAGSDKTool {
    
    //判断是否是字符串
    static func isEmptyString(_ str: String?)->Bool{
        guard let str = str else {
            return true
        }
        return str.count == 0
    }
    
    
   static func md5String(_ str: String) -> String {
    let messageData = str.data(using: String.Encoding.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes { digestBytes in
            messageData.withUnsafeBytes { messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData.map { String(format: "%02hhx", $0) }.joined()
}
}

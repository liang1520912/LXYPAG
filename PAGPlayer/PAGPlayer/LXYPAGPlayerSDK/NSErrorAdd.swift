//
//  NSErrorAdd.swift
//  LXYPAGPlayerSDK
//
//  Created by AUthor on 2023/9/25.
//

import Foundation


extension NSError{
    static let DomainStr = "LXYPAGErrorDomain"
    static func pathNotFound(_ path: String)-> NSError{
      return  NSError(domain: DomainStr, code: -1, userInfo: [NSLocalizedDescriptionKey : "路径不存在"+path])
    }
    
    static func downloadStatueError(_ path:String, statueCode:Int)->NSError{
        return  NSError(domain: DomainStr, code: -2, userInfo: [NSLocalizedDescriptionKey : "路径\(path)下载失败网络,状态码\(statueCode)"])
    }
    
    static func parametersError(_ errStr:String)->NSError{
       return NSError(domain: DomainStr, code: -3, userInfo: [NSLocalizedDescriptionKey : errStr])
    }
    
    static func creatDirectoryFail(_ path:String)->NSError{
        return  NSError(domain: DomainStr, code: -4, userInfo: [NSLocalizedDescriptionKey : "根据路径创建文件夹失败:\(path)"])
    }
    
    static func moveToTargetPatFail(_ tempPath:String, _ targetPath:String)->NSError{
        return  NSError(domain: DomainStr, code: -5, userInfo: [NSLocalizedDescriptionKey : "转存临时文件失败，临时文件地址\(tempPath)---目标地址\(targetPath)"])
    }
    
    static func localResourceNotExist(_ path: String)->NSError{
        return NSError(domain: DomainStr, code: -6, userInfo: [NSLocalizedDescriptionKey : "本地资源不存在，资源地址\(path)"])
    }
}

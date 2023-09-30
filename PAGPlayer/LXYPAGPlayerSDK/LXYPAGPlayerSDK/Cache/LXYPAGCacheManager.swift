//
//  LXYPAGCache.swift
//  LXYPAGPlayerSDK
//
//  Created by 梁爱军 on 2023/9/25.
//

import UIKit

class LXYPAGCacheManager: NSObject {
    static let shareInstance = LXYPAGCacheManager()
    
    ///传入路径生成key
    func cacheKey(_ path: String?)->String{
        guard let path = path, path.count > 0 else {
            return ""
        }
        var key = PAGSDKTool.md5String(path)
        key = key + "." + "pag"//(path as NSString).pathExtension
        return key
    }
    
    func queryCachePath(forKey key: String?) -> String? {
        if PAGSDKTool.isEmptyString(key) {
            
            return nil
        }
    
        let localPath = filepath(key!)
        return localPath
    }
    
    //存放的最终路径
    func  filepath(_ key: String?)->String{
        guard  let key = key, key.count > 0 else {
            
            return ""
        }
       return appendBasePath(key) ?? ""
        
    }
    
    func  appendBasePath(_ path: String?)->String?{
        guard let path = path else {
            return nil
        }
      return  (LXYPAGManager.shareInstance.downLoadConfig.diskCacheBasePath as NSString).appendingPathComponent(path)
    }
    
    //MARK：把下载后的临时路径数据转存到指定目录
    func moveTempData(_ tempPath:String?, _ key:String?) throws ->String?{
        guard let tempPath = tempPath, tempPath.count > 0, let key = key, key.count > 0 else {
            throw NSError.pathNotFound("下载的临时路径或key为空")
            
        }
        let basePath = LXYPAGManager.shareInstance.downLoadConfig.diskCacheBasePath
        if FileManager.default.fileExists(atPath: basePath) == false {
            if let _ =  try? FileManager.default.createDirectory(atPath: basePath, withIntermediateDirectories: true, attributes: nil){
                // Directory creation succeeded
            }else{
                throw NSError.creatDirectoryFail(basePath)
                
            }
        }
        
        let targetPath = filepath(key)
        if let _ = try? FileManager.default.moveItem(atPath: tempPath, toPath: targetPath) {
            
        }else{
            throw NSError.moveToTargetPatFail(tempPath, targetPath)
            
        }
        return targetPath
        
    }
    
   
    //MARK: 判断是否超出阈值，如果超出则删除
    func removeFolderIfExceedsSize() {
        let fileManager = FileManager.default
        let folderURL = URL(string: LXYPAGManager.shareInstance.downLoadConfig.diskCacheBasePath)
        guard let folderURL = folderURL else{
            return
        }
        // 判断文件夹是否存在
        var isDirectory: ObjCBool = false
        if !fileManager.fileExists(atPath: folderURL.path, isDirectory: &isDirectory) || !isDirectory.boolValue {
            return
        }
        
        do {
            // 计算文件夹内文件总大小
            let contents = try fileManager.contentsOfDirectory(atPath: folderURL.path)
            var totalSize: UInt64 = 0
            
            for file in contents {
                let fileURL = folderURL.appendingPathComponent(file)
                let attributes = try fileManager.attributesOfItem(atPath: fileURL.path)
                if let fileSize = attributes[.size] as? UInt64 {
                    totalSize += fileSize
                }
            }
            
            // 如果超过最大大小，则删除文件夹内容
            if totalSize > LXYPAGManager.shareInstance.downLoadConfig.maxDiskSize {
                try fileManager.removeItem(at: folderURL)
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
/* func removeExpiredData(with diskCacheURL: URL, maxDiskSize: UInt) {
     let cacheContentDateKey = URLResourceKey.contentAccessDateKey
     let resourceKeys: [URLResourceKey] = [.isDirectoryKey, cacheContentDateKey, .totalFileSizeKey]
     
     guard let fileEnumerator = FileManager.default.enumerator(at: diskCacheURL, includingPropertiesForKeys: resourceKeys, options: .skipsHiddenFiles, errorHandler: nil) else {
         return
     }
     
     var cacheFiles = [URL: [URLResourceKey: Any]]()
     var currentCacheSize: UInt = 0
     
     for case let fileURL as URL in fileEnumerator {
         do {
             let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
             
             // Skip directories and errors
             if resourceValues.isDirectory ?? false {
                 continue
             }
             
             // Store a reference to this file and account for its total size
             if let totalAllocatedSize = resourceValues.totalFileSize {
                 
                 currentCacheSize += UInt(totalAllocatedSize)
                 
                 cacheFiles[fileURL] = resourceValues
             }
         } catch {
             continue
         }
     }
     
     // If our remaining disk cache exceeds a configured maximum size, perform a second size-based cleanup pass. We delete the oldest files first.
     print("清理缓存(LRU)开始 最大缓存大小: \(maxDiskSize) bytes, 当前缓存大小: \(currentCacheSize) bytes，路径：\(diskCacheURL)")
     if maxDiskSize > 0 && currentCacheSize > maxDiskSize {
         // Sort the remaining cache files by their last modification time or last access time (oldest first).
         let sortedFiles = cacheFiles.keys.sorted { (url1, url2) -> Bool in
             if let date1 = cacheFiles[url1]?[cacheContentDateKey] as? Date,
                let date2 = cacheFiles[url2]?[cacheContentDateKey] as? Date {
                 return date1.compare(date2) == .orderedAscending
             }
             return false
         }
         
         // Delete files until we fall below our desired cache size.
         for fileURL in sortedFiles {
             FileManager.default.removeFile(atPath: fileur, handler: <#T##Any?#>)
             if FileManager.default.removeFile(at: fileURL, handl) {
                 if let resourceValues = cacheFiles[fileURL],
                    let totalAllocatedSize = resourceValues[.totalFileSizeKey] as? UInt {
                     currentCacheSize -= totalAllocatedSize
                     print("清理缓存中 删除文件 path: \(fileURL.path), 当前文件大小: \(totalAllocatedSize) bytes, 剩余缓存大小: \(currentCacheSize) bytes")
                     
                     if currentCacheSize < maxDiskSize {
                         break
                     }
                 }
             }
         }
     }
     print("清理缓存(LRU)完毕 剩余缓存大小: \(currentCacheSize) bytes")
 }*/

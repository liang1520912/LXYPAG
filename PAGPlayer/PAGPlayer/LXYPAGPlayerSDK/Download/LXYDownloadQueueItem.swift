//
//  LXYDownloadQueueItem.swift
//  LXYPAGPlayerSDK
//
//  Created by AUthor on 2023/9/25.
//

import Foundation
import UIKit

typealias pathCallback = ((_ url: URL?, _ error: NSError?)->Void)
class LXYDownloadQueueItem:NSObject {
    fileprivate var task: URLSessionTask?
    fileprivate var callbacks:[pathCallback] = []
    
     func addCallback(_ callback: @escaping pathCallback){
        callbacks.append(callback)
    }
    init(task: URLSessionTask){
        self.task = task
    }
}

class LXYDownloadQueue:NSObject {
    fileprivate var downloadTaskMap: [String : LXYDownloadQueueItem] = [:]
    
    //查询是否已经在队列当中
    fileprivate func queryTask(_ urlStr:String)->URLSessionTask?{
        if downloadTaskMap.keys.contains(urlStr) {
            return downloadTaskMap[urlStr]?.task
        }
        return nil
    }
    
    //根据路径查询路径对应的回调
    fileprivate func queryCallbacks(_ urlStr: String)->[pathCallback]?{
        if downloadTaskMap.keys.contains(urlStr) {
            return downloadTaskMap[urlStr]?.callbacks
        }
        return nil
    }
    
    //更新
    fileprivate  func updateQueueItemCallback(_ urlStr: String,  callback:@escaping pathCallback){
        if downloadTaskMap.keys.contains(urlStr) {
            downloadTaskMap[urlStr]?.callbacks.append(callback)
        }
    }
    
    //排队
    fileprivate  func downloadEnqueue(_ task: URLSessionDownloadTask, _ callback: pathCallback?, _ key:String){
        var downloadItem: LXYDownloadQueueItem
        if self.downloadTaskMap.keys.contains(key) == false {
        downloadItem = LXYDownloadQueueItem(task: task)
            self.downloadTaskMap[key] = downloadItem
         
        }else{
            downloadItem = self.downloadTaskMap[key] ?? LXYDownloadQueueItem(task: task)
           
        }
       
        guard let callback = callback else {
            return
        }
        downloadItem.addCallback(callback)
    }
    
    //task出列
      func dequeueTask(_ urlStr: String)->URLSessionTask?{
        if downloadTaskMap.keys.contains(urlStr) {
            let item = downloadTaskMap[urlStr]
            downloadTaskMap.removeValue(forKey: urlStr)
            return item?.task
        }
        return nil
    }
   //MARK: - 取消task并返回callback执行
    func dequeueCallback(_ urlStr: String)->[pathCallback]?{
        if downloadTaskMap.keys.contains(urlStr) {
            let item = downloadTaskMap[urlStr]
            downloadTaskMap.removeValue(forKey: urlStr)
            return item?.callbacks
        }
        return nil
    }
    
}


//MARK：- 下载类
class LXYDownloader:NSObject {
    fileprivate  var queue: LXYDownloadQueue = LXYDownloadQueue()
      
    fileprivate lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = LXYPAGManager.shareInstance.downLoadConfig.timeoutIntervalForRequest
        config.timeoutIntervalForResource = LXYPAGManager.shareInstance.downLoadConfig.timeoutInterForResource
        let session = URLSession.init(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        return session
    }()
   
    
    //MARK: 下载
    @discardableResult
    func loadData(_ urlStr: String, _ downloadCallback:pathCallback?)->URLSessionTask?{
        guard let url = URL(string: urlStr) else {
            let error = NSError.pathNotFound(urlStr)
            downloadCallback?(nil,error)
            return nil
        }
        let questTask = queue.queryTask(urlStr)
        if let questTask = questTask {
            //在下载队列中找到对应的下载请求
            if let downloadCallback = downloadCallback {
                queue.updateQueueItemCallback(urlStr, callback: downloadCallback)
            }
            return questTask
        }
        let requestTask = self.session.downloadTask(with: url) {
            [weak self] (localPath, respon, error ) in
            guard let self = self else {
                return
            }
                let callbacks = queue.dequeueCallback(urlStr)
                guard let callbacks = callbacks else {
                    return
                }
                var err: NSError?
                if let respon = respon as? HTTPURLResponse{
                    let statusCode = respon.statusCode
                    if statusCode < 200 || statusCode > 300 {
                        err = NSError.downloadStatueError(urlStr, statueCode: statusCode)
                        
                    }
                }
                
                for itemCallback in callbacks{

                    itemCallback(localPath,err)
                }
            
        }
        
        queue.downloadEnqueue(requestTask, downloadCallback, urlStr)
        
        requestTask.resume()
        return requestTask
    }
    
     func cancelDownloadTask(_ urlStr: String){
        let task = self.queue.dequeueTask(urlStr)
        task?.cancel()
        
    }
}

//
//  LXYPAGView.swift
//  LXYPAGPlayerSDK
//
//  Created by 梁爱军 on 2023/9/25.
//

import UIKit
import libpag
open class LXYPAGView: UIView,LXYPAGPlayerProtocol {
    static let isPagViwe: Bool = true
    
    private var pagFile: PAGFile?
    private(set) lazy var pagView :PAGView = {
        let pagView = PAGView(frame: self.bounds)
        pagView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pagView.add(self)
        return pagView
    }()
    private(set) var config: LXYPAGConfig?
    public var delegate: LXYPAGPlayDelegate?
    private var checkLocalCaches: Bool = false
    
    //MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pagView)
        addNotifion()
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        pagView.frame = self.bounds
        
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override  func awakeFromNib() {
        super.awakeFromNib()
        addNotifion()
        
    }
    
    private func addNotifion(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActiveNotcAction), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNoticAction), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    
    //MARK: - 通知相关
    @objc private func willResignActiveNotcAction(){
        
    }
    
    @objc private func didBecomeActiveNoticAction(){
        
    }
    
    //MARK: - 播放
  @objc public func playAnim(_ config: LXYPAGConfig) {
        self.config = config
        if config.resourceStr.hasPrefix("http") == false {
            //本地数据
            playLocalPathAnim(config)
            return
        }
      let cacheKey =  LXYPAGCacheManager.shareInstance.cacheKey(config.resourceStr)
        let cachePath = LXYPAGCacheManager.shareInstance.filepath(cacheKey)
        if cachePath.count > 0 && FileManager.default.fileExists(atPath: cachePath) {
            //本地有则拿本地数据进行播放
            config.resourceStr = cachePath
            playLocalPathAnim(config)
            return
        }
        LXYPAGManager.shareInstance.downloader.loadData(config.resourceStr) { [weak self] locationPath, err in
            guard let self = self else { return }
            if err != nil {
                self.delegate?.playErroronView?(self, err)
                return
            }
            guard let locationPath = locationPath else{
                return
            }
            do{
                let targetPath = try LXYPAGCacheManager.shareInstance.moveTempData((locationPath as NSURL).path, cacheKey)
                if let targetPath = targetPath{
                    config.resourceStr = targetPath
                    self.playLocalPathAnim(config)
                }
            }catch let error{
                self.delegate?.playErroronView?(self, error as NSError)
            }
        }
        
    }
    /// 释放内存
   @objc public func freeCache() {
        pagView.freeCache()
    }
    ///
    @objc public var isVideoEnabled: Bool {
       return pagView.videoEnabled()
    }
    ///
   @objc public func setVideoe(isEnable: Bool) {
        pagView.setVideoEnabled(isEnable)
    }
    /// 内存缓存是否启用
    @objc public var  isCacheEnabled: Bool {
        return pagView.cacheEnabled()
    }
    /// 设置内存缓存生效
    @objc public func setCache(isEnable: Bool) {
        pagView.setCacheEnabled(isEnable)
    }
    /// 硬盘缓存是否启用
    @objc public var isUseDiskCache: Bool {
        return pagView.useDiskCache()
    }
    /// 是否启用硬盘缓存
    @objc public func setUseDiskCache(isEnable: Bool) {
        pagView.setUseDiskCache(isEnable)
    }
    /**
     * This value defines the scale factor for internal graphics caches, ranges from 0.0 to 1.0. The
     * scale factors less than 1.0 may result in blurred output, but it can reduce the usage of graphics
     * memory which leads to better performance. The default value is 1.0.
     */
    @objc public var cacheScale: Float {
        return pagView.cacheScale()
    }

    /// Set the value of cacheScale property.
    @objc public func setCache(scale: Float) {
        return pagView.setCacheScale(scale)
    }
    /// PAGScaleMode
    @objc public var scaleModel: PAGScaleMode {
        return pagView.scaleMode()
    }
    /// 设置模式
    @objc public func setScaleModel(model: PAGScaleMode) {
        pagView.setScaleMode(model)
    }
    /// 暂停播放
    @objc public func pause() {
        pagView.pause()
    }
    /// 恢复播放
    @objc public func resume() {
        pagView.play()
    }
    /// 停止播放
   @objc public func stopPlay() {
        if isPlaying() {
            pagView.stop()
        }
    }
    /// 是否正在播放
   @objc public func isPlaying()->Bool {
        return pagView.isPlaying()
    }
    /// 从指定speed开始播放
   @objc public func replay(_ speed: CGFloat) {
        guard let config = config else {
            return
        }
        if isPlaying() {
            stopPlay()
        }
        let targetSpeed = max(1, speed)
        config.speed = targetSpeed
        playAnim(config)
    }
    
    //MARK: - 播放PAG
    private func playLocalPathAnim(_ config: LXYPAGConfig){
        if isPlaying() {
            stopPlay()
        }
        let path = config.resourceStr
        if path.count == 0 || FileManager.default.fileExists(atPath: path) == false {
            let error = NSError.localResourceNotExist(path)
            delegate?.playErroronView?(self, error)
            return
        }
        pagFile = PAGFile.load(path)
//        print(pagFile)
        //动态替换资源，未实现
        pagView.setProgress(0)
//        pagView.setCurrentFrame(0)
        customizePlay()
        //播放音效，未实现
        
        pagView.play()
        
        //第一次播放时检查缓存大小，如果超出则删除
        if checkLocalCaches {
            LXYPAGCacheManager.shareInstance.removeFolderIfExceedsSize()
            checkLocalCaches = true
        }
    }
    
    //MARK: - 定制化播放
    private func customizePlay(){
        guard let config = self.config, let pagFile = pagFile else {
            return
        }
        if config.speed != 1 {
            //设置了速度
            pagFile.seTimeStretchMode(PAGTimeStretchModeScale)
            let duration = Int64(CGFloat(pagFile.duration()) / config.speed)
            pagFile.setDuration(duration)
        }
        if config.InFramePlayRange.length > 0 {
            let duration = Int64(CGFloat(pagFile.duration()) * config.speed)
            //指定了从特定帧开始播放
            let startLocal = config.InFramePlayRange.location
            let endLocal = startLocal + config.InFramePlayRange.length
            let totalFrame = pagFile.frameRate() * Float(duration) * 0.001 * 0.001
            let startProgress = Float(startLocal) / totalFrame
            pagFile.setStartTime(Int64(Float(-duration) * startProgress))
            let endProgress = Float(endLocal)/totalFrame
            pagFile.setDuration(Int64(Float(duration) * endProgress))
        }
       
        pagView.setRepeatCount(config.loop)
        pagView.setComposition(pagFile)
    }

}

extension LXYPAGView:PAGViewListener{
    public func onAnimationEnd(_ pagView: PAGView!) {
        delegate?.stopPlayOnView?(self)
    }
    public func onAnimationStart(_ pagView: PAGView!) {
        delegate?.startPlayOnView?(self)
    }
    public func  onAnimationCancel(_ pagView: PAGView!) {
        delegate?.canclePlayOnView?(self)
    }
    public func onAnimationRepeat(_ pagView: PAGView!) {
        delegate?.onAnimationRepeat?(self)
    }
    public func onAnimationUpdate(_ pagView: PAGView!) {
        delegate?.onAnimationUpdate?(self)
    }
}

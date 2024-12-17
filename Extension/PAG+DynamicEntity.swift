//
//  PAG+DynamicEntity.swift
//  LXYPAGPlayerSDK
//
//  Created by 梁爱军 on 2024/12/17.
//

import Foundation
import libpag
extension PAGFile {
    /// 应用动态属性
    @objc func applyDynamicProperties(with params: LXYDynamicEntity?) {
        guard let params = params else { return }
        
        applyDynamicImage(with: params)
        applyDynamicText(with: params)
    }
    
    /// 应用动态图片
    private func applyDynamicImage(with params: LXYDynamicEntity) {
        for (key, image) in params.dynamicImageMap {
            setDynamicImage(image, forKey: key)
        }
    }
    
    /// 应用动态文本
    private func applyDynamicText(with params: LXYDynamicEntity) {
        for (key, textObject) in params.dynamicTextMap {
            setDynamicText(textObject, forKey: key)
        }
    }
    
    // 设置动态图片
    private func setDynamicImage(_ image: UIImage, forKey key: String) {
        LXYPrint(items: "Walrus-PAG：will replaceImage with key:\(key)")
        var hasFindKey = false
        
        for i in 0..<numImages() {
            if let layers = getLayersByEditableIndex(i, layerType: .image){
                for layer in layers {
                    if let marker = layer.markers().first, !marker.comment.isEmpty {
                        let comment = marker.comment.trimmingCharacters(in: .whitespacesAndNewlines)
                        if comment == key {
                            if let cgImage = image.cgImage {
                                if let pagImage = PAGImage.fromCGImage(cgImage){
                                    replaceImage(i, data: pagImage)
                                    LXYPrint(items:"Walrus-PAG：did replaceImage with key:\(key) to index:\(i)")
                                    hasFindKey = true
                                    break
                                }
                            }
                        }
                    }
                }
                if hasFindKey { break }
            }
        }
        
        if !hasFindKey {
            print("Walrus-PAG：cannot find key:\(key) to fit image")
        }
    }
    
    // 设置动态文本
    private func setDynamicText(_ textObject: WalrusDynamicTextObject, forKey key: String) {
        print("Walrus-PAG：will replaceText with key:\(key) text:\(textObject.text)")
        var hasFindKey = false
        
        for i in 0..<numTexts() {
            if let layers = getLayersByEditableIndex(i, layerType: .text) {
                for layer in layers {
                    if let marker = layer.markers().first, !marker.comment.isEmpty {
                        let comment = marker.comment.trimmingCharacters(in: .whitespacesAndNewlines)
                        if comment == key {
                            if let pagText = getTextData(i) {
                                pagText.text = textObject.text
                                
                                let style = textObject.style
                                pagText.fontSize =  Float(style.fontSize)
                                pagText.fillColor = style.fillColor
                                pagText.fauxBold = style.fontBold
                                pagText.fauxItalic = style.fontItalic
                                
                                if let font = style.font {
                                    if let fontLocalPath = font.fontLocalPath, !fontLocalPath.isEmpty {
                                        if let pagFont = PAGFont.register(fontLocalPath) {
                                            pagText.fontFamily = pagFont.fontFamily
                                            pagText.fontStyle = pagFont.fontStyle
                                        }
                                    } else if let fontFamily = font.fontFamily, !fontFamily.isEmpty {
                                        pagText.fontFamily = font.fontFamily
                                        pagText.fontStyle = font.fontStyle
                                    }
                                }
                                
                                replaceText(i, data: pagText)
                                LXYPrint(items:"Walrus-PAG：did replaceText with key:\(key) text:\(textObject.text) to index:\(i)")
                                hasFindKey = true
                                break
                            }
                        }
                    }
                }
                if hasFindKey { break }
            }
        }
        
        if !hasFindKey {
            LXYPrint(items:"Walrus-PAG：cannot find key:\(key) to fit text")
        }
    }
    
}




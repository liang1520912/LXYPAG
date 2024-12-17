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
        for i in 0..<numImages() {
            guard let layers = getLayersByEditableIndex(i, layerType: .image) else { continue }
            
            if let index = layers.firstIndex(where: { layer -> Bool in
                guard let markers = layer.markers(), let marker = markers.first, let commentStr = marker.comment
                else { return false }
                let comment = commentStr.trimmingCharacters(in: .whitespacesAndNewlines)
                guard  !comment.isEmpty, comment == key else { return  false}
                if let cgImage = image.cgImage, let pagImage = PAGImage.fromCGImage(cgImage) {
                    replaceImage(i, data: pagImage)
                    LXYPrint(items: "Walrus-PAG：did replaceImage with key:\(key) to index:\(i)")
                    return true
                }
                return false
            }) {
                break
            }
        }
        
        LXYPrint(items:"Walrus-PAG：cannot find key:\(key) to fit image")
    }
    /// 替换文本
    private func setDynamicText(_ textObject: LXYDynamicTextObject, forKey key: String) {
        LXYPrint(items: "Walrus-PAG：will replaceText with key:\(key) text:\(textObject.text)")
        
        for i in 0..<numTexts() {
            guard let layers = getLayersByEditableIndex(i, layerType: .text) else { continue }
            
            if let _ = layers.firstIndex(where: { layer -> Bool in
                guard let markers = layer.markers(), let marker = markers.first,
                      let commentStr = marker.comment, !commentStr.isEmpty else {
                    return false
                }
                
                let comment = commentStr.trimmingCharacters(in: .whitespacesAndNewlines)
                guard comment == key else { return false }
                
                // Apply text changes only once the correct layer is found.
                guard let pagText = getTextData(i) else { return false }
                
                pagText.text = textObject.text
                
                let style = textObject.style
                pagText.fontSize = Float(style.fontSize)
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
                        pagText.fontFamily = fontFamily
                        pagText.fontStyle = font.fontStyle
                    }
                }
                
                
                replaceText(i, data: pagText)
                LXYPrint(items: "Walrus-PAG：did replaceText with key:\(key) text:\(textObject.text) to index:\(i)")
                return true // Return true to indicate that the text was successfully replaced and break out of the loop.
            }) {
                break // Break out of the outer loop since we've found and processed the matching layer.
            }
        }
    }
}



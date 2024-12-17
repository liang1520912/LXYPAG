//
//  LXYDynamicEntity.swift
//  LXYPAGPlayerSDK
//
//  Created by 梁爱军 on 2024/12/17.
//

import Foundation
// MARK: - LXYPAGFont
class LXYPAGFont: NSObject {
    @objc var fontLocalPath: String?
    @objc var fontFamily: String?
    @objc var fontStyle: String?

    override init() {
        super.init()
    }
}

// MARK: - LXYTextStyle

class LXYTextStyle: NSObject {
    @objc var fontSize: CGFloat = 0.0 // 使用CGFloat而不是NSNumber
    @objc var fillColor: UIColor = .clear

    @objc var fontBold: Bool  = false // 使用Bool而不是NSNumber
    @objc var fontItalic: Bool = false
    @objc var font: LXYPAGFont?

}

// MARK: - LXYDynamicTextObject

public class LXYDynamicTextObject: NSObject {
    @objc var text: String
    @objc var style: LXYTextStyle

    @objc static func objectWithText(_ text: String, style: LXYTextStyle) -> LXYDynamicTextObject {
        let obj = LXYDynamicTextObject(text: text, style: style)
        return obj
    }

    init(text: String, style: LXYTextStyle) {
        self.text = text
        self.style = style
        super.init()
    }
}

// MARK: - LXYDynamicEntity

public class LXYDynamicEntity: NSObject {

    @objc public var dynamicImageMap = [String: UIImage]()
    @objc public var dynamicTextMap = [String: LXYDynamicTextObject]()

    private var listeners = NSHashTable<LXYOnDynamicEntityChangeListenter>.weakObjects()

    // 添加监听器方法
    @objc func addListener(_ listener: LXYOnDynamicEntityChangeListenter) {
//        print("addListener")
        if !listeners.contains(listener) {
            listeners.add(listener)
        }
    }

    // 移除监听器方法
    @objc func removeListener(_ listener: LXYOnDynamicEntityChangeListenter) {
//        print("removeListener")
        listeners.remove(listener)
    }

    // 添加图片替换图层方法
    @objc func addDynamicImage(key: String, image: UIImage) {
//        print("addDynamicImage--key:\(key)")
        dynamicImageMap[key] = image
        notifyListeners { $0.onDynamicImageChange(self, key: key, image: image) }
    }

    // 添加文本替换图层方法
    @objc func addDynamicText(key: String, text: String) {
        addDynamicText(key: key, text: text, style: nil)
    }

    // 添加文本替换图层方法（带样式）
    @objc func addDynamicText(key: String, text: String, style: LXYTextStyle?) {
//        print("addDynamicText--key: \(key), text: \(text), style: \(String(describing: style))")
        let dynamicTextObject = LXYDynamicTextObject.objectWithText(text, style: style ?? LXYTextStyle())
        dynamicTextMap[key] = dynamicTextObject
        notifyListeners { $0.onDynamicTextChange(self, key: key, text: text, style: style) }
    }

    // 通知所有监听器
    private func notifyListeners(action: @escaping (LXYOnDynamicEntityChangeListenter) -> Void) {
        for listener in listeners.allObjects {
            action(listener)
        }
    }
}

//
//  LXYOnDynamicEntityChangeListenter.swift
//  LXYPAGPlayerSDK
//
//  Created by 梁爱军 on 2024/12/17.
//

import Foundation
@objc protocol LXYOnDynamicEntityChangeListenter: AnyObject {
    /// 图片替换图层变化回调
    func onDynamicImageChange(_ dynamicEntity: LXYDynamicEntity, key: String, image: UIImage)
    /// 文本替换图层变化回调
    func onDynamicTextChange(_ dynamicEntity: LXYDynamicEntity, key: String, text: String, style: LXYTextStyle?)
   }


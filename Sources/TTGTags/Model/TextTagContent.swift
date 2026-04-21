//
//  TextTagContent.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// 标签内容基类。请使用子类 `TextTagStringContent` 或 `TextTagAttributedStringContent`。
///
/// 该类保留 `NSObject` 基类与 `NSCopying` 协议，以便 Objective-C 侧继续使用拷贝语义。
@objc(TTGTextTagContent)
open class TextTagContent: NSObject, NSCopying {

    public override init() {
        super.init()
    }

    /// 子类必须重写以返回用于渲染的富文本内容。
    @objc(getContentAttributedString)
    open func getContentAttributedString() -> NSAttributedString {
        assertionFailure("Do not use TextTagContent directly, use a subclass instead.")
        return NSAttributedString()
    }

    /// Swift 风格访问入口，等价于 `getContentAttributedString()`。
    public var contentAttributedString: NSAttributedString {
        getContentAttributedString()
    }

    open func copy(with zone: NSZone? = nil) -> Any {
        return TextTagContent()
    }
}

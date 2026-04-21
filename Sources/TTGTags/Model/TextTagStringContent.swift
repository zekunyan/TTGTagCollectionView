//
//  TextTagStringContent.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// 普通文本内容：自定义字体、颜色。
@objc(TTGTextTagStringContent)
public final class TextTagStringContent: TextTagContent {

    /// 文本内容，默认空串。
    @objc public var text: String = ""
    /// 文本字体，默认系统 14 号字。
    @objc public var textFont: UIFont = .systemFont(ofSize: 14)
    /// 文本颜色，默认黑色。
    @objc public var textColor: UIColor = .black

    public override init() {
        super.init()
    }

    @objc(initWithText:)
    public convenience init(text: String) {
        self.init()
        self.text = text
    }

    @objc(initWithText:textFont:textColor:)
    public convenience init(text: String, textFont: UIFont?, textColor: UIColor?) {
        self.init()
        self.text = text
        if let textFont = textFont { self.textFont = textFont }
        if let textColor = textColor { self.textColor = textColor }
    }

    @objc(contentWithText:)
    public static func content(text: String) -> TextTagStringContent {
        return TextTagStringContent(text: text)
    }

    @objc(contentWithText:textFont:textColor:)
    public static func content(text: String, textFont: UIFont?, textColor: UIColor?) -> TextTagStringContent {
        return TextTagStringContent(text: text, textFont: textFont, textColor: textColor)
    }

    public override func getContentAttributedString() -> NSAttributedString {
        return NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: textColor,
                .font: textFont,
            ]
        )
    }

    public override func copy(with zone: NSZone? = nil) -> Any {
        let copy = TextTagStringContent()
        copy.text = text
        copy.textFont = textFont
        copy.textColor = textColor
        return copy
    }

    public override var description: String {
        return "<\(type(of: self)): text=\(text)>"
    }
}

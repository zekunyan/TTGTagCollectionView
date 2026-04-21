//
//  TextTagAttributedStringContent.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// 富文本内容。
@objc(TTGTextTagAttributedStringContent)
public final class TextTagAttributedStringContent: TextTagContent {

    /// 富文本。默认空串。
    @objc public var attributedText: NSAttributedString = NSAttributedString()

    public override init() {
        super.init()
    }

    @objc(initWithAttributedText:)
    public convenience init(attributedText: NSAttributedString) {
        self.init()
        self.attributedText = attributedText
    }

    @objc(contentWithAttributedText:)
    public static func content(attributedText: NSAttributedString) -> TextTagAttributedStringContent {
        return TextTagAttributedStringContent(attributedText: attributedText)
    }

    public override func getContentAttributedString() -> NSAttributedString {
        return attributedText
    }

    public override func copy(with zone: NSZone? = nil) -> Any {
        let copy = TextTagAttributedStringContent()
        copy.attributedText = attributedText
        return copy
    }

    public override var description: String {
        return "<\(type(of: self)): attributedText=\(attributedText)>"
    }
}

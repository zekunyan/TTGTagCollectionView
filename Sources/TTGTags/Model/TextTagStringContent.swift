//
//  TextTagStringContent.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// Plain text content with custom font and color.
@objc(TTGTextTagStringContent)
public final class TextTagStringContent: TextTagContent {

    /// Text content. Defaults to an empty string.
    @objc public var text: String = ""
    /// Text font. Defaults to system font size 14.
    @objc public var textFont: UIFont = .systemFont(ofSize: 14)
    /// Text color. Defaults to black.
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

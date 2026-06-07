//
//  TextTagAttributedStringContent.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// Attributed string content.
@objc(TTGTextTagAttributedStringContent)
public final class TextTagAttributedStringContent: TextTagContent {

    /// Attributed text. Defaults to an empty attributed string.
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
        // NSAttributedString is immutable, so assignment creates a safe shared reference.
        // If NSMutableAttributedString support is ever added, this must use mutableCopy().
        copy.attributedText = attributedText
        return copy
    }

    public override var description: String {
        return "<\(type(of: self)): attributedText=\(attributedText)>"
    }
}

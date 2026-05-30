//
//  TextTagContent.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// Base class for tag content. Use subclass `TextTagStringContent` or `TextTagAttributedStringContent`.
///
/// Retains `NSObject` base class and `NSCopying` protocol for Objective-C copy semantics.
@objc(TTGTextTagContent)
open class TextTagContent: NSObject, NSCopying {

    public override init() {
        super.init()
    }

    /// Subclasses must override to return the attributed string for rendering.
    @objc(getContentAttributedString)
    open func getContentAttributedString() -> NSAttributedString {
        assertionFailure("Do not use TextTagContent directly, use a subclass instead.")
        return NSAttributedString()
    }

    /// Swift-style access, equivalent to `getContentAttributedString()`.
    public var contentAttributedString: NSAttributedString {
        getContentAttributedString()
    }

    open func copy(with zone: NSZone? = nil) -> Any {
        assertionFailure("Do not use TextTagContent directly, use a subclass instead.")
        return TextTagContent()
    }
}

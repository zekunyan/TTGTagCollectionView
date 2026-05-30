//
//  TextTag.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// Callback for selection state changes.
public typealias OnSelectStateChanged = (_ selected: Bool) -> Void

/// Thread-safe auto-incrementing tagId provider.
enum TagIDProvider {
    private static let lock = NSLock()
    private static var current: Int = 0

    static func next() -> Int {
        lock.lock()
        defer { lock.unlock() }
        let value = current
        current &+= 1
        return value
    }
}

/// Text tag data model.
///
/// Uses `tagId` as the unique identifier for equality comparison; the id is
/// automatically assigned during `init` and `copy`.
@objc(TTGTextTag)
public final class TextTag: NSObject, NSCopying {

    /// Unique identifier, auto-incremented.
    @objc public private(set) var tagId: Int

    /// Custom attachment object for business use.
    @objc public var attachment: AnyObject?

    /// Normal state content and style.
    @objc public var content: TextTagContent
    @objc public var style: TextTagStyle

    /// Lock protecting lazy initialization of selectedContent and selectedStyle.
    private let propertyLock = NSLock()

    /// Selected state content (falls back to a copy of normal content if not set).
    @objc public var selectedContent: TextTagContent {
        get {
            propertyLock.lock()
            defer { propertyLock.unlock() }
            if let existing = _selectedContent { return existing }
            let fallback = (content.copy() as? TextTagContent) ?? TextTagContent()
            _selectedContent = fallback
            return fallback
        }
        set {
            propertyLock.lock()
            defer { propertyLock.unlock() }
            _selectedContent = newValue
        }
    }
    private var _selectedContent: TextTagContent?

    /// Selected state style (falls back to a copy of normal style if not set).
    @objc public var selectedStyle: TextTagStyle {
        get {
            propertyLock.lock()
            defer { propertyLock.unlock() }
            if let existing = _selectedStyle { return existing }
            let fallback = (style.copy() as? TextTagStyle) ?? TextTagStyle()
            _selectedStyle = fallback
            return fallback
        }
        set {
            propertyLock.lock()
            defer { propertyLock.unlock() }
            _selectedStyle = newValue
        }
    }
    private var _selectedStyle: TextTagStyle?

    /// Selection state. Triggers callback on change.
    @objc public var selected: Bool = false {
        didSet { onSelectStateChanged?(selected) }
    }

    /// Selection state change callback.
    @objc public var onSelectStateChanged: OnSelectStateChanged?

    // MARK: - Accessibility

    @objc public var enableAutoDetectAccessibility: Bool = false

    @objc public override var isAccessibilityElement: Bool {
        get { return enableAutoDetectAccessibility || _isAccessibilityElement }
        set { _isAccessibilityElement = newValue }
    }
    private var _isAccessibilityElement: Bool = false

    @objc public var accessibilityIdentifier: String?

    @objc public override var accessibilityLabel: String? {
        get {
            if enableAutoDetectAccessibility {
                return rightfulContent.getContentAttributedString().string
            }
            return _accessibilityLabel
        }
        set { _accessibilityLabel = newValue }
    }
    private var _accessibilityLabel: String?

    @objc public override var accessibilityHint: String? {
        get { return _accessibilityHint }
        set { _accessibilityHint = newValue }
    }
    private var _accessibilityHint: String?

    @objc public override var accessibilityValue: String? {
        get { return _accessibilityValue }
        set { _accessibilityValue = newValue }
    }
    private var _accessibilityValue: String?

    @objc public override var accessibilityTraits: UIAccessibilityTraits {
        get {
            if enableAutoDetectAccessibility {
                return selected ? .selected : .button
            }
            return _accessibilityTraits
        }
        set { _accessibilityTraits = newValue }
    }
    private var _accessibilityTraits: UIAccessibilityTraits = []

    // MARK: - Initialization

    @objc public override init() {
        self.tagId = TagIDProvider.next()
        self.content = TextTagContent()
        self.style = TextTagStyle()
        super.init()
    }

    @objc(initWithContent:style:)
    public convenience init(content: TextTagContent, style: TextTagStyle) {
        self.init()
        self.content = content
        self.style = style
    }

    @objc(initWithContent:style:selectedContent:selectedStyle:)
    public convenience init(
        content: TextTagContent,
        style: TextTagStyle,
        selectedContent: TextTagContent?,
        selectedStyle: TextTagStyle?
    ) {
        self.init()
        self.content = content
        self.style = style
        self._selectedContent = selectedContent
        self._selectedStyle = selectedStyle
    }

    @objc(tagWithContent:style:)
    public static func tag(content: TextTagContent, style: TextTagStyle) -> TextTag {
        return TextTag(content: content, style: style)
    }

    @objc(tagWithContent:style:selectedContent:selectedStyle:)
    public static func tag(
        content: TextTagContent,
        style: TextTagStyle,
        selectedContent: TextTagContent?,
        selectedStyle: TextTagStyle?
    ) -> TextTag {
        return TextTag(
            content: content,
            style: style,
            selectedContent: selectedContent,
            selectedStyle: selectedStyle
        )
    }

    // MARK: - State Access

    /// Content for the current active state.
    @objc(getRightfulContent)
    public func getRightfulContent() -> TextTagContent {
        return selected ? selectedContent : content
    }

    /// Style for the current active state.
    @objc(getRightfulStyle)
    public func getRightfulStyle() -> TextTagStyle {
        return selected ? selectedStyle : style
    }

    /// Swift-style property access.
    public var rightfulContent: TextTagContent { getRightfulContent() }
    public var rightfulStyle: TextTagStyle { getRightfulStyle() }

    // MARK: - Equality / Hash

    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? TextTag else { return false }
        return isEqual(to: other)
    }

    @objc(isEqualToTag:)
    public func isEqual(to tag: TextTag?) -> Bool {
        guard let tag = tag else { return false }
        if self === tag { return true }
        return self.tagId == tag.tagId
    }

    public override var hash: Int {
        return tagId
    }

    // MARK: - NSCopying

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = TextTag()
        copy.attachment = attachment
        copy.content = (content.copy(with: zone) as? TextTagContent) ?? content
        copy.style = (style.copy(with: zone) as? TextTagStyle) ?? style
        copy.selected = selected

        propertyLock.lock()
        let sc = _selectedContent
        let ss = _selectedStyle
        propertyLock.unlock()

        copy._selectedContent = sc?.copy(with: zone) as? TextTagContent
        copy._selectedStyle = ss?.copy(with: zone) as? TextTagStyle
        copy._isAccessibilityElement = _isAccessibilityElement
        copy.accessibilityIdentifier = accessibilityIdentifier
        copy._accessibilityLabel = _accessibilityLabel
        copy._accessibilityHint = _accessibilityHint
        copy._accessibilityValue = _accessibilityValue
        copy._accessibilityTraits = _accessibilityTraits
        copy.enableAutoDetectAccessibility = enableAutoDetectAccessibility
        return copy
    }
}

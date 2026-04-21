//
//  TextTag.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// 选中状态变化回调。
public typealias OnSelectStateChanged = (_ selected: Bool) -> Void

/// 线程安全的 tagId 自增器。
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

/// 文本标签数据模型。
///
/// 通过 `tagId` 作为唯一标识参与相等性比较；该 id 在 `init` 和 `copy` 时自动分配。
@objc(TTGTextTag)
public final class TextTag: NSObject, NSCopying {

    /// 唯一标识，递增分配。
    @objc public private(set) var tagId: Int

    /// 业务自定义挂载对象。
    @objc public var attachment: Any?

    /// 普通态内容与样式。
    @objc public var content: TextTagContent
    @objc public var style: TextTagStyle

    /// 选中态内容（未设置时回退到普通态内容的拷贝）。
    @objc public var selectedContent: TextTagContent {
        get {
            if let existing = _selectedContent { return existing }
            let fallback = (content.copy() as? TextTagContent) ?? TextTagContent()
            _selectedContent = fallback
            return fallback
        }
        set { _selectedContent = newValue }
    }
    private var _selectedContent: TextTagContent?

    /// 选中态样式（未设置时回退到普通态样式的拷贝）。
    @objc public var selectedStyle: TextTagStyle {
        get {
            if let existing = _selectedStyle { return existing }
            let fallback = (style.copy() as? TextTagStyle) ?? TextTagStyle()
            _selectedStyle = fallback
            return fallback
        }
        set { _selectedStyle = newValue }
    }
    private var _selectedStyle: TextTagStyle?

    /// 选中态。变更时触发回调。
    @objc public var selected: Bool = false {
        didSet { onSelectStateChanged?(selected) }
    }

    /// 选中态变化回调。
    @objc public var onSelectStateChanged: OnSelectStateChanged?

    // MARK: - 可访问性

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

    // MARK: - 初始化

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

    // MARK: - 状态访问

    /// 当前激活态对应的 content。
    @objc(getRightfulContent)
    public func getRightfulContent() -> TextTagContent {
        return selected ? selectedContent : content
    }

    /// 当前激活态对应的 style。
    @objc(getRightfulStyle)
    public func getRightfulStyle() -> TextTagStyle {
        return selected ? selectedStyle : style
    }

    /// Swift 风格访问。
    public var rightfulContent: TextTagContent { getRightfulContent() }
    public var rightfulStyle: TextTagStyle { getRightfulStyle() }

    // MARK: - 相等 / 哈希

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
        copy.content = content
        copy.style = style
        copy.selected = selected
        copy._selectedContent = _selectedContent
        copy._selectedStyle = _selectedStyle
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

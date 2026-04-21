//
//  TextTagStyle.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// 标签外观样式。
@objc(TTGTextTagStyle)
public final class TextTagStyle: NSObject, NSCopying {

    // MARK: - 背景

    /// 背景色。默认 `UIColor.lightGray`。
    @objc public var backgroundColor: UIColor = .lightGray

    /// 文本对齐。默认居中。
    @objc public var textAlignment: NSTextAlignment = .center

    // MARK: - 渐变背景

    @objc public var enableGradientBackground: Bool = false
    @objc public var gradientBackgroundStartColor: UIColor = .clear
    @objc public var gradientBackgroundEndColor: UIColor = .clear
    @objc public var gradientBackgroundStartPoint: CGPoint = .zero
    @objc public var gradientBackgroundEndPoint: CGPoint = .zero

    // MARK: - 圆角

    /// 圆角半径，默认 4。
    @objc public var cornerRadius: CGFloat = 4
    @objc public var cornerTopRight: Bool = false
    @objc public var cornerTopLeft: Bool = false
    @objc public var cornerBottomRight: Bool = false
    @objc public var cornerBottomLeft: Bool = false

    // MARK: - 边框

    /// 边框线宽，默认 1。
    @objc public var borderWidth: CGFloat = 1
    /// 边框颜色，默认白色。
    @objc public var borderColor: UIColor = .white

    // MARK: - 阴影

    @objc public var shadowColor: UIColor = .black
    @objc public var shadowOffset: CGSize = CGSize(width: 2, height: 2)
    @objc public var shadowRadius: CGFloat = 2
    @objc public var shadowOpacity: CGFloat = 0.3

    // MARK: - 尺寸

    /// 额外撑开的空白。
    @objc public var extraSpace: CGSize = .zero

    /// 宽度上下限，<=0 表示不限制。
    @objc public var maxWidth: CGFloat = 0
    @objc public var minWidth: CGFloat = 0

    /// 高度上下限，<=0 表示不限制。
    @objc public var maxHeight: CGFloat = 0
    @objc public var minHeight: CGFloat = 0

    /// 精确宽/高，>0 表示强制。
    @objc public var exactWidth: CGFloat = 0
    @objc public var exactHeight: CGFloat = 0

    public override init() {
        super.init()
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = TextTagStyle()
        copy.backgroundColor = backgroundColor
        copy.textAlignment = textAlignment
        copy.enableGradientBackground = enableGradientBackground
        copy.gradientBackgroundStartColor = gradientBackgroundStartColor
        copy.gradientBackgroundEndColor = gradientBackgroundEndColor
        copy.gradientBackgroundStartPoint = gradientBackgroundStartPoint
        copy.gradientBackgroundEndPoint = gradientBackgroundEndPoint
        copy.cornerRadius = cornerRadius
        copy.cornerTopRight = cornerTopRight
        copy.cornerTopLeft = cornerTopLeft
        copy.cornerBottomRight = cornerBottomRight
        copy.cornerBottomLeft = cornerBottomLeft
        copy.borderWidth = borderWidth
        copy.borderColor = borderColor
        copy.shadowColor = shadowColor
        copy.shadowOffset = shadowOffset
        copy.shadowRadius = shadowRadius
        copy.shadowOpacity = shadowOpacity
        copy.extraSpace = extraSpace
        copy.maxWidth = maxWidth
        copy.minWidth = minWidth
        copy.maxHeight = maxHeight
        copy.minHeight = minHeight
        copy.exactWidth = exactWidth
        copy.exactHeight = exactHeight
        return copy
    }
}

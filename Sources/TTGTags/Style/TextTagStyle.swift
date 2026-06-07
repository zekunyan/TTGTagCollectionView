//
//  TextTagStyle.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// Tag appearance style.
@objc(TTGTextTagStyle)
public final class TextTagStyle: NSObject, NSCopying {

    // MARK: - Background

    /// Background color. Defaults to `UIColor.systemBlue`.
    @objc public var backgroundColor: UIColor = .systemBlue

    /// Text alignment. Defaults to center.
    @objc public var textAlignment: NSTextAlignment = .center

    // MARK: - Gradient Background

    @objc public var enableGradientBackground: Bool = false
    @objc public var gradientBackgroundStartColor: UIColor = .clear
    @objc public var gradientBackgroundEndColor: UIColor = .clear
    @objc public var gradientBackgroundStartPoint: CGPoint = .zero
    @objc public var gradientBackgroundEndPoint: CGPoint = .zero

    // MARK: - Corner Radius

    /// Corner radius. Defaults to 14.
    @objc public var cornerRadius: CGFloat = 14
    @objc public var cornerTopRight: Bool = false
    @objc public var cornerTopLeft: Bool = false
    @objc public var cornerBottomRight: Bool = false
    @objc public var cornerBottomLeft: Bool = false

    // MARK: - Border

    /// Border line width. Defaults to 1.
    @objc public var borderWidth: CGFloat = 1
    /// Border color. Defaults to white.
    @objc public var borderColor: UIColor = .white

    // MARK: - Shadow

    @objc public var shadowColor: UIColor = .black
    @objc public var shadowOffset: CGSize = CGSize(width: 2, height: 2)
    @objc public var shadowRadius: CGFloat = 2
    @objc public var shadowOpacity: CGFloat = 0.3

    // MARK: - Size

    /// Extra padding space around the content. Defaults to `CGSize(width: 12, height: 6)`.
    @objc public var extraSpace: CGSize = CGSize(width: 12, height: 6)

    /// Width constraints. <=0 means no limit.
    @objc public var maxWidth: CGFloat = 0
    @objc public var minWidth: CGFloat = 0

    /// Height constraints. <=0 means no limit.
    @objc public var maxHeight: CGFloat = 0
    @objc public var minHeight: CGFloat = 0

    /// Exact width/height. >0 means forced.
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

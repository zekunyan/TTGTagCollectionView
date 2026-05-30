//
//  TextTagComponentView.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// Internal view component for a text tag: hosts the content and style of a single `TextTag`.
final class TextTagComponentView: UIView {

    var config: TextTag?

    private(set) lazy var label: TextTagGradientLabel = {
        let label = TextTagGradientLabel(frame: bounds)
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.isAccessibilityElement = false
        return label
    }()

    private var borderLayer: CAShapeLayer?
    private var maskLayer: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(label)
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds

        let path = makePath()
        updateMask(with: path)
        updateBorder(with: path)
        updateShadow(with: path)
    }

    override var intrinsicContentSize: CGSize {
        return label.intrinsicContentSize
    }

    // MARK: - Apply Configuration

    func updateContent() {
        guard let config = config else { return }
        label.attributedText = config.getRightfulContent().getContentAttributedString()
    }

    func updateContentStyle() {
        guard let style = config?.getRightfulStyle() else { return }

        label.backgroundColor = style.backgroundColor
        label.textAlignment = style.textAlignment

        if style.enableGradientBackground, let gradientLayer = label.layer as? CAGradientLayer {
            label.backgroundColor = .clear
            gradientLayer.backgroundColor = UIColor.clear.cgColor
            gradientLayer.colors = [
                style.gradientBackgroundStartColor.cgColor,
                style.gradientBackgroundEndColor.cgColor,
            ]
            gradientLayer.startPoint = style.gradientBackgroundStartPoint
            gradientLayer.endPoint = style.gradientBackgroundEndPoint
        }
    }

    func updateFrame(maxSize: CGSize) {
        guard let style = config?.getRightfulStyle() else { return }

        label.sizeToFit()
        var finalSize = label.frame.size

        finalSize.width += style.extraSpace.width
        finalSize.height += style.extraSpace.height

        if style.maxWidth > 0, finalSize.width > style.maxWidth {
            finalSize.width = style.maxWidth
        }
        if style.minWidth > 0, finalSize.width < style.minWidth {
            finalSize.width = style.minWidth
        }
        if style.exactWidth > 0 {
            finalSize.width = style.exactWidth
        }
        if style.exactHeight > 0 {
            finalSize.height = style.exactHeight
        }

        if maxSize.width > 0 {
            finalSize.width = min(maxSize.width, finalSize.width)
        }
        if maxSize.height > 0 {
            finalSize.height = min(maxSize.height, finalSize.height)
        }

        var newFrame = frame
        newFrame.size = finalSize
        frame = newFrame
        label.frame = bounds
    }

    func updateAccessibility() {
        guard let config = config else { return }
        isAccessibilityElement = config.isAccessibilityElement
        accessibilityIdentifier = config.accessibilityIdentifier
        accessibilityLabel = config.accessibilityLabel
        accessibilityHint = config.accessibilityHint
        accessibilityValue = config.accessibilityValue
        accessibilityTraits = config.accessibilityTraits
    }

    // MARK: - Path & Decoration

    /// Generates the bezier path for the current corner radius configuration.
    ///
    /// The original OC implementation used `UIRectCorner = -1` as the initial value
    /// then applied bitwise OR, which had a logic pitfall (initial value equals allCorners).
    /// Migrated to start with an empty set and insert as needed for clearer semantics.
    private func makePath() -> UIBezierPath {
        guard let style = config?.getRightfulStyle() else {
            return UIBezierPath(rect: bounds)
        }

        var corners: UIRectCorner = []
        if style.cornerTopLeft { corners.insert(.topLeft) }
        if style.cornerTopRight { corners.insert(.topRight) }
        if style.cornerBottomLeft { corners.insert(.bottomLeft) }
        if style.cornerBottomRight { corners.insert(.bottomRight) }

        // Backward compatible: when no corners are explicitly set, treat as all corners rounded.
        if corners.isEmpty {
            corners = .allCorners
        }

        let radius = style.cornerRadius
        return UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
    }

    private func updateMask(with path: UIBezierPath) {
        let layer = maskLayer ?? CAShapeLayer()
        layer.frame = bounds
        layer.path = path.cgPath
        self.label.layer.mask = layer
        maskLayer = layer
    }

    private func updateBorder(with path: UIBezierPath) {
        guard let style = config?.getRightfulStyle() else { return }

        let layerToUse: CAShapeLayer
        if let existing = borderLayer {
            layerToUse = existing
        } else {
            layerToUse = CAShapeLayer()
            layerToUse.fillColor = UIColor.clear.cgColor
            layerToUse.lineCap = .round
            layerToUse.lineJoin = .round
            layer.addSublayer(layerToUse)
            borderLayer = layerToUse
        }

        layerToUse.frame = bounds
        layerToUse.path = path.cgPath
        layerToUse.lineWidth = style.borderWidth
        layerToUse.strokeColor = style.borderColor.cgColor
    }

    private func updateShadow(with path: UIBezierPath) {
        guard let style = config?.getRightfulStyle() else { return }

        layer.shadowColor = style.shadowColor.cgColor
        layer.shadowOffset = style.shadowOffset
        layer.shadowRadius = style.shadowRadius
        layer.shadowOpacity = Float(style.shadowOpacity)
        layer.shadowPath = path.cgPath
    }

    // MARK: - Equality

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? TextTagComponentView else { return false }
        if self === other { return true }
        guard let lhs = self.config, let rhs = other.config else {
            return self.config == nil && other.config == nil
        }
        return lhs.isEqual(to: rhs)
    }

    override var hash: Int {
        return config?.hash ?? 0
    }
}

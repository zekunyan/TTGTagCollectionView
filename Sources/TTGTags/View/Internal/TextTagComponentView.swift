//
//  TextTagComponentView.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// 文本标签内部视图单元：承载一个 `TextTag` 的内容与样式。
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

    // MARK: - 配置应用

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

    // MARK: - 路径与装饰

    /// 生成当前圆角配置对应的路径。
    ///
    /// 原 OC 实现用 `UIRectCorner = -1` 起始再按位或存在逻辑隐患（初值等价 allCorners），
    /// 迁移时改为空集起始、按需 insert，语义更清晰。
    private func makePath() -> UIBezierPath {
        guard let style = config?.getRightfulStyle() else {
            return UIBezierPath(rect: bounds)
        }

        var corners: UIRectCorner = []
        if style.cornerTopLeft { corners.insert(.topLeft) }
        if style.cornerTopRight { corners.insert(.topRight) }
        if style.cornerBottomLeft { corners.insert(.bottomLeft) }
        if style.cornerBottomRight { corners.insert(.bottomRight) }

        // 与原实现保持兼容：未显式设置任何角时，视作四角同时圆角。
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
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        label.layer.mask = maskLayer
    }

    private func updateBorder(with path: UIBezierPath) {
        guard let style = config?.getRightfulStyle() else { return }

        borderLayer?.removeFromSuperlayer()
        let layerToUse = borderLayer ?? CAShapeLayer()
        layerToUse.frame = bounds
        layerToUse.path = path.cgPath
        layerToUse.fillColor = UIColor.clear.cgColor
        layerToUse.opacity = 1
        layerToUse.lineWidth = style.borderWidth
        layerToUse.strokeColor = style.borderColor.cgColor
        layerToUse.lineCap = .round
        layerToUse.lineJoin = .round
        layer.addSublayer(layerToUse)
        borderLayer = layerToUse
    }

    private func updateShadow(with path: UIBezierPath) {
        guard let style = config?.getRightfulStyle() else { return }

        layer.shadowColor = style.shadowColor.cgColor
        layer.shadowOffset = style.shadowOffset
        layer.shadowRadius = style.shadowRadius
        layer.shadowOpacity = Float(style.shadowOpacity)
        layer.shadowPath = path.cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    // MARK: - 相等性

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

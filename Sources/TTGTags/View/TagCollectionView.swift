//
//  TagCollectionView.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

// MARK: - 枚举

/// 标签滚动方向。
@objc(TTGTagCollectionScrollDirection)
public enum TagCollectionScrollDirection: Int {
    case vertical = 0
    case horizontal = 1
}

/// 标签对齐方式。
@objc(TTGTagCollectionAlignment)
public enum TagCollectionAlignment: Int {
    /// 左对齐（默认）。
    case left = 0
    /// 居中对齐。
    case center
    /// 右对齐。
    case right
    /// 撑开 tag 之间的水平间距以填满每行。
    case fillByExpandingSpace
    /// 撑开每个 tag 的宽度以填满每行。
    case fillByExpandingWidth
    /// 撑开每个 tag 的宽度以填满每行，最后一行除外。
    case fillByExpandingWidthExceptLastLine
}

// MARK: - 协议

/// 数据源协议。
@objc(TTGTagCollectionViewDataSource)
public protocol TagCollectionViewDataSource: AnyObject {

    @objc(numberOfTagsInTagCollectionView:)
    func numberOfTags(in tagCollectionView: TagCollectionView) -> Int

    @objc(tagCollectionView:tagViewForIndex:)
    func tagCollectionView(_ tagCollectionView: TagCollectionView, tagViewFor index: Int) -> UIView
}

/// 代理协议。
@objc(TTGTagCollectionViewDelegate)
public protocol TagCollectionViewDelegate: AnyObject {

    @objc(tagCollectionView:sizeForTagAtIndex:)
    func tagCollectionView(_ tagCollectionView: TagCollectionView, sizeForTagAt index: Int) -> CGSize

    @objc(tagCollectionView:shouldSelectTag:atIndex:)
    optional func tagCollectionView(_ tagCollectionView: TagCollectionView, shouldSelectTag tagView: UIView, at index: Int) -> Bool

    @objc(tagCollectionView:didSelectTag:atIndex:)
    optional func tagCollectionView(_ tagCollectionView: TagCollectionView, didSelectTag tagView: UIView, at index: Int)

    @objc(tagCollectionView:updateContentSize:)
    optional func tagCollectionView(_ tagCollectionView: TagCollectionView, updateContentSize contentSize: CGSize)
}

// MARK: - 视图

/// 通用标签集合视图。
@objc(TTGTagCollectionView)
public final class TagCollectionView: UIView {

    // MARK: 公共属性

    @objc public weak var dataSource: TagCollectionViewDataSource?
    @objc public weak var delegate: TagCollectionViewDelegate?

    /// 内置的 `UIScrollView`。
    @objc public private(set) var scrollView: UIScrollView!

    /// 滚动方向。默认垂直。
    @objc public var scrollDirection: TagCollectionScrollDirection = .vertical {
        didSet { setNeedsLayoutTagViews() }
    }

    /// 对齐方式。默认左对齐。
    @objc public var alignment: TagCollectionAlignment = .left {
        didSet { setNeedsLayoutTagViews() }
    }

    /// 行数限制。0 表示不限制，水平滚动时最小取 1。
    @objc public var numberOfLines: Int = 0 {
        didSet { setNeedsLayoutTagViews() }
    }

    /// 实际渲染的行数（水平滚动时返回 numberOfLines）。
    @objc public var actualNumberOfLines: Int {
        if scrollDirection == .horizontal {
            return numberOfLines
        }
        return _actualNumberOfLines
    }
    private var _actualNumberOfLines: Int = 0

    /// 水平/垂直间距，默认 4。
    @objc public var horizontalSpacing: CGFloat = 4 {
        didSet { setNeedsLayoutTagViews() }
    }
    @objc public var verticalSpacing: CGFloat = 4 {
        didSet { setNeedsLayoutTagViews() }
    }

    /// 内容 padding，默认 (2, 2, 2, 2)。
    @objc public var contentInset: UIEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2) {
        didSet { setNeedsLayoutTagViews() }
    }

    /// 实际内容尺寸。访问时会触发一次布局。
    @objc public var contentSize: CGSize {
        layoutTagViews()
        return scrollView.contentSize
    }

    /// 是否手动计算高度。
    @objc public var manualCalculateHeight: Bool = false {
        didSet { setNeedsLayoutTagViews() }
    }

    /// 手动计算高度时使用的最大宽度。
    @objc public var preferredMaxLayoutWidth: CGFloat = 0 {
        didSet { setNeedsLayoutTagViews() }
    }

    @objc public var showsHorizontalScrollIndicator: Bool {
        get { scrollView.showsHorizontalScrollIndicator }
        set { scrollView.showsHorizontalScrollIndicator = newValue }
    }

    @objc public var showsVerticalScrollIndicator: Bool {
        get { scrollView.showsVerticalScrollIndicator }
        set { scrollView.showsVerticalScrollIndicator = newValue }
    }

    /// 点击空白区域回调。
    @objc public var onTapBlankArea: ((CGPoint) -> Void)?
    /// 点击任意位置回调。
    @objc public var onTapAllArea: ((CGPoint) -> Void)?

    // MARK: 私有属性

    private var containerView: UIView!
    private var needsLayoutTagViews = false

    // MARK: Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        scrollView = UIScrollView(frame: bounds)
        scrollView.backgroundColor = .clear
        scrollView.isUserInteractionEnabled = true
        addSubview(scrollView)

        containerView = UIView(frame: scrollView.bounds)
        containerView.backgroundColor = .clear
        containerView.isUserInteractionEnabled = true
        scrollView.addSubview(containerView)

        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapGesture(_:)))
        containerView.addGestureRecognizer(tap)

        setNeedsLayoutTagViews()
    }

    // MARK: Override

    public override func layoutSubviews() {
        super.layoutSubviews()

        if !scrollView.frame.equalTo(bounds) {
            scrollView.frame = bounds
            setNeedsLayoutTagViews()
            layoutTagViews()
            containerView.frame = CGRect(origin: .zero, size: scrollView.contentSize)
        }
        layoutTagViews()
    }

    public override var intrinsicContentSize: CGSize {
        return scrollView.contentSize
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return contentSize
    }

    // MARK: Public methods

    /// 重新加载所有 tag 视图。
    @objc public func reload() {
        guard isDelegateAndDataSourceValid, let dataSource = dataSource else { return }

        containerView.subviews.forEach { $0.removeFromSuperview() }

        let count = dataSource.numberOfTags(in: self)
        for i in 0..<count {
            let view = dataSource.tagCollectionView(self, tagViewFor: i)
            containerView.addSubview(view)
        }

        setNeedsLayoutTagViews()
        layoutTagViews()
    }

    /// 返回指定点位置的 tag 下标，未命中返回 `NSNotFound`。
    @objc(indexOfTagAt:)
    public func indexOfTag(at point: CGPoint) -> Int {
        guard let dataSource = dataSource else { return NSNotFound }
        let convertedPoint = convert(point, to: containerView)
        let count = dataSource.numberOfTags(in: self)
        for i in 0..<count {
            let tagView = dataSource.tagCollectionView(self, tagViewFor: i)
            if tagView.frame.contains(convertedPoint) && !tagView.isHidden {
                return i
            }
        }
        return NSNotFound
    }

    // MARK: Gesture

    @objc private func onTapGesture(_ gesture: UITapGestureRecognizer) {
        let pointInCollection = gesture.location(in: self)

        guard let dataSource = dataSource, let delegate = delegate else {
            onTapBlankArea?(pointInCollection)
            onTapAllArea?(pointInCollection)
            return
        }

        let pointInContainer = gesture.location(in: containerView)
        var hasLocatedToTag = false

        let count = dataSource.numberOfTags(in: self)
        for i in 0..<count {
            let tagView = dataSource.tagCollectionView(self, tagViewFor: i)
            if tagView.frame.contains(pointInContainer) && !tagView.isHidden {
                hasLocatedToTag = true
                let allowed = delegate.tagCollectionView?(self, shouldSelectTag: tagView, at: i) ?? true
                if allowed {
                    delegate.tagCollectionView?(self, didSelectTag: tagView, at: i)
                }
            }
        }

        if !hasLocatedToTag {
            onTapBlankArea?(pointInCollection)
        }
        onTapAllArea?(pointInCollection)
    }

    // MARK: Layout

    private func setNeedsLayoutTagViews() {
        needsLayoutTagViews = true
    }

    private func layoutTagViews() {
        guard needsLayoutTagViews, isDelegateAndDataSourceValid,
              let dataSource = dataSource, let delegate = delegate else {
            return
        }

        let count = dataSource.numberOfTags(in: self)
        var tagSizes: [CGSize] = []
        tagSizes.reserveCapacity(count)
        for i in 0..<count {
            tagSizes.append(delegate.tagCollectionView(self, sizeForTagAt: i))
        }

        let containerWidth = (manualCalculateHeight && preferredMaxLayoutWidth > 0)
            ? preferredMaxLayoutWidth
            : bounds.width

        let input = TagCollectionLayout.Input(
            tagSizes: tagSizes,
            scrollDirection: scrollDirection,
            alignment: alignment,
            numberOfLines: numberOfLines,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            contentInset: contentInset,
            containerWidth: containerWidth
        )

        let output = TagCollectionLayout.calculate(input)

        for tagFrame in output.tagFrames {
            let view = dataSource.tagCollectionView(self, tagViewFor: tagFrame.index)
            view.isHidden = tagFrame.hidden
            if !tagFrame.hidden {
                view.frame = tagFrame.frame
            }
        }

        _actualNumberOfLines = output.actualNumberOfLines

        if !scrollView.contentSize.equalTo(output.contentSize) {
            scrollView.contentSize = output.contentSize
            containerView.frame = CGRect(origin: .zero, size: output.contentSize)
            delegate.tagCollectionView?(self, updateContentSize: output.contentSize)
        }

        needsLayoutTagViews = false
        invalidateIntrinsicContentSize()
    }

    // MARK: - Validation

    private var isDelegateAndDataSourceValid: Bool {
        return delegate != nil && dataSource != nil
    }
}

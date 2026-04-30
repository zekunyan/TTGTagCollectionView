//
//  TagCollectionView.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

// MARK: - Enums

/// Tag scroll direction.
@objc(TTGTagCollectionScrollDirection)
public enum TagCollectionScrollDirection: Int {
    case vertical = 0
    case horizontal = 1
}

/// Tag alignment mode.
@objc(TTGTagCollectionAlignment)
public enum TagCollectionAlignment: Int {
    /// Left-aligned (default).
    case left = 0
    /// Center-aligned.
    case center
    /// Right-aligned.
    case right
    /// Expand horizontal spacing between tags to fill each line.
    case fillByExpandingSpace
    /// Expand each tag's width to fill each line.
    case fillByExpandingWidth
    /// Expand each tag's width to fill each line, except the last line.
    case fillByExpandingWidthExceptLastLine
}

// MARK: - Protocols

/// Data source protocol.
@objc(TTGTagCollectionViewDataSource)
public protocol TagCollectionViewDataSource: AnyObject {

    @objc(numberOfTagsInTagCollectionView:)
    func numberOfTags(in tagCollectionView: TagCollectionView) -> Int

    @objc(tagCollectionView:tagViewForIndex:)
    func tagCollectionView(_ tagCollectionView: TagCollectionView, tagViewFor index: Int) -> UIView
}

/// Delegate protocol.
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

// MARK: - View

/// General-purpose tag collection view.
@objc(TTGTagCollectionView)
public final class TagCollectionView: UIView {

    // MARK: Public Properties

    @objc public weak var dataSource: TagCollectionViewDataSource?
    @objc public weak var delegate: TagCollectionViewDelegate?

    /// Built-in `UIScrollView`.
    @objc public private(set) var scrollView: UIScrollView!

    /// Scroll direction. Defaults to vertical.
    @objc public var scrollDirection: TagCollectionScrollDirection = .vertical {
        didSet { setNeedsLayoutTagViews() }
    }

    /// Alignment mode. Defaults to left.
    @objc public var alignment: TagCollectionAlignment = .left {
        didSet { setNeedsLayoutTagViews() }
    }

    /// Maximum number of lines. 0 means no limit; minimum is 1 for horizontal scroll.
    @objc public var numberOfLines: Int = 0 {
        didSet { setNeedsLayoutTagViews() }
    }

    /// Actual number of rendered lines.
    @objc public var actualNumberOfLines: Int {
        return _actualNumberOfLines
    }
    private var _actualNumberOfLines: Int = 0

    /// Horizontal/vertical spacing. Defaults to 4.
    @objc public var horizontalSpacing: CGFloat = 4 {
        didSet { setNeedsLayoutTagViews() }
    }
    @objc public var verticalSpacing: CGFloat = 4 {
        didSet { setNeedsLayoutTagViews() }
    }

    /// Content padding. Defaults to (2, 2, 2, 2).
    @objc public var contentInset: UIEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2) {
        didSet { setNeedsLayoutTagViews() }
    }

    /// Actual content size. Accessing this triggers a layout pass.
    @objc public var contentSize: CGSize {
        layoutTagViews()
        return scrollView.contentSize
    }

    /// Whether to manually calculate height.
    @objc public var manualCalculateHeight: Bool = false {
        didSet { setNeedsLayoutTagViews() }
    }

    /// Maximum width used when manually calculating height.
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

    /// Callback when tapping a blank area.
    @objc public var onTapBlankArea: ((CGPoint) -> Void)?
    /// Callback when tapping anywhere.
    @objc public var onTapAllArea: ((CGPoint) -> Void)?

    // MARK: Private Properties

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

    /// Reload all tag views.
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

    /// Returns the index of the tag at the given point, or `NSNotFound` if no tag is hit.
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

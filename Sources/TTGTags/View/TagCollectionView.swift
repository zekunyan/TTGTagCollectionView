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

    /// Actual content size. Triggers a layout pass to ensure up-to-date results.
    @objc public var contentSize: CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        return scrollView.contentSize
    }

    /// Whether to manually calculate height.
    @objc public var manualCalculateHeight: Bool = false {
        didSet { setNeedsLayoutTagViews() }
    }

    /// Maximum width used when manually calculating height.
    /// Also used by `intrinsicContentSize` to compute height at a known width
    /// (mirroring `UILabel.preferredMaxLayoutWidth`).
    @objc public var preferredMaxLayoutWidth: CGFloat = 0 {
        didSet {
            setNeedsLayoutTagViews()
            invalidateIntrinsicContentSize()
        }
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
    private var _tagViews: [UIView] = []
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

        let boundsChanged = !scrollView.frame.equalTo(bounds)
        if boundsChanged {
            scrollView.frame = bounds
            setNeedsLayoutTagViews()
        }
        layoutTagViews()

        // Keep containerView sized to content for hit-testing
        if !containerView.frame.size.equalTo(scrollView.contentSize) {
            containerView.frame = CGRect(origin: .zero, size: scrollView.contentSize)
        }

        // When bounds width changes, intrinsic height may change too
        if boundsChanged {
            invalidateIntrinsicContentSize()
        }
    }

    /// Intrinsic content size for Auto Layout.
    ///
    /// When `preferredMaxLayoutWidth` is set, the height is computed at that width
    /// (mirroring `UILabel.preferredMaxLayoutWidth` behaviour). Otherwise the
    /// current `bounds.width` is used, which is correct once Auto Layout has
    /// assigned a concrete width.
    public override var intrinsicContentSize: CGSize {
        let measurementWidth: CGFloat
        if preferredMaxLayoutWidth > 0 {
            measurementWidth = preferredMaxLayoutWidth
        } else if bounds.width > 0 {
            measurementWidth = bounds.width
        } else {
            return .zero
        }
        return measureSize(forWidth: measurementWidth)
    }

    /// Two-pass Auto Layout measurement.
    ///
    /// Called by the system when it needs to know the view's size for a given
    /// `targetSize` (typically a known width, height = `.greatestFiniteMagnitude`).
    /// We temporarily set our bounds to the target width, run a full layout, and
    /// return the resulting content size.
    public override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        let measurementWidth = targetSize.width > 0 ? targetSize.width : bounds.width
        guard measurementWidth > 0 else { return .zero }

        let originalBounds = bounds
        let originalScrollFrame = scrollView.frame
        let originalContentSize = scrollView.contentSize
        let originalContainerFrame = containerView.frame

        bounds = CGRect(x: 0, y: 0, width: measurementWidth, height: 0)
        scrollView.frame = bounds
        setNeedsLayoutTagViews()
        layoutTagViews()
        let result = scrollView.contentSize

        bounds = originalBounds
        scrollView.frame = originalScrollFrame
        scrollView.contentSize = originalContentSize
        containerView.frame = originalContainerFrame
        setNeedsLayoutTagViews()
        return result
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
        var views: [UIView] = []
        views.reserveCapacity(count)
        for i in 0..<count {
            let view = dataSource.tagCollectionView(self, tagViewFor: i)
            containerView.addSubview(view)
            views.append(view)
        }
        _tagViews = views

        setNeedsLayoutTagViews()
        layoutTagViews()
    }

    /// Returns the index of the tag at the given point, or `NSNotFound` if no tag is hit.
    @objc(indexOfTagAt:)
    public func indexOfTag(at point: CGPoint) -> Int {
        let convertedPoint = convert(point, to: containerView)
        for (i, view) in _tagViews.enumerated() {
            if view.frame.contains(convertedPoint) && !view.isHidden {
                return i
            }
        }
        return NSNotFound
    }

    // MARK: Gesture

    @objc private func onTapGesture(_ gesture: UITapGestureRecognizer) {
        let pointInCollection = gesture.location(in: self)

        guard let delegate = delegate else {
            onTapBlankArea?(pointInCollection)
            onTapAllArea?(pointInCollection)
            return
        }

        let pointInContainer = gesture.location(in: containerView)
        var hasLocatedToTag = false

        for (i, tagView) in _tagViews.enumerated() {
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
            guard tagFrame.index < _tagViews.count else { continue }
            let view = _tagViews[tagFrame.index]
            view.isHidden = tagFrame.hidden
            if !tagFrame.hidden {
                view.frame = tagFrame.frame
            }
        }

        _actualNumberOfLines = output.actualNumberOfLines

        let contentSizeChanged = !scrollView.contentSize.equalTo(output.contentSize)
        if contentSizeChanged {
            scrollView.contentSize = output.contentSize
            containerView.frame = CGRect(origin: .zero, size: output.contentSize)
            delegate.tagCollectionView?(self, updateContentSize: output.contentSize)
        }

        needsLayoutTagViews = false
        if contentSizeChanged {
            DispatchQueue.main.async { [weak self] in
                self?.invalidateIntrinsicContentSize()
            }
        }
    }

    // MARK: - Validation

    private var isDelegateAndDataSourceValid: Bool {
        return delegate != nil && dataSource != nil
    }

    // MARK: - Measurement

    /// Compute content size at a given width without modifying the view's current bounds permanently.
    private func measureSize(forWidth width: CGFloat) -> CGSize {
        guard isDelegateAndDataSourceValid,
              let dataSource = dataSource, let delegate = delegate,
              width > 0 else {
            return scrollView.contentSize
        }

        let count = dataSource.numberOfTags(in: self)
        var tagSizes: [CGSize] = []
        tagSizes.reserveCapacity(count)
        for i in 0..<count {
            tagSizes.append(delegate.tagCollectionView(self, sizeForTagAt: i))
        }

        let containerWidth = (manualCalculateHeight && preferredMaxLayoutWidth > 0)
            ? preferredMaxLayoutWidth
            : width

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

        return TagCollectionLayout.calculate(input).contentSize
    }
}

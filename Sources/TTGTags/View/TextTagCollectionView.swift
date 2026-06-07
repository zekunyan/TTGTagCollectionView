//
//  TextTagCollectionView.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

// MARK: - Delegate Protocol

/// Delegate for the text tag collection view.
@objc(TTGTextTagCollectionViewDelegate)
public protocol TextTagCollectionViewDelegate: AnyObject {

    @objc(textTagCollectionView:canTapTag:atIndex:)
    optional func textTagCollectionView(_ collectionView: TextTagCollectionView, canTapTag tag: TextTag, at index: Int) -> Bool

    @objc(textTagCollectionView:didTapTag:atIndex:)
    optional func textTagCollectionView(_ collectionView: TextTagCollectionView, didTapTag tag: TextTag, at index: Int)

    @objc(textTagCollectionView:updateContentSize:)
    optional func textTagCollectionView(_ collectionView: TextTagCollectionView, updateContentSize contentSize: CGSize)
}

// MARK: - Main View

/// Text tag collection view. A wrapper around `TagCollectionView` for displaying `TextTag` models directly.
@objc(TTGTextTagCollectionView)
public final class TextTagCollectionView: UIView {

    // MARK: Public Properties

    @objc public weak var delegate: TextTagCollectionViewDelegate?

    /// Built-in scroll view.
    @objc public var scrollView: UIScrollView {
        return tagCollectionView.scrollView
    }

    /// Whether tag selection is enabled. Defaults to `true`.
    @objc public var enableTagSelection: Bool = true

    /// Scroll direction.
    @objc public var scrollDirection: TagCollectionScrollDirection {
        get { tagCollectionView.scrollDirection }
        set { tagCollectionView.scrollDirection = newValue }
    }

    /// Alignment mode.
    @objc public var alignment: TagCollectionAlignment {
        get { tagCollectionView.alignment }
        set { tagCollectionView.alignment = newValue }
    }

    /// Maximum number of lines.
    @objc public var numberOfLines: Int {
        get { tagCollectionView.numberOfLines }
        set { tagCollectionView.numberOfLines = newValue }
    }

    /// Actual number of lines rendered.
    @objc public var actualNumberOfLines: Int {
        return tagCollectionView.actualNumberOfLines
    }

    /// Maximum number of selected tags. 0 means unlimited.
    @objc public var selectionLimit: Int = 0

    @objc public var horizontalSpacing: CGFloat {
        get { tagCollectionView.horizontalSpacing }
        set { tagCollectionView.horizontalSpacing = newValue }
    }

    @objc public var verticalSpacing: CGFloat {
        get { tagCollectionView.verticalSpacing }
        set { tagCollectionView.verticalSpacing = newValue }
    }

    @objc public var contentInset: UIEdgeInsets {
        get { tagCollectionView.contentInset }
        set { tagCollectionView.contentInset = newValue }
    }

    @objc public var contentSize: CGSize {
        return tagCollectionView.contentSize
    }

    @objc public var manualCalculateHeight: Bool {
        get { tagCollectionView.manualCalculateHeight }
        set { tagCollectionView.manualCalculateHeight = newValue }
    }

    @objc public var preferredMaxLayoutWidth: CGFloat {
        get { tagCollectionView.preferredMaxLayoutWidth }
        set {
            tagCollectionView.preferredMaxLayoutWidth = newValue
            invalidateIntrinsicContentSize()
        }
    }

    @objc public var showsHorizontalScrollIndicator: Bool {
        get { tagCollectionView.showsHorizontalScrollIndicator }
        set { tagCollectionView.showsHorizontalScrollIndicator = newValue }
    }

    @objc public var showsVerticalScrollIndicator: Bool {
        get { tagCollectionView.showsVerticalScrollIndicator }
        set { tagCollectionView.showsVerticalScrollIndicator = newValue }
    }

    @objc public var onTapBlankArea: ((CGPoint) -> Void)? {
        get { tagCollectionView.onTapBlankArea }
        set { tagCollectionView.onTapBlankArea = newValue }
    }

    @objc public var onTapAllArea: ((CGPoint) -> Void)? {
        get { tagCollectionView.onTapAllArea }
        set { tagCollectionView.onTapAllArea = newValue }
    }

    // MARK: Private Properties

    private var tagLabels: [TextTagComponentView] = []
    private var tagCollectionView: TagCollectionView!
    private var lastLaidOutBoundsSize: CGSize = .zero

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
        tagCollectionView = TagCollectionView(frame: bounds)
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.horizontalSpacing = 8
        tagCollectionView.verticalSpacing = 8
        addSubview(tagCollectionView)
    }

    // MARK: Override

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

        let originalBounds = tagCollectionView.bounds
        let originalFrame = tagCollectionView.frame
        let originalScrollFrame = tagCollectionView.scrollView.frame
        let originalContentSize = tagCollectionView.scrollView.contentSize

        updateAllLabelStyleAndFrame()
        tagCollectionView.bounds = CGRect(x: 0, y: 0, width: measurementWidth, height: 0)
        tagCollectionView.setNeedsLayout()
        tagCollectionView.layoutIfNeeded()
        let result = tagCollectionView.scrollView.contentSize

        tagCollectionView.bounds = originalBounds
        tagCollectionView.frame = originalFrame
        tagCollectionView.scrollView.frame = originalScrollFrame
        tagCollectionView.scrollView.contentSize = originalContentSize
        tagCollectionView.setNeedsLayout()
        return result
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
        let originalTagCollectionFrame = tagCollectionView.frame
        let originalScrollFrame = tagCollectionView.scrollView.frame
        let originalContentSize = tagCollectionView.scrollView.contentSize

        bounds = CGRect(x: 0, y: 0, width: measurementWidth, height: 0)
        updateAllLabelStyleAndFrame()
        tagCollectionView.frame = bounds
        tagCollectionView.setNeedsLayout()
        tagCollectionView.layoutIfNeeded()
        let result = tagCollectionView.contentSize

        bounds = originalBounds
        tagCollectionView.frame = originalTagCollectionFrame
        tagCollectionView.scrollView.frame = originalScrollFrame
        tagCollectionView.scrollView.contentSize = originalContentSize
        tagCollectionView.setNeedsLayout()
        return result
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if !tagCollectionView.frame.equalTo(bounds) {
            updateAllLabelStyleAndFrame()
            tagCollectionView.frame = bounds
            tagCollectionView.setNeedsLayout()
            if !lastLaidOutBoundsSize.equalTo(bounds.size) {
                lastLaidOutBoundsSize = bounds.size
                DispatchQueue.main.async { [weak self] in
                    self?.invalidateIntrinsicContentSize()
                }
            }
        }
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return contentSize
    }

    // MARK: - Public API

    @objc public func reload() {
        updateAllLabelStyleAndFrame()
        tagCollectionView.reload()
        setNeedsLayout()
        superview?.setNeedsLayout()
        invalidateIntrinsicContentSize()
    }

    @objc(addTag:)
    public func add(tag: TextTag) {
        insert(tag: tag, at: tagLabels.count)
    }

    @objc(addTags:)
    public func add(tags: [TextTag]) {
        insert(tags: tags, at: tagLabels.count)
    }

    @objc(insertTag:atIndex:)
    public func insert(tag: TextTag, at index: Int) {
        insert(tags: [tag], at: index)
    }

    @objc(insertTags:atIndex:)
    public func insert(tags: [TextTag], at index: Int) {
        guard index >= 0, index <= tagLabels.count, !tags.isEmpty else { return }
        let newLabels = tags.map { newLabel(with: $0) }
        tagLabels.insert(contentsOf: newLabels, at: index)
    }

    @objc(removeTag:)
    public func remove(tag: TextTag) {
        removeTag(byId: tag.tagId)
    }

    @objc(removeTagById:)
    public func removeTag(byId tagId: Int) {
        if let index = tagLabels.firstIndex(where: { $0.config?.tagId == tagId }) {
            tagLabels.remove(at: index)
        }
    }

    @objc(removeTagAtIndex:)
    public func removeTag(at index: Int) {
        guard index >= 0, index < tagLabels.count else { return }
        tagLabels.remove(at: index)
    }

    @objc public func removeAllTags() {
        tagLabels.removeAll()
    }

    @objc(updateTagAtIndex:selected:)
    public func updateTag(at index: Int, selected: Bool) {
        guard let tag = getTag(at: index) else { return }
        guard tag.selected != selected else { return }
        tag.selected = selected
        reload()
    }

    @objc(updateTagAtIndex:withNewTag:)
    public func updateTag(at index: Int, with newTag: TextTag) {
        guard index >= 0, index < tagLabels.count else { return }
        let label = tagLabels[index]
        label.config = newTag
        reload()
    }

    @objc(getTagAtIndex:)
    public func getTag(at index: Int) -> TextTag? {
        guard index >= 0, index < tagLabels.count else { return nil }
        return tagLabels[index].config
    }

    @objc(getTagsInRange:)
    public func getTags(in range: NSRange) -> [TextTag]? {
        let end = range.location + range.length
        guard range.location >= 0, end <= tagLabels.count else { return nil }
        return tagLabels[range.location..<end].compactMap { $0.config }
    }

    /// All tags.
    @objc public func allTags() -> [TextTag] {
        return tagLabels.compactMap { $0.config }
    }

    /// All selected tags.
    @objc public func allSelectedTags() -> [TextTag] {
        return tagLabels.compactMap { $0.config }.filter { $0.selected }
    }

    /// All unselected tags.
    @objc public func allNotSelectedTags() -> [TextTag] {
        return tagLabels.compactMap { $0.config }.filter { !$0.selected }
    }

    @objc(indexOfTagAtPoint:)
    public func indexOfTag(at point: CGPoint) -> Int {
        let converted = convert(point, to: tagCollectionView)
        return tagCollectionView.indexOfTag(at: converted)
    }

    // MARK: - Private

    private func updateAllLabelStyleAndFrame() {
        tagLabels.forEach(updateStyleAndFrame(for:))
    }

    private func updateStyleAndFrame(for label: TextTagComponentView) {
        label.updateContent()
        label.updateContentStyle()
        label.updateAccessibility()

        var maxSize = CGSize.zero
        if scrollDirection == .vertical, bounds.width > 0 {
            maxSize.width = bounds.width - contentInset.left - contentInset.right
        }
        label.updateFrame(maxSize: maxSize)
    }

    private func newLabel(with config: TextTag) -> TextTagComponentView {
        let label = TextTagComponentView()
        label.config = config
        return label
    }
}

// MARK: - TagCollectionViewDataSource

extension TextTagCollectionView: TagCollectionViewDataSource {

    public func numberOfTags(in tagCollectionView: TagCollectionView) -> Int {
        return tagLabels.count
    }

    public func tagCollectionView(_ tagCollectionView: TagCollectionView, tagViewFor index: Int) -> UIView {
        return tagLabels[index]
    }
}

// MARK: - TagCollectionViewDelegate

extension TextTagCollectionView: TagCollectionViewDelegate {

    public func tagCollectionView(_ tagCollectionView: TagCollectionView, sizeForTagAt index: Int) -> CGSize {
        return tagLabels[index].frame.size
    }

    public func tagCollectionView(_ tagCollectionView: TagCollectionView, shouldSelectTag tagView: UIView, at index: Int) -> Bool {
        guard enableTagSelection else { return false }
        let label = tagLabels[index]
        guard let config = label.config else { return false }
        return delegate?.textTagCollectionView?(self, canTapTag: config, at: index) ?? true
    }

    public func tagCollectionView(_ tagCollectionView: TagCollectionView, didSelectTag tagView: UIView, at index: Int) {
        guard enableTagSelection else { return }
        let label = tagLabels[index]
        guard let config = label.config else { return }

        if !config.selected, selectionLimit > 0, allSelectedTags().count + 1 > selectionLimit {
            return
        }

        config.selected.toggle()
        reload()

        delegate?.textTagCollectionView?(self, didTapTag: config, at: index)
    }

    public func tagCollectionView(_ tagCollectionView: TagCollectionView, updateContentSize contentSize: CGSize) {
        delegate?.textTagCollectionView?(self, updateContentSize: contentSize)
    }
}

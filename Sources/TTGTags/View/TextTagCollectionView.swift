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

    @objc(textTagCollectionView:canMoveTag:fromIndex:toIndex:)
    optional func textTagCollectionView(
        _ collectionView: TextTagCollectionView,
        canMoveTag tag: TextTag,
        fromIndex: Int,
        toIndex: Int
    ) -> Bool

    @objc(textTagCollectionView:didMoveTag:fromIndex:toIndex:)
    optional func textTagCollectionView(
        _ collectionView: TextTagCollectionView,
        didMoveTag tag: TextTag,
        fromIndex: Int,
        toIndex: Int
    )

    @objc(textTagCollectionView:canDeleteTag:atIndex:)
    optional func textTagCollectionView(
        _ collectionView: TextTagCollectionView,
        canDeleteTag tag: TextTag,
        at index: Int
    ) -> Bool

    @objc(textTagCollectionView:didDeleteTag:atIndex:)
    optional func textTagCollectionView(
        _ collectionView: TextTagCollectionView,
        didDeleteTag tag: TextTag,
        at index: Int
    )
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

    /// Whether long-press drag reordering is enabled. Defaults to `false`.
    @objc public var enableTagReordering: Bool = false {
        didSet { updateDragGestureEnabled() }
    }

    /// Whether dragging a tag to the delete zone removes it. Defaults to `false`.
    @objc public var enableDragToDelete: Bool = false {
        didSet {
            updateDragGestureEnabled()
            if !enableDragToDelete {
                hideDragDeleteZone()
            }
        }
    }

    /// Height of the drag-to-delete zone. Defaults to `56`.
    @objc public var dragDeleteZoneHeight: CGFloat = 56 {
        didSet { updateDragDeleteZoneLayout() }
    }

    /// Insets from this view's bounds to the drag-to-delete zone. Defaults to `(0, 12, 8, 12)`.
    @objc public var dragDeleteZoneInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 8, right: 12) {
        didSet { updateDragDeleteZoneLayout() }
    }

    /// Corner radius of the drag-to-delete zone. Defaults to `12`.
    @objc public var dragDeleteZoneCornerRadius: CGFloat = 12 {
        didSet { applyDragDeleteZoneAppearance(isHighlighted: isDragDeleteZoneHighlighted) }
    }

    /// Background color of the drag-to-delete zone.
    @objc public var dragDeleteZoneBackgroundColor: UIColor = UIColor.systemRed.withAlphaComponent(0.84) {
        didSet { applyDragDeleteZoneAppearance(isHighlighted: isDragDeleteZoneHighlighted) }
    }

    /// Highlighted background color while the dragged tag is inside the delete zone.
    @objc public var dragDeleteZoneHighlightedBackgroundColor: UIColor = UIColor.systemRed.withAlphaComponent(0.96) {
        didSet { applyDragDeleteZoneAppearance(isHighlighted: isDragDeleteZoneHighlighted) }
    }

    /// Text shown in the drag-to-delete zone. Set to `nil` or an empty string to hide it.
    @objc public var dragDeleteZoneText: String? = "Release to delete" {
        didSet { applyDragDeleteZoneAppearance(isHighlighted: isDragDeleteZoneHighlighted) }
    }

    /// Text color shown in the drag-to-delete zone.
    @objc public var dragDeleteZoneTextColor: UIColor = .white {
        didSet { applyDragDeleteZoneAppearance(isHighlighted: isDragDeleteZoneHighlighted) }
    }

    /// Font used by the drag-to-delete zone text.
    @objc public var dragDeleteZoneFont: UIFont = .systemFont(ofSize: 15, weight: .semibold) {
        didSet { applyDragDeleteZoneAppearance(isHighlighted: isDragDeleteZoneHighlighted) }
    }

    /// Icon shown in the drag-to-delete zone. Set to `nil` to hide it.
    @objc public var dragDeleteZoneImage: UIImage? = UIImage(systemName: "trash") {
        didSet { applyDragDeleteZoneAppearance(isHighlighted: isDragDeleteZoneHighlighted) }
    }

    /// Icon tint color shown in the drag-to-delete zone.
    @objc public var dragDeleteZoneImageTintColor: UIColor = .white {
        didSet { applyDragDeleteZoneAppearance(isHighlighted: isDragDeleteZoneHighlighted) }
    }

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

    /// Horizontal multi-line distribution.
    @objc public var horizontalDistribution: TagCollectionHorizontalDistribution {
        get { tagCollectionView.horizontalDistribution }
        set { tagCollectionView.horizontalDistribution = newValue }
    }

    /// Vertical placement when the view is taller than its content.
    @objc public var contentVerticalAlignment: TagCollectionContentVerticalAlignment {
        get { tagCollectionView.contentVerticalAlignment }
        set { tagCollectionView.contentVerticalAlignment = newValue }
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
    private var reorderLongPressGesture: UILongPressGestureRecognizer!
    private var dragDeleteZoneView: UIView!
    private var dragDeleteImageView: UIImageView!
    private var dragDeleteLabel: UILabel!
    private var dragDeleteZoneTopConstraint: NSLayoutConstraint!
    private var dragDeleteZoneLeadingConstraint: NSLayoutConstraint!
    private var dragDeleteZoneTrailingConstraint: NSLayoutConstraint!
    private var dragDeleteZoneBottomConstraint: NSLayoutConstraint!
    private var dragDeleteZoneHeightConstraint: NSLayoutConstraint!
    private var dragAutoScrollDisplayLink: CADisplayLink?
    private var dragLastLocation: CGPoint = .zero
    private var dragSnapshotView: UIView?
    private var draggedLabel: TextTagComponentView?
    private var dragOriginalLabels: [TextTagComponentView] = []
    private var dragOriginalIndex: Int = NSNotFound
    private var dragCurrentIndex: Int = NSNotFound
    private var dragTouchOffsetFromSnapshotCenter: CGPoint = .zero
    private var wasScrollEnabledBeforeDrag = true
    private var isDragDeleteZoneHighlighted = false

    private let dragAutoScrollEdgeThreshold: CGFloat = 44
    private let dragAutoScrollMaximumStep: CGFloat = 10

    private final class CachedMeasurement {
        let size: CGSize

        init(size: CGSize) {
            self.size = size
        }
    }

    private static let measurementCache: NSCache<NSString, CachedMeasurement> = {
        let cache = NSCache<NSString, CachedMeasurement>()
        cache.countLimit = 2_048
        return cache
    }()

    // MARK: Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    deinit {
        stopDragAutoScroll()
    }

    private func commonInit() {
        tagCollectionView = TagCollectionView(frame: bounds)
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.horizontalSpacing = 8
        tagCollectionView.verticalSpacing = 8
        addSubview(tagCollectionView)

        setupDragDeleteZone()
        setupReorderGesture()
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

        bringDragOverlayToFront()
    }

    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer === reorderLongPressGesture else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        guard enableTagReordering || enableDragToDelete else { return false }
        return indexOfTag(at: gestureRecognizer.location(in: self)) != NSNotFound
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return contentSize
    }

    // MARK: - Public API

    @objc(contentSizeForTags:width:scrollDirection:alignment:numberOfLines:horizontalSpacing:verticalSpacing:contentInset:)
    public static func contentSize(
        for tags: [TextTag],
        width: CGFloat,
        scrollDirection: TagCollectionScrollDirection,
        alignment: TagCollectionAlignment,
        numberOfLines: Int,
        horizontalSpacing: CGFloat,
        verticalSpacing: CGFloat,
        contentInset: UIEdgeInsets
    ) -> CGSize {
        return contentSize(
            for: tags,
            width: width,
            scrollDirection: scrollDirection,
            alignment: alignment,
            horizontalDistribution: .rowMajor,
            numberOfLines: numberOfLines,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            contentInset: contentInset
        )
    }

    @objc(contentSizeForTags:width:scrollDirection:alignment:horizontalDistribution:numberOfLines:horizontalSpacing:verticalSpacing:contentInset:)
    public static func contentSize(
        for tags: [TextTag],
        width: CGFloat,
        scrollDirection: TagCollectionScrollDirection,
        alignment: TagCollectionAlignment,
        horizontalDistribution: TagCollectionHorizontalDistribution,
        numberOfLines: Int,
        horizontalSpacing: CGFloat,
        verticalSpacing: CGFloat,
        contentInset: UIEdgeInsets
    ) -> CGSize {
        let maxTagWidth = scrollDirection == .vertical ? max(0, width - contentInset.left - contentInset.right) : 0
        let tagSizes = tags.map { tag in
            measuredSize(for: tag, maxSize: CGSize(width: maxTagWidth, height: 0))
        }
        let input = TagCollectionLayout.Input(
            tagSizes: tagSizes,
            scrollDirection: scrollDirection,
            alignment: alignment,
            horizontalDistribution: horizontalDistribution,
            contentVerticalAlignment: .top,
            numberOfLines: numberOfLines,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            contentInset: contentInset,
            containerWidth: width,
            containerHeight: 0
        )
        return TagCollectionLayout.calculate(input).contentSize
    }

    @objc(clearMeasurementCache)
    public static func clearMeasurementCache() {
        measurementCache.removeAllObjects()
        TagCollectionLayout.clearCache()
    }

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

    @objc(moveTagAtIndex:toIndex:)
    @discardableResult
    public func moveTag(at fromIndex: Int, to toIndex: Int) -> Bool {
        return moveTag(from: fromIndex, to: toIndex, notifyDelegate: true, reloadAfterMove: true)
    }

    @objc(moveTagById:toIndex:)
    @discardableResult
    public func moveTag(byId tagId: Int, to toIndex: Int) -> Bool {
        let fromIndex = indexOfTag(byId: tagId)
        guard fromIndex != NSNotFound else { return false }
        return moveTag(at: fromIndex, to: toIndex)
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

    @objc(updateTagById:selected:)
    public func updateTag(byId tagId: Int, selected: Bool) {
        let index = indexOfTag(byId: tagId)
        guard index != NSNotFound else { return }
        updateTag(at: index, selected: selected)
    }

    @objc(updateTagById:withNewTag:)
    public func updateTag(byId tagId: Int, with newTag: TextTag) {
        let index = indexOfTag(byId: tagId)
        guard index != NSNotFound else { return }
        updateTag(at: index, with: newTag)
    }

    @objc(getTagAtIndex:)
    public func getTag(at index: Int) -> TextTag? {
        guard index >= 0, index < tagLabels.count else { return nil }
        return tagLabels[index].config
    }

    @objc(getTagById:)
    public func getTag(byId tagId: Int) -> TextTag? {
        let index = indexOfTag(byId: tagId)
        guard index != NSNotFound else { return nil }
        return getTag(at: index)
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

    @objc(indexOfTagById:)
    public func indexOfTag(byId tagId: Int) -> Int {
        guard let index = tagLabels.firstIndex(where: { $0.config?.tagId == tagId }) else {
            return NSNotFound
        }
        return index
    }

    @objc(frameForTagAtIndex:)
    public func frameForTag(at index: Int) -> CGRect {
        return tagCollectionView.frameForTag(at: index)
    }

    @objc(scrollToTagAtIndex:position:animated:)
    public func scrollToTag(at index: Int, position: TagCollectionScrollPosition, animated: Bool) {
        tagCollectionView.scrollToTag(at: index, position: position, animated: animated)
    }

    @objc(scrollToTagById:position:animated:)
    public func scrollToTag(byId tagId: Int, position: TagCollectionScrollPosition, animated: Bool) {
        let index = indexOfTag(byId: tagId)
        guard index != NSNotFound else { return }
        scrollToTag(at: index, position: position, animated: animated)
    }

    func targetIndexForDragLocation(_ location: CGPoint) -> Int {
        let hitIndex = indexOfTag(at: location)
        if hitIndex != NSNotFound {
            return hitIndex
        }

        var nearestIndex = NSNotFound
        var nearestDistance = CGFloat.greatestFiniteMagnitude
        for index in tagLabels.indices {
            let frame = visibleFrameForTag(at: index)
            guard !frame.isNull, !frame.isEmpty else { continue }
            let center = CGPoint(x: frame.midX, y: frame.midY)
            let dx = center.x - location.x
            let dy = center.y - location.y
            let distance = dx * dx + dy * dy
            if distance < nearestDistance {
                nearestDistance = distance
                nearestIndex = index
            }
        }
        return nearestIndex
    }

    // MARK: - Private

    private func setupReorderGesture() {
        reorderLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleReorderLongPress(_:)))
        reorderLongPressGesture.minimumPressDuration = 0.35
        reorderLongPressGesture.cancelsTouchesInView = true
        reorderLongPressGesture.isEnabled = false
        addGestureRecognizer(reorderLongPressGesture)
    }

    private func setupDragDeleteZone() {
        dragDeleteZoneView = UIView()
        dragDeleteZoneView.translatesAutoresizingMaskIntoConstraints = false
        dragDeleteZoneView.layer.masksToBounds = true
        dragDeleteZoneView.alpha = 0
        dragDeleteZoneView.isHidden = true

        dragDeleteImageView = UIImageView()
        dragDeleteImageView.translatesAutoresizingMaskIntoConstraints = false
        dragDeleteImageView.contentMode = .scaleAspectFit

        dragDeleteLabel = UILabel()
        dragDeleteLabel.translatesAutoresizingMaskIntoConstraints = false
        dragDeleteLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [dragDeleteImageView, dragDeleteLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        dragDeleteZoneView.addSubview(stack)
        addSubview(dragDeleteZoneView)

        dragDeleteZoneTopConstraint = dragDeleteZoneView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: dragDeleteZoneInsets.top)
        dragDeleteZoneTopConstraint.priority = .defaultHigh
        dragDeleteZoneLeadingConstraint = dragDeleteZoneView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: dragDeleteZoneInsets.left)
        dragDeleteZoneTrailingConstraint = dragDeleteZoneView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -dragDeleteZoneInsets.right)
        dragDeleteZoneBottomConstraint = dragDeleteZoneView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -dragDeleteZoneInsets.bottom)
        dragDeleteZoneHeightConstraint = dragDeleteZoneView.heightAnchor.constraint(equalToConstant: dragDeleteZoneHeight)

        NSLayoutConstraint.activate([
            dragDeleteZoneTopConstraint,
            dragDeleteZoneLeadingConstraint,
            dragDeleteZoneTrailingConstraint,
            dragDeleteZoneBottomConstraint,
            dragDeleteZoneHeightConstraint,

            dragDeleteImageView.widthAnchor.constraint(equalToConstant: 20),
            dragDeleteImageView.heightAnchor.constraint(equalToConstant: 20),

            stack.centerXAnchor.constraint(equalTo: dragDeleteZoneView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: dragDeleteZoneView.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: dragDeleteZoneView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: dragDeleteZoneView.trailingAnchor, constant: -16),
        ])

        applyDragDeleteZoneAppearance(isHighlighted: false)
    }

    private func updateDragGestureEnabled() {
        reorderLongPressGesture?.isEnabled = enableTagReordering || enableDragToDelete
    }

    private func updateDragDeleteZoneLayout() {
        guard dragDeleteZoneView != nil else { return }
        dragDeleteZoneTopConstraint.constant = dragDeleteZoneInsets.top
        dragDeleteZoneLeadingConstraint.constant = dragDeleteZoneInsets.left
        dragDeleteZoneTrailingConstraint.constant = -dragDeleteZoneInsets.right
        dragDeleteZoneBottomConstraint.constant = -dragDeleteZoneInsets.bottom
        dragDeleteZoneHeightConstraint.constant = max(0, dragDeleteZoneHeight)
        setNeedsLayout()
    }

    private func applyDragDeleteZoneAppearance(isHighlighted: Bool) {
        guard dragDeleteZoneView != nil else { return }
        isDragDeleteZoneHighlighted = isHighlighted
        dragDeleteZoneView.backgroundColor = isHighlighted
            ? dragDeleteZoneHighlightedBackgroundColor
            : dragDeleteZoneBackgroundColor
        dragDeleteZoneView.layer.cornerRadius = dragDeleteZoneCornerRadius

        dragDeleteLabel.text = dragDeleteZoneText
        dragDeleteLabel.textColor = dragDeleteZoneTextColor
        dragDeleteLabel.font = dragDeleteZoneFont
        dragDeleteLabel.isHidden = (dragDeleteZoneText ?? "").isEmpty

        dragDeleteImageView.image = dragDeleteZoneImage
        dragDeleteImageView.tintColor = dragDeleteZoneImageTintColor
        dragDeleteImageView.isHidden = dragDeleteZoneImage == nil
    }

    private func bringDragOverlayToFront() {
        if let dragDeleteZoneView {
            bringSubviewToFront(dragDeleteZoneView)
        }
        if let dragSnapshotView {
            bringSubviewToFront(dragSnapshotView)
        }
    }

    @objc private func handleReorderLongPress(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: self)
        switch gesture.state {
        case .began:
            beginDragging(at: location)
        case .changed:
            updateDragging(at: location)
        case .ended:
            endDragging(at: location)
        case .cancelled, .failed:
            cancelDragging()
        default:
            break
        }
    }

    private func beginDragging(at location: CGPoint) {
        guard enableTagReordering || enableDragToDelete else { return }
        let index = indexOfTag(at: location)
        guard index != NSNotFound, index < tagLabels.count else { return }

        let label = tagLabels[index]
        guard label.config != nil else { return }

        layoutIfNeeded()
        tagCollectionView.layoutIfNeeded()

        dragOriginalLabels = tagLabels
        dragOriginalIndex = index
        dragCurrentIndex = index
        draggedLabel = label
        dragLastLocation = location
        wasScrollEnabledBeforeDrag = scrollView.isScrollEnabled
        scrollView.isScrollEnabled = false

        let visibleFrame = visibleFrameForTag(at: index)
        let snapshot = label.snapshotView(afterScreenUpdates: false) ?? makeFallbackSnapshot(for: label)
        snapshot.frame = visibleFrame
        snapshot.layer.shadowColor = UIColor.black.cgColor
        snapshot.layer.shadowOpacity = 0.18
        snapshot.layer.shadowRadius = 10
        snapshot.layer.shadowOffset = CGSize(width: 0, height: 6)
        snapshot.transform = CGAffineTransform(scaleX: 1.04, y: 1.04)
        snapshot.isUserInteractionEnabled = false
        addSubview(snapshot)
        dragSnapshotView = snapshot
        dragTouchOffsetFromSnapshotCenter = CGPoint(
            x: location.x - snapshot.center.x,
            y: location.y - snapshot.center.y
        )

        label.alpha = 0
        showDragDeleteZoneIfNeeded()
        bringDragOverlayToFront()
        startDragAutoScroll()
    }

    private func updateDragging(at location: CGPoint) {
        guard dragSnapshotView != nil, draggedLabel != nil else { return }
        dragLastLocation = location
        updateDragSnapshotCenter(for: location)
        updateDragDeleteZoneHighlight(location: location)

        guard enableTagReordering, !isLocationInDragDeleteZone(location) else { return }
        updateDragTarget(at: location)
    }

    private func endDragging(at location: CGPoint) {
        guard let draggedLabel = draggedLabel, let tag = draggedLabel.config else {
            cleanupDragging()
            return
        }

        dragLastLocation = location
        updateDragSnapshotCenter(for: location)

        let currentIndex = currentDraggedLabelIndex()
        let shouldDelete = enableDragToDelete
            && isLocationInDragDeleteZone(location)
            && currentIndex != NSNotFound
            && (delegate?.textTagCollectionView?(self, canDeleteTag: tag, at: currentIndex) ?? true)

        if shouldDelete {
            tagLabels.remove(at: currentIndex)
            cleanupDragging()
            reload()
            delegate?.textTagCollectionView?(self, didDeleteTag: tag, at: currentIndex)
            return
        }

        let finalIndex = currentIndex
        let originalIndex = dragOriginalIndex
        cleanupDragging()
        reload()
        if originalIndex != NSNotFound, finalIndex != NSNotFound, originalIndex != finalIndex {
            delegate?.textTagCollectionView?(self, didMoveTag: tag, fromIndex: originalIndex, toIndex: finalIndex)
        }
    }

    private func cancelDragging() {
        if !dragOriginalLabels.isEmpty {
            tagLabels = dragOriginalLabels
        }
        cleanupDragging()
        reload()
    }

    private func cleanupDragging() {
        stopDragAutoScroll()
        scrollView.isScrollEnabled = wasScrollEnabledBeforeDrag
        draggedLabel?.alpha = 1
        dragSnapshotView?.removeFromSuperview()
        dragSnapshotView = nil
        draggedLabel = nil
        dragOriginalLabels = []
        dragOriginalIndex = NSNotFound
        dragCurrentIndex = NSNotFound
        dragTouchOffsetFromSnapshotCenter = .zero
        hideDragDeleteZone()
    }

    private func updateDragSnapshotCenter(for location: CGPoint) {
        dragSnapshotView?.center = CGPoint(
            x: location.x - dragTouchOffsetFromSnapshotCenter.x,
            y: location.y - dragTouchOffsetFromSnapshotCenter.y
        )
    }

    private func updateDragTarget(at location: CGPoint) {
        let targetIndex = targetIndexForDragLocation(location)
        guard targetIndex != NSNotFound,
              dragCurrentIndex != NSNotFound,
              targetIndex != dragCurrentIndex else {
            return
        }
        if moveTag(from: dragCurrentIndex, to: targetIndex, notifyDelegate: false, reloadAfterMove: true) {
            dragCurrentIndex = targetIndex
            draggedLabel?.alpha = 0
            bringDragOverlayToFront()
        }
    }

    private func moveTag(
        from fromIndex: Int,
        to toIndex: Int,
        notifyDelegate: Bool,
        reloadAfterMove: Bool
    ) -> Bool {
        guard fromIndex >= 0,
              fromIndex < tagLabels.count,
              toIndex >= 0,
              toIndex < tagLabels.count,
              fromIndex != toIndex,
              let tag = tagLabels[fromIndex].config else {
            return false
        }

        let allowed = delegate?.textTagCollectionView?(
            self,
            canMoveTag: tag,
            fromIndex: fromIndex,
            toIndex: toIndex
        ) ?? true
        guard allowed else { return false }

        let label = tagLabels.remove(at: fromIndex)
        tagLabels.insert(label, at: toIndex)

        if reloadAfterMove {
            reload()
        }
        if notifyDelegate {
            delegate?.textTagCollectionView?(self, didMoveTag: tag, fromIndex: fromIndex, toIndex: toIndex)
        }
        return true
    }

    private func currentDraggedLabelIndex() -> Int {
        guard let draggedLabel = draggedLabel,
              let index = tagLabels.firstIndex(where: { $0 === draggedLabel }) else {
            return NSNotFound
        }
        return index
    }

    private func visibleFrameForTag(at index: Int) -> CGRect {
        let frame = tagCollectionView.frameForTag(at: index)
        guard !frame.isNull else { return .null }
        let scrollOffset = scrollView.contentOffset
        return CGRect(
            x: tagCollectionView.frame.minX + frame.minX - scrollOffset.x,
            y: tagCollectionView.frame.minY + frame.minY - scrollOffset.y,
            width: frame.width,
            height: frame.height
        )
    }

    private func makeFallbackSnapshot(for label: TextTagComponentView) -> UIView {
        let snapshot = TextTagComponentView(frame: label.bounds)
        snapshot.config = label.config
        snapshot.updateContent()
        snapshot.updateContentStyle()
        snapshot.updateAccessibility()
        return snapshot
    }

    private func showDragDeleteZoneIfNeeded() {
        guard enableDragToDelete else { return }
        dragDeleteZoneView.isHidden = false
        dragDeleteZoneView.alpha = 0
        updateDragDeleteZoneHighlight(location: dragLastLocation)
        UIView.animate(withDuration: 0.16) {
            self.dragDeleteZoneView.alpha = 1
        }
    }

    private func hideDragDeleteZone() {
        guard dragDeleteZoneView != nil else { return }
        dragDeleteZoneView.alpha = 0
        dragDeleteZoneView.isHidden = true
        dragDeleteZoneView.transform = .identity
        applyDragDeleteZoneAppearance(isHighlighted: false)
    }

    private func isLocationInDragDeleteZone(_ location: CGPoint) -> Bool {
        guard enableDragToDelete,
              dragDeleteZoneView != nil,
              !dragDeleteZoneView.isHidden else {
            return false
        }
        let locationInDeleteZone = convert(location, to: dragDeleteZoneView)
        return dragDeleteZoneView.bounds.contains(locationInDeleteZone)
    }

    private func updateDragDeleteZoneHighlight(location: CGPoint) {
        guard enableDragToDelete, dragDeleteZoneView != nil else { return }
        let isHighlighted = isLocationInDragDeleteZone(location)
        applyDragDeleteZoneAppearance(isHighlighted: isHighlighted)
        dragDeleteZoneView.transform = isHighlighted
            ? CGAffineTransform(scaleX: 1.02, y: 1.02)
            : .identity
    }

    private func startDragAutoScroll() {
        stopDragAutoScroll()
        let displayLink = CADisplayLink(target: self, selector: #selector(handleDragAutoScroll))
        displayLink.add(to: .main, forMode: .common)
        dragAutoScrollDisplayLink = displayLink
    }

    private func stopDragAutoScroll() {
        dragAutoScrollDisplayLink?.invalidate()
        dragAutoScrollDisplayLink = nil
    }

    @objc private func handleDragAutoScroll() {
        guard dragSnapshotView != nil else { return }

        let step: CGFloat
        switch scrollDirection {
        case .vertical:
            step = autoScrollStep(
                location: dragLastLocation.y,
                viewportStart: bounds.minY,
                viewportEnd: enableDragToDelete ? dragDeleteZoneView.frame.minY : bounds.maxY
            )
            guard step != 0 else { return }
            let maxOffset = max(0, scrollView.contentSize.height - scrollView.bounds.height)
            let nextY = min(max(0, scrollView.contentOffset.y + step), maxOffset)
            guard nextY != scrollView.contentOffset.y else { return }
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: nextY)
        case .horizontal:
            step = autoScrollStep(
                location: dragLastLocation.x,
                viewportStart: bounds.minX,
                viewportEnd: bounds.maxX
            )
            guard step != 0 else { return }
            let maxOffset = max(0, scrollView.contentSize.width - scrollView.bounds.width)
            let nextX = min(max(0, scrollView.contentOffset.x + step), maxOffset)
            guard nextX != scrollView.contentOffset.x else { return }
            scrollView.contentOffset = CGPoint(x: nextX, y: scrollView.contentOffset.y)
        }

        if enableTagReordering && !isLocationInDragDeleteZone(dragLastLocation) {
            updateDragTarget(at: dragLastLocation)
        }
    }

    private func autoScrollStep(location: CGFloat, viewportStart: CGFloat, viewportEnd: CGFloat) -> CGFloat {
        guard viewportEnd > viewportStart else { return 0 }
        if location < viewportStart + dragAutoScrollEdgeThreshold {
            let progress = min(1, max(0, (viewportStart + dragAutoScrollEdgeThreshold - location) / dragAutoScrollEdgeThreshold))
            return -dragAutoScrollMaximumStep * progress
        }
        if location > viewportEnd - dragAutoScrollEdgeThreshold {
            let progress = min(1, max(0, (location - (viewportEnd - dragAutoScrollEdgeThreshold)) / dragAutoScrollEdgeThreshold))
            return dragAutoScrollMaximumStep * progress
        }
        return 0
    }

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
        if let tag = label.config {
            label.updateFrame(size: Self.measuredSize(for: tag, maxSize: maxSize))
        } else {
            label.updateFrame(maxSize: maxSize)
        }
    }

    private func newLabel(with config: TextTag) -> TextTagComponentView {
        let label = TextTagComponentView()
        label.config = config
        return label
    }

    private static func measuredSize(for tag: TextTag, maxSize: CGSize) -> CGSize {
        let attributedString = tag.getRightfulContent().getContentAttributedString()
        let style = tag.getRightfulStyle()
        let key = measurementCacheKey(
            attributedString: attributedString,
            style: style,
            selected: tag.selected,
            maxSize: maxSize
        )
        if let cached = measurementCache.object(forKey: key) {
            return cached.size
        }

        let constrainedTextWidth = textConstraintWidth(for: style, maxSize: maxSize)
        let constrainedHeight = maxSize.height > 0
            ? max(0, maxSize.height - style.extraSpace.height)
            : CGFloat.greatestFiniteMagnitude
        let textBounds = measuredTextBounds(
            for: attributedString,
            constrainedWidth: constrainedTextWidth,
            constrainedHeight: constrainedHeight,
            numberOfLines: style.numberOfLines
        )

        var finalSize = CGSize(
            width: ceil(textBounds.width) + style.extraSpace.width,
            height: ceil(textBounds.height) + style.extraSpace.height
        )

        if style.maxWidth > 0, finalSize.width > style.maxWidth {
            finalSize.width = style.maxWidth
        }
        if style.minWidth > 0, finalSize.width < style.minWidth {
            finalSize.width = style.minWidth
        }
        if style.maxHeight > 0, finalSize.height > style.maxHeight {
            finalSize.height = style.maxHeight
        }
        if style.minHeight > 0, finalSize.height < style.minHeight {
            finalSize.height = style.minHeight
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

        measurementCache.setObject(CachedMeasurement(size: finalSize), forKey: key)
        return finalSize
    }

    private static func textConstraintWidth(for style: TextTagStyle, maxSize: CGSize) -> CGFloat {
        var tagWidthLimit = CGFloat.greatestFiniteMagnitude
        if maxSize.width > 0 {
            tagWidthLimit = min(tagWidthLimit, maxSize.width)
        }
        if style.maxWidth > 0 {
            tagWidthLimit = min(tagWidthLimit, style.maxWidth)
        }
        if style.exactWidth > 0 {
            tagWidthLimit = min(tagWidthLimit, style.exactWidth)
        }

        guard tagWidthLimit < CGFloat.greatestFiniteMagnitude else {
            return CGFloat.greatestFiniteMagnitude
        }
        return max(0, tagWidthLimit - style.extraSpace.width)
    }

    private static func measuredTextBounds(
        for attributedString: NSAttributedString,
        constrainedWidth: CGFloat,
        constrainedHeight: CGFloat,
        numberOfLines: Int
    ) -> CGRect {
        let boundedWidth = constrainedWidth > 0 ? constrainedWidth : CGFloat.greatestFiniteMagnitude
        let fullBounds = attributedString.boundingRect(
            with: CGSize(width: boundedWidth, height: constrainedHeight),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        guard numberOfLines > 0 else { return fullBounds }

        let singleLineBounds = attributedString.boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: constrainedHeight),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        let maxLineHeight = ceil(singleLineBounds.height) * CGFloat(numberOfLines)
        return CGRect(
            origin: .zero,
            size: CGSize(
                width: min(fullBounds.width, boundedWidth),
                height: min(fullBounds.height, maxLineHeight)
            )
        )
    }

    private static func measurementCacheKey(
        attributedString: NSAttributedString,
        style: TextTagStyle,
        selected: Bool,
        maxSize: CGSize
    ) -> NSString {
        let parts: [String] = [
            attributedString.string,
            String(attributedString.hash),
            selected ? "1" : "0",
            cacheValue(style.extraSpace.width),
            cacheValue(style.extraSpace.height),
            String(style.numberOfLines),
            String(style.lineBreakMode.rawValue),
            cacheValue(style.maxWidth),
            cacheValue(style.minWidth),
            cacheValue(style.maxHeight),
            cacheValue(style.minHeight),
            cacheValue(style.exactWidth),
            cacheValue(style.exactHeight),
            cacheValue(maxSize.width),
            cacheValue(maxSize.height),
        ]
        return parts.joined(separator: "|") as NSString
    }

    private static func cacheValue(_ value: CGFloat) -> String {
        return String(format: "%.3f", Double(value))
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

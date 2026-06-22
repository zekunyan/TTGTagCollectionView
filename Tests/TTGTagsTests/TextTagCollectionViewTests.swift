//
//  TextTagCollectionViewTests.swift
//  TTGTagsTests
//

import XCTest
import UIKit
@testable import TTGTags

final class TextTagCollectionViewTests: XCTestCase {

    func testProgrammaticSelectionRelayoutsWhenSelectedStyleChangesSize() {
        let view = TextTagCollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.contentInset = .zero
        view.horizontalSpacing = 0
        view.verticalSpacing = 0

        let first = makeTag(width: 45, height: 20)
        let selectedStyle = makeStyle(width: 80, height: 20)
        first.selectedStyle = selectedStyle

        let second = makeTag(width: 45, height: 20)
        view.add(tags: [first, second])
        view.reload()

        XCTAssertEqual(view.contentSize.height, 20)

        view.updateTag(at: 0, selected: true)

        XCTAssertEqual(view.contentSize.height, 40)
    }

    func testUpdatingTagRelayoutsWhenSizeChanges() {
        let view = TextTagCollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.contentInset = .zero
        view.horizontalSpacing = 0
        view.verticalSpacing = 0

        view.add(tags: [
            makeTag(width: 45, height: 20),
            makeTag(width: 45, height: 20),
        ])
        view.reload()

        XCTAssertEqual(view.contentSize.height, 20)

        view.updateTag(at: 0, with: makeTag(width: 80, height: 20))

        XCTAssertEqual(view.contentSize.height, 40)
    }

    func testStaticContentSizeMatchesRenderedContentSize() {
        TextTagCollectionView.clearMeasurementCache()

        let tags = [
            makeTag(width: 45, height: 20),
            makeTag(width: 45, height: 20),
            makeTag(width: 45, height: 20),
        ]

        let view = TextTagCollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        view.horizontalSpacing = 4
        view.verticalSpacing = 4
        view.alignment = .left
        view.add(tags: tags)
        view.reload()

        let measuredSize = TextTagCollectionView.contentSize(
            for: tags,
            width: 100,
            scrollDirection: .vertical,
            alignment: .left,
            numberOfLines: 0,
            horizontalSpacing: 4,
            verticalSpacing: 4,
            contentInset: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        )

        XCTAssertEqual(measuredSize.width, view.contentSize.width, accuracy: 0.5)
        XCTAssertEqual(measuredSize.height, view.contentSize.height, accuracy: 0.5)
    }

    func testStaticContentSizeRespectsHorizontalDistribution() {
        let tags = [
            makeTag(width: 100, height: 20),
            makeTag(width: 100, height: 20),
            makeTag(width: 100, height: 20),
            makeTag(width: 10, height: 20),
            makeTag(width: 10, height: 20),
        ]

        let rowMajor = TextTagCollectionView.contentSize(
            for: tags,
            width: 0,
            scrollDirection: .horizontal,
            alignment: .left,
            horizontalDistribution: .rowMajor,
            numberOfLines: 2,
            horizontalSpacing: 4,
            verticalSpacing: 4,
            contentInset: .zero
        )
        let columnMajor = TextTagCollectionView.contentSize(
            for: tags,
            width: 0,
            scrollDirection: .horizontal,
            alignment: .left,
            horizontalDistribution: .columnMajor,
            numberOfLines: 2,
            horizontalSpacing: 4,
            verticalSpacing: 4,
            contentInset: .zero
        )

        XCTAssertGreaterThan(rowMajor.width, columnMajor.width)
    }

    func testUpdateTagByIdUpdatesMatchingTag() {
        let view = TextTagCollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let first = makeTag(width: 40, height: 20)
        let second = makeTag(width: 40, height: 20)
        view.add(tags: [first, second])
        view.reload()

        view.updateTag(byId: second.tagId, selected: true)

        XCTAssertFalse(first.selected)
        XCTAssertTrue(second.selected)
        XCTAssertEqual(view.indexOfTag(byId: second.tagId), 1)
        XCTAssertEqual(view.getTag(byId: second.tagId), second)
    }

    func testMoveTagReordersTagsAndKeepsModelState() {
        let view = TextTagCollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let first = makeTag(width: 40, height: 20)
        first.selected = true
        first.attachment = "payload" as NSString
        let second = makeTag(width: 40, height: 20)
        let third = makeTag(width: 40, height: 20)
        view.add(tags: [first, second, third])
        view.reload()

        XCTAssertTrue(view.moveTag(at: 0, to: 2))

        XCTAssertEqual(view.allTags().map(\.tagId), [second.tagId, third.tagId, first.tagId])
        XCTAssertTrue(view.getTag(at: 2)?.selected == true)
        XCTAssertEqual(view.getTag(at: 2)?.attachment as? NSString, "payload")
    }

    func testMoveTagRejectsInvalidIndexes() {
        let view = TextTagCollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let first = makeTag(width: 40, height: 20)
        let second = makeTag(width: 40, height: 20)
        view.add(tags: [first, second])
        view.reload()

        XCTAssertFalse(view.moveTag(at: -1, to: 1))
        XCTAssertFalse(view.moveTag(at: 0, to: 2))
        XCTAssertFalse(view.moveTag(at: 0, to: 0))
        XCTAssertEqual(view.allTags().map(\.tagId), [first.tagId, second.tagId])
    }

    func testMoveTagByIdMovesMatchingTag() {
        let view = TextTagCollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let first = makeTag(width: 40, height: 20)
        let second = makeTag(width: 40, height: 20)
        let third = makeTag(width: 40, height: 20)
        view.add(tags: [first, second, third])
        view.reload()

        XCTAssertTrue(view.moveTag(byId: third.tagId, to: 0))

        XCTAssertEqual(view.allTags().map(\.tagId), [third.tagId, first.tagId, second.tagId])
    }

    func testDragDeleteZoneCustomizationPropertiesAreMutable() {
        let view = TextTagCollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let backgroundColor = UIColor.systemGray
        let highlightedColor = UIColor.systemOrange
        let textColor = UIColor.systemYellow
        let imageTintColor = UIColor.systemGreen
        let font = UIFont.systemFont(ofSize: 12, weight: .bold)
        let image = UIImage(systemName: "xmark.circle")

        view.dragDeleteZoneHeight = 64
        view.dragDeleteZoneInsets = UIEdgeInsets(top: 4, left: 20, bottom: 12, right: 20)
        view.dragDeleteZoneCornerRadius = 18
        view.dragDeleteZoneBackgroundColor = backgroundColor
        view.dragDeleteZoneHighlightedBackgroundColor = highlightedColor
        view.dragDeleteZoneText = "Drop here"
        view.dragDeleteZoneTextColor = textColor
        view.dragDeleteZoneFont = font
        view.dragDeleteZoneImage = image
        view.dragDeleteZoneImageTintColor = imageTintColor

        XCTAssertEqual(view.dragDeleteZoneHeight, 64)
        XCTAssertEqual(view.dragDeleteZoneInsets, UIEdgeInsets(top: 4, left: 20, bottom: 12, right: 20))
        XCTAssertEqual(view.dragDeleteZoneCornerRadius, 18)
        XCTAssertEqual(view.dragDeleteZoneBackgroundColor, backgroundColor)
        XCTAssertEqual(view.dragDeleteZoneHighlightedBackgroundColor, highlightedColor)
        XCTAssertEqual(view.dragDeleteZoneText, "Drop here")
        XCTAssertEqual(view.dragDeleteZoneTextColor, textColor)
        XCTAssertEqual(view.dragDeleteZoneFont, font)
        XCTAssertEqual(view.dragDeleteZoneImage, image)
        XCTAssertEqual(view.dragDeleteZoneImageTintColor, imageTintColor)
    }

    func testMoveTagRespectsDelegateCanMove() {
        let view = TextTagCollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let delegate = MoveDelegate()
        delegate.allowMove = false
        view.delegate = delegate
        let first = makeTag(width: 40, height: 20)
        let second = makeTag(width: 40, height: 20)
        view.add(tags: [first, second])
        view.reload()

        XCTAssertFalse(view.moveTag(at: 0, to: 1))

        XCTAssertEqual(delegate.canMoveCalls, 1)
        XCTAssertEqual(delegate.didMoveCalls, 0)
        XCTAssertEqual(view.allTags().map(\.tagId), [first.tagId, second.tagId])
    }

    func testMoveTagNotifiesDelegateOnce() {
        let view = TextTagCollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let delegate = MoveDelegate()
        view.delegate = delegate
        let first = makeTag(width: 40, height: 20)
        let second = makeTag(width: 40, height: 20)
        view.add(tags: [first, second])
        view.reload()

        XCTAssertTrue(view.moveTag(at: 0, to: 1))

        XCTAssertEqual(delegate.canMoveCalls, 1)
        XCTAssertEqual(delegate.didMoveCalls, 1)
        XCTAssertEqual(delegate.lastMoveFromIndex, 0)
        XCTAssertEqual(delegate.lastMoveToIndex, 1)
        XCTAssertEqual(delegate.lastMovedTagId, first.tagId)
    }

    func testDragTargetIndexFallsBackToNearestTagCenter() {
        let view = TextTagCollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        view.contentInset = .zero
        view.horizontalSpacing = 10
        view.verticalSpacing = 0
        let tags = [
            makeTag(width: 40, height: 20),
            makeTag(width: 40, height: 20),
            makeTag(width: 40, height: 20),
        ]
        view.add(tags: tags)
        view.reload()

        let target = view.targetIndexForDragLocation(CGPoint(x: 96, y: 10))

        XCTAssertEqual(target, 2)
    }

    func testScrollToTagByIdCentersHorizontalTag() {
        let view = TextTagCollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        view.scrollDirection = .horizontal
        view.numberOfLines = 1
        view.contentInset = .zero
        view.horizontalSpacing = 0
        view.verticalSpacing = 0

        let tags = [
            makeTag(width: 80, height: 20),
            makeTag(width: 80, height: 20),
            makeTag(width: 80, height: 20),
        ]
        view.add(tags: tags)
        view.reload()

        view.scrollToTag(byId: tags[2].tagId, position: .center, animated: false)

        XCTAssertGreaterThan(view.scrollView.contentOffset.x, 0)
    }

    func testMultilineStyleUsesMaxWidthForHeight() {
        TextTagCollectionView.clearMeasurementCache()

        let content = TextTagStringContent(text: "Long text should wrap onto more than one line")
        content.textFont = .systemFont(ofSize: 16)
        let style = TextTagStyle()
        style.numberOfLines = 0
        style.maxWidth = 120
        style.extraSpace = CGSize(width: 12, height: 8)
        let tag = TextTag(content: content, style: style)

        let view = TextTagCollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.contentInset = .zero
        view.horizontalSpacing = 0
        view.verticalSpacing = 0
        view.add(tag: tag)
        view.reload()

        XCTAssertLessThanOrEqual(view.frameForTag(at: 0).width, 120)
        XCTAssertGreaterThan(view.contentSize.height, 30)
    }

    private func makeTag(width: CGFloat, height: CGFloat) -> TextTag {
        let content = TextTagStringContent(text: "Tag")
        let style = makeStyle(width: width, height: height)
        return TextTag(content: content, style: style)
    }

    private func makeStyle(width: CGFloat, height: CGFloat) -> TextTagStyle {
        let style = TextTagStyle()
        style.exactWidth = width
        style.exactHeight = height
        style.extraSpace = .zero
        return style
    }
}

private final class MoveDelegate: NSObject, TextTagCollectionViewDelegate {
    var allowMove = true
    var canMoveCalls = 0
    var didMoveCalls = 0
    var lastMovedTagId: Int?
    var lastMoveFromIndex: Int?
    var lastMoveToIndex: Int?

    func textTagCollectionView(
        _ collectionView: TextTagCollectionView,
        canMoveTag tag: TextTag,
        fromIndex: Int,
        toIndex: Int
    ) -> Bool {
        canMoveCalls += 1
        return allowMove
    }

    func textTagCollectionView(
        _ collectionView: TextTagCollectionView,
        didMoveTag tag: TextTag,
        fromIndex: Int,
        toIndex: Int
    ) {
        didMoveCalls += 1
        lastMovedTagId = tag.tagId
        lastMoveFromIndex = fromIndex
        lastMoveToIndex = toIndex
    }
}

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

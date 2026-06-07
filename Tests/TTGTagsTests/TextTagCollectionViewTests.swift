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

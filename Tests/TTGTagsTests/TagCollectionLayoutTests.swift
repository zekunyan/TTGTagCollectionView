//
//  TagCollectionLayoutTests.swift
//  TTGTagsTests
//

import XCTest
import UIKit
@testable import TTGTags

final class TagCollectionLayoutTests: XCTestCase {

    private func makeInput(
        sizes: [CGSize],
        direction: TagCollectionScrollDirection = .vertical,
        alignment: TagCollectionAlignment = .left,
        numberOfLines: Int = 0,
        horizontalSpacing: CGFloat = 4,
        verticalSpacing: CGFloat = 4,
        containerWidth: CGFloat = 200,
        contentInset: UIEdgeInsets = .init(top: 2, left: 2, bottom: 2, right: 2)
    ) -> TagCollectionLayout.Input {
        return TagCollectionLayout.Input(
            tagSizes: sizes,
            scrollDirection: direction,
            alignment: alignment,
            horizontalDistribution: .rowMajor,
            contentVerticalAlignment: .top,
            numberOfLines: numberOfLines,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            contentInset: contentInset,
            containerWidth: containerWidth,
            containerHeight: 0
        )
    }

    // Vertical scroll - basic line wrapping
    func testVerticalMultipleLines() {
        // Container width 200, left/right inset=2, usable width 196
        // 3 items of 100x20 + spacing 4 → 100+4+100 = 204 > 196, so wrap to new line
        // Result: 3 lines with 1 tag each.
        let sizes = [
            CGSize(width: 100, height: 20),
            CGSize(width: 100, height: 20),
            CGSize(width: 100, height: 20),
        ]
        let out = TagCollectionLayout.calculate(makeInput(sizes: sizes))
        XCTAssertEqual(out.actualNumberOfLines, 3)
        XCTAssertEqual(out.tagFrames.count, 3)

        // Each tag should retain its original width
        for frame in out.tagFrames {
            XCTAssertEqual(frame.frame.width, 100)
            XCTAssertEqual(frame.frame.height, 20)
            XCTAssertFalse(frame.hidden)
        }
        // Y should be monotonically increasing
        XCTAssertLessThan(out.tagFrames[0].frame.minY, out.tagFrames[1].frame.minY)
        XCTAssertLessThan(out.tagFrames[1].frame.minY, out.tagFrames[2].frame.minY)
    }

    // Vertical scroll - number of lines limit hides overflow tags
    func testVerticalNumberOfLinesHidesOverflow() {
        let sizes = Array(repeating: CGSize(width: 100, height: 20), count: 4)
        var input = makeInput(sizes: sizes)
        input = TagCollectionLayout.Input(
            tagSizes: input.tagSizes,
            scrollDirection: input.scrollDirection,
            alignment: input.alignment,
            horizontalDistribution: input.horizontalDistribution,
            contentVerticalAlignment: input.contentVerticalAlignment,
            numberOfLines: 2,
            horizontalSpacing: input.horizontalSpacing,
            verticalSpacing: input.verticalSpacing,
            contentInset: input.contentInset,
            containerWidth: input.containerWidth,
            containerHeight: input.containerHeight
        )
        let out = TagCollectionLayout.calculate(input)
        XCTAssertEqual(out.actualNumberOfLines, 4)
        XCTAssertFalse(out.tagFrames[0].hidden)
        XCTAssertFalse(out.tagFrames[1].hidden)
        XCTAssertTrue(out.tagFrames[2].hidden)
        XCTAssertTrue(out.tagFrames[3].hidden)
    }

    // Horizontal scroll - row-major distribution across lines
    func testHorizontalRowMajorDistribution() {
        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 60, height: 20),
            CGSize(width: 70, height: 20),
            CGSize(width: 80, height: 20),
        ]
        let input = makeInput(sizes: sizes, direction: .horizontal, numberOfLines: 2, containerWidth: 0)
        let out = TagCollectionLayout.calculate(input)
        XCTAssertEqual(out.actualNumberOfLines, 2)
        XCTAssertEqual(out.tagFrames.count, 4)

        // tag 0 and tag 1 on line 0; tag 2 and tag 3 on line 1
        // Y should be the same within each line
        XCTAssertEqual(out.tagFrames[0].frame.minY, out.tagFrames[1].frame.minY)
        XCTAssertEqual(out.tagFrames[2].frame.minY, out.tagFrames[3].frame.minY)
        XCTAssertNotEqual(out.tagFrames[0].frame.minY, out.tagFrames[2].frame.minY)
    }

    func testHorizontalColumnMajorDistribution() {
        var input = makeInput(
            sizes: [
                CGSize(width: 50, height: 20),
                CGSize(width: 60, height: 20),
                CGSize(width: 70, height: 20),
                CGSize(width: 80, height: 20),
            ],
            direction: .horizontal,
            numberOfLines: 2,
            containerWidth: 0
        )
        input = TagCollectionLayout.Input(
            tagSizes: input.tagSizes,
            scrollDirection: input.scrollDirection,
            alignment: input.alignment,
            horizontalDistribution: .columnMajor,
            contentVerticalAlignment: input.contentVerticalAlignment,
            numberOfLines: input.numberOfLines,
            horizontalSpacing: input.horizontalSpacing,
            verticalSpacing: input.verticalSpacing,
            contentInset: input.contentInset,
            containerWidth: input.containerWidth,
            containerHeight: input.containerHeight
        )
        let out = TagCollectionLayout.calculate(input)

        XCTAssertEqual(out.tagFrames[0].frame.minY, out.tagFrames[2].frame.minY)
        XCTAssertEqual(out.tagFrames[1].frame.minY, out.tagFrames[3].frame.minY)
        XCTAssertNotEqual(out.tagFrames[0].frame.minY, out.tagFrames[1].frame.minY)
    }

    func testHorizontalDefaultsToOneLine() {
        let out = TagCollectionLayout.calculate(makeInput(
            sizes: [CGSize(width: 50, height: 20)],
            direction: .horizontal,
            numberOfLines: 0
        ))
        XCTAssertEqual(out.actualNumberOfLines, 1)
    }

    // Alignment - center
    func testCenterAlignment() {
        // Usable width 196; one 100x20 tag → should be centered → x = 2 + (196-100)/2 = 50
        let sizes = [CGSize(width: 100, height: 20)]
        let input = makeInput(sizes: sizes, alignment: .center)
        let out = TagCollectionLayout.calculate(input)
        XCTAssertEqual(out.tagFrames[0].frame.minX, 50, accuracy: 0.5)
    }

    // Alignment - fill by expanding width
    func testFillByExpandingWidth() {
        // Two 50x20 tags, spacing 4, usable width 196
        // Base line width = 50+4+50 = 104, two tags in one line → additionWidth = (196-104)/2 = 46
        // Final width per tag = 50 + 46 = 96
        let sizes = [CGSize(width: 50, height: 20), CGSize(width: 50, height: 20)]
        let input = makeInput(sizes: sizes, alignment: .fillByExpandingWidth)
        let out = TagCollectionLayout.calculate(input)
        XCTAssertEqual(out.tagFrames[0].frame.width, 96, accuracy: 0.5)
        XCTAssertEqual(out.tagFrames[1].frame.width, 96, accuracy: 0.5)
    }

    // Empty input
    func testEmptyInput() {
        let out = TagCollectionLayout.calculate(makeInput(sizes: []))
        // No tags, no frames
        XCTAssertEqual(out.tagFrames.count, 0)
        XCTAssertEqual(out.contentSize.height, 4)
    }

    func testVerticalEmptyInputDoesNotSubtractSpacing() {
        let out = TagCollectionLayout.calculate(makeInput(
            sizes: [],
            verticalSpacing: 8,
            contentInset: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        ))
        XCTAssertEqual(out.contentSize.height, 4)
    }

    func testVerticalEmptyInputWithZeroInsetsDoesNotGoNegative() {
        let out = TagCollectionLayout.calculate(makeInput(
            sizes: [],
            verticalSpacing: 8,
            contentInset: .zero
        ))
        XCTAssertEqual(out.contentSize.height, 0)
    }

    func testContentVerticalAlignmentCentersShortContentInFixedHeight() {
        let base = makeInput(
            sizes: [CGSize(width: 50, height: 20)],
            containerWidth: 100,
            contentInset: .zero
        )
        let input = TagCollectionLayout.Input(
            tagSizes: base.tagSizes,
            scrollDirection: base.scrollDirection,
            alignment: base.alignment,
            horizontalDistribution: base.horizontalDistribution,
            contentVerticalAlignment: .center,
            numberOfLines: base.numberOfLines,
            horizontalSpacing: base.horizontalSpacing,
            verticalSpacing: base.verticalSpacing,
            contentInset: base.contentInset,
            containerWidth: base.containerWidth,
            containerHeight: 100
        )
        let out = TagCollectionLayout.calculate(input)

        XCTAssertEqual(out.contentSize.height, 100)
        XCTAssertEqual(out.tagFrames[0].frame.minY, 40, accuracy: 0.5)
    }
}

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
            numberOfLines: numberOfLines,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            contentInset: contentInset,
            containerWidth: containerWidth
        )
    }

    // 垂直滚动 - 基本换行
    func testVerticalMultipleLines() {
        // 容器宽 200，左右 inset=2, 实际可用宽 196
        // 3 个 100x20 + 4 间距 → 单行放不下 2 个 → 每行 1 个？
        // 100 + 4 + 100 = 204 > 196，所以第二个 100 要换行。确实每行 1 个。
        // 等等：第一个 100，currentLineX=104；第二个检查 104+100=204 > 196 → 换行
        // 所以 3 行，各 1 个。
        let sizes = [
            CGSize(width: 100, height: 20),
            CGSize(width: 100, height: 20),
            CGSize(width: 100, height: 20),
        ]
        let out = TagCollectionLayout.calculate(makeInput(sizes: sizes))
        XCTAssertEqual(out.actualNumberOfLines, 3)
        XCTAssertEqual(out.tagFrames.count, 3)

        // 各 tag 宽应保留原宽度
        for frame in out.tagFrames {
            XCTAssertEqual(frame.frame.width, 100)
            XCTAssertEqual(frame.frame.height, 20)
            XCTAssertFalse(frame.hidden)
        }
        // Y 递增
        XCTAssertLessThan(out.tagFrames[0].frame.minY, out.tagFrames[1].frame.minY)
        XCTAssertLessThan(out.tagFrames[1].frame.minY, out.tagFrames[2].frame.minY)
    }

    // 垂直滚动 - 行数限制
    func testVerticalNumberOfLinesHidesOverflow() {
        let sizes = Array(repeating: CGSize(width: 100, height: 20), count: 4)
        var input = makeInput(sizes: sizes)
        input = TagCollectionLayout.Input(
            tagSizes: input.tagSizes,
            scrollDirection: input.scrollDirection,
            alignment: input.alignment,
            numberOfLines: 2,
            horizontalSpacing: input.horizontalSpacing,
            verticalSpacing: input.verticalSpacing,
            contentInset: input.contentInset,
            containerWidth: input.containerWidth
        )
        let out = TagCollectionLayout.calculate(input)
        XCTAssertEqual(out.actualNumberOfLines, 4)
        XCTAssertFalse(out.tagFrames[0].hidden)
        XCTAssertFalse(out.tagFrames[1].hidden)
        XCTAssertTrue(out.tagFrames[2].hidden)
        XCTAssertTrue(out.tagFrames[3].hidden)
    }

    // 水平滚动 - 多行 round-robin 分配
    func testHorizontalDistribution() {
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

        // tag 0 和 tag 2 在第 0 行；tag 1 和 tag 3 在第 1 行
        // 每行 y 应相同
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

    // 对齐 - 居中
    func testCenterAlignment() {
        // 可用宽 196；一个 100x20 → 应居中 → x = 2 + (196-100)/2 = 50
        let sizes = [CGSize(width: 100, height: 20)]
        let input = makeInput(sizes: sizes, alignment: .center)
        let out = TagCollectionLayout.calculate(input)
        XCTAssertEqual(out.tagFrames[0].frame.minX, 50, accuracy: 0.5)
    }

    // 对齐 - 填充扩展宽度
    func testFillByExpandingWidth() {
        // 两个 50x20 tag，间距 4，可用 196
        // 基础线宽 = 50+4+50 = 104, 一行两个 → additionWidth = (196-104)/2 = 46
        // 每个最终 width = 50 + 46 = 96
        let sizes = [CGSize(width: 50, height: 20), CGSize(width: 50, height: 20)]
        let input = makeInput(sizes: sizes, alignment: .fillByExpandingWidth)
        let out = TagCollectionLayout.calculate(input)
        XCTAssertEqual(out.tagFrames[0].frame.width, 96, accuracy: 0.5)
        XCTAssertEqual(out.tagFrames[1].frame.width, 96, accuracy: 0.5)
    }

    // 空数组
    func testEmptyInput() {
        let out = TagCollectionLayout.calculate(makeInput(sizes: []))
        // 仍然会生成一个空行（原实现行为），hidden 数组为空
        XCTAssertEqual(out.tagFrames.count, 0)
    }
}

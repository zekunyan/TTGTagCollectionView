//
//  TagCollectionLayout.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// 标签布局纯计算器。
///
/// 将原 `TTGTagCollectionView` 中的垂直/水平布局与对齐逻辑抽离为无副作用的计算过程，
/// 方便单元测试。视图层仅负责将计算结果应用到 tag 视图的 frame 上。
struct TagCollectionLayout {

    /// 单个 tag 的布局结果。
    struct TagFrame {
        let index: Int
        let frame: CGRect
        /// 因超出行数限制被隐藏。
        let hidden: Bool
    }

    /// 布局输入。
    struct Input {
        let tagSizes: [CGSize]
        let scrollDirection: TagCollectionScrollDirection
        let alignment: TagCollectionAlignment
        let numberOfLines: Int
        let horizontalSpacing: CGFloat
        let verticalSpacing: CGFloat
        let contentInset: UIEdgeInsets
        /// 容器可用总宽度（垂直滚动时用来换行计算）。
        let containerWidth: CGFloat
    }

    /// 布局结果。
    struct Output {
        let tagFrames: [TagFrame]
        let contentSize: CGSize
        let actualNumberOfLines: Int
    }

    static func calculate(_ input: Input) -> Output {
        switch input.scrollDirection {
        case .vertical:
            return calculateVertical(input)
        case .horizontal:
            return calculateHorizontal(input)
        }
    }

    // MARK: - 垂直滚动

    private static func calculateVertical(_ input: Input) -> Output {
        let count = input.tagSizes.count
        let maxLineWidth = max(0, input.containerWidth - input.contentInset.left - input.contentInset.right)

        var lineTagIndices: [[Int]] = []
        var lineWidths: [CGFloat] = []
        var lineMaxHeights: [CGFloat] = []

        var currentIndices: [Int] = []
        var currentLineX: CGFloat = 0
        var currentLineMaxHeight: CGFloat = 0

        // 第一遍：划分行
        for i in 0..<count {
            let tagSize = input.tagSizes[i]

            if currentLineX + tagSize.width > maxLineWidth && !currentIndices.isEmpty {
                // 换行
                lineTagIndices.append(currentIndices)
                lineWidths.append(currentLineX - input.horizontalSpacing)
                lineMaxHeights.append(currentLineMaxHeight)

                currentIndices = []
                currentLineX = 0
                currentLineMaxHeight = 0
            }

            currentLineX += tagSize.width + input.horizontalSpacing
            currentLineMaxHeight = max(currentLineMaxHeight, tagSize.height)
            currentIndices.append(i)
        }

        // 末行
        if !currentIndices.isEmpty {
            lineTagIndices.append(currentIndices)
            lineWidths.append(currentLineX - input.horizontalSpacing)
            lineMaxHeights.append(currentLineMaxHeight)
        }

        let actualLines = lineTagIndices.count

        // 行数限制：超过 numberOfLines 的行整体被截断（对应 tag hidden）
        var visibleLineCount = actualLines
        if input.numberOfLines > 0 {
            visibleLineCount = min(actualLines, input.numberOfLines)
        }

        let hiddenIndices: Set<Int> = {
            guard input.numberOfLines > 0, actualLines > input.numberOfLines else { return [] }
            var set = Set<Int>()
            for i in input.numberOfLines..<actualLines {
                for idx in lineTagIndices[i] { set.insert(idx) }
            }
            return set
        }()

        let visibleLines = Array(lineTagIndices.prefix(visibleLineCount))
        let visibleWidths = Array(lineWidths.prefix(visibleLineCount))
        let visibleMaxHeights = Array(lineMaxHeights.prefix(visibleLineCount))

        let frames = layoutLines(
            maxLineWidth: maxLineWidth,
            lineTagIndices: visibleLines,
            lineWidths: visibleWidths,
            lineMaxHeights: visibleMaxHeights,
            input: input,
            hiddenIndices: hiddenIndices,
            totalCount: count
        )

        return Output(
            tagFrames: frames.tagFrames,
            contentSize: frames.contentSize,
            actualNumberOfLines: actualLines
        )
    }

    // MARK: - 水平滚动

    private static func calculateHorizontal(_ input: Input) -> Output {
        let count = input.tagSizes.count
        let numberOfLines = max(1, input.numberOfLines)

        var lineTagIndices: [[Int]] = Array(repeating: [], count: numberOfLines)
        var lineWidths: [CGFloat] = Array(repeating: 0, count: numberOfLines)
        var lineMaxHeights: [CGFloat] = Array(repeating: 0, count: numberOfLines)

        for tagIndex in 0..<count {
            let line = tagIndex % numberOfLines
            let size = input.tagSizes[tagIndex]
            lineWidths[line] += size.width + input.horizontalSpacing
            lineMaxHeights[line] = max(lineMaxHeights[line], size.height)
            lineTagIndices[line].append(tagIndex)
        }

        var maxLineWidth: CGFloat = 0
        for i in 0..<numberOfLines {
            lineWidths[i] -= input.horizontalSpacing
            maxLineWidth = max(maxLineWidth, lineWidths[i])
        }

        let result = layoutLines(
            maxLineWidth: maxLineWidth,
            lineTagIndices: lineTagIndices,
            lineWidths: lineWidths,
            lineMaxHeights: lineMaxHeights,
            input: input,
            hiddenIndices: [],
            totalCount: count
        )

        return Output(
            tagFrames: result.tagFrames,
            contentSize: result.contentSize,
            actualNumberOfLines: numberOfLines
        )
    }

    // MARK: - 公共布局：按行放置 tags 并处理对齐

    private static func layoutLines(
        maxLineWidth: CGFloat,
        lineTagIndices: [[Int]],
        lineWidths: [CGFloat],
        lineMaxHeights: [CGFloat],
        input: Input,
        hiddenIndices: Set<Int>,
        totalCount: Int
    ) -> (tagFrames: [TagFrame], contentSize: CGSize) {
        var frames: [CGRect] = Array(repeating: .zero, count: totalCount)

        var currentYBase = input.contentInset.top
        let lineCount = lineTagIndices.count

        for lineIndex in 0..<lineCount {
            var currentLineWidth = lineWidths[lineIndex]
            let currentLineMaxHeight = lineMaxHeights[lineIndex]
            let currentLineTagsCount = lineTagIndices[lineIndex].count

            var currentLineXOffset: CGFloat = 0
            var currentLineAdditionWidth: CGFloat = 0
            var actualHorizontalSpacing = input.horizontalSpacing

            switch input.alignment {
            case .left:
                currentLineXOffset = input.contentInset.left
            case .center:
                currentLineXOffset = (maxLineWidth - currentLineWidth) / 2 + input.contentInset.left
            case .right:
                currentLineXOffset = maxLineWidth - currentLineWidth + input.contentInset.left
            case .fillByExpandingSpace:
                currentLineXOffset = input.contentInset.left
                if currentLineTagsCount > 1 {
                    actualHorizontalSpacing = input.horizontalSpacing +
                        (maxLineWidth - currentLineWidth) / CGFloat(currentLineTagsCount - 1)
                }
                currentLineWidth = maxLineWidth
            case .fillByExpandingWidth, .fillByExpandingWidthExceptLastLine:
                currentLineXOffset = input.contentInset.left
                if currentLineTagsCount > 0 {
                    currentLineAdditionWidth = (maxLineWidth - currentLineWidth) / CGFloat(currentLineTagsCount)
                }
                currentLineWidth = maxLineWidth
                // 最后一行不扩展
                if input.alignment == .fillByExpandingWidthExceptLastLine
                    && lineIndex == lineCount - 1
                    && lineCount != 1 {
                    currentLineAdditionWidth = 0
                }
            }

            var currentLineX: CGFloat = 0
            for tagIndex in lineTagIndices[lineIndex] {
                var tagSize = input.tagSizes[tagIndex]

                let originX = currentLineXOffset + currentLineX
                let originY = currentYBase + (currentLineMaxHeight - tagSize.height) / 2

                tagSize.width += currentLineAdditionWidth
                if input.scrollDirection == .vertical && tagSize.width > maxLineWidth {
                    tagSize.width = maxLineWidth
                }

                frames[tagIndex] = CGRect(
                    origin: CGPoint(x: originX, y: originY),
                    size: tagSize
                )
                currentLineX += tagSize.width + actualHorizontalSpacing
            }

            currentYBase += currentLineMaxHeight + input.verticalSpacing
        }

        let contentWidth = maxLineWidth + input.contentInset.left + input.contentInset.right
        let contentHeight = currentYBase - input.verticalSpacing + input.contentInset.bottom
        let contentSize = CGSize(width: contentWidth, height: contentHeight)

        var output: [TagFrame] = []
        output.reserveCapacity(totalCount)
        for i in 0..<totalCount {
            output.append(TagFrame(
                index: i,
                frame: frames[i],
                hidden: hiddenIndices.contains(i)
            ))
        }

        return (output, contentSize)
    }
}

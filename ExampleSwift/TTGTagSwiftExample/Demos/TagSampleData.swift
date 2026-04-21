//
//  TagSampleData.swift
//  TTGTagSwiftExample
//

import Foundation

enum TagSampleData {

    /// 长段落拆分词，用于两列和大列表 Demo
    static let autoLayoutLongParagraphWords: [String] = [
        "AutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayout",
        "dynamically", "calculates", "the", "size", "and", "position",
        "of", "all", "the", "views", "in", "your", "view", "hierarchy", "based",
        "on", "constraints", "placed", "on", "those", "views",
        "For", "example", "you", "can", "constrain", "a", "button",
        "so", "that", "it", "is", "horizontally", "centered", "with",
        "an", "Image", "view", "and", "so", "that", "the", "button's",
        "top", "edge", "always", "remains", "8", "points", "below", "the",
        "image's", "bottom", "If", "the", "image", "view's", "size", "or",
        "position", "changes", "the", "button's", "position", "automatically", "adjusts", "to", "match"
    ]

    /// 短词列表（约22个词），大多数 Demo 复用
    static let shortSampleWords: [String] = [
        "AutoLayout", "dynamically", "calculates", "the", "size", "and", "position",
        "of", "all", "the", "views", "in", "your", "view", "hierarchy", "based",
        "on", "constraints", "placed", "on", "those", "views"
    ]

    /// 将 shortSampleWords 重复 N 次，构建大数组
    static func shortWordsRepeated(count: Int) -> [String] {
        guard count > 0 else { return [] }
        return (0..<count).flatMap { _ in shortSampleWords }
    }
}

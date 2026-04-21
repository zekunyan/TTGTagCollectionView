//
//  TagSampleData.swift
//  TTGTagSwiftExample
//

import Foundation

enum TagSampleData {

    /// Long paragraph words, used for two-column and large list demos
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

    /// Short word list (~22 words), reused by most demos
    static let shortSampleWords: [String] = [
        "AutoLayout", "dynamically", "calculates", "the", "size", "and", "position",
        "of", "all", "the", "views", "in", "your", "view", "hierarchy", "based",
        "on", "constraints", "placed", "on", "those", "views"
    ]

    /// Repeat shortSampleWords N times to build a large array
    static func shortWordsRepeated(count: Int) -> [String] {
        guard count > 0 else { return [] }
        return (0..<count).flatMap { _ in shortSampleWords }
    }
}

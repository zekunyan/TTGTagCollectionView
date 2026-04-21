//
//  TextTagContentTests.swift
//  TTGTagsTests
//

import XCTest
import UIKit
@testable import TTGTags

final class TextTagContentTests: XCTestCase {

    func testStringContentAttributedStringAndDefaults() {
        let c = TextTagStringContent(text: "hello")
        let attr = c.getContentAttributedString()
        XCTAssertEqual(attr.string, "hello")

        // 默认字体 / 颜色
        let attributes = attr.attributes(at: 0, effectiveRange: nil)
        XCTAssertTrue(attributes[.foregroundColor] is UIColor)
        XCTAssertTrue(attributes[.font] is UIFont)
    }

    func testStringContentCopy() {
        let c = TextTagStringContent(text: "x", textFont: .systemFont(ofSize: 20), textColor: .red)
        guard let copy = c.copy() as? TextTagStringContent else {
            XCTFail("copy should return TextTagStringContent")
            return
        }
        XCTAssertEqual(copy.text, "x")
        XCTAssertEqual(copy.textFont.pointSize, 20)
        XCTAssertEqual(copy.textColor, .red)
        XCTAssertFalse(copy === c)
    }

    func testAttributedStringContent() {
        let attr = NSAttributedString(string: "rich", attributes: [.foregroundColor: UIColor.blue])
        let c = TextTagAttributedStringContent(attributedText: attr)
        XCTAssertEqual(c.getContentAttributedString().string, "rich")

        guard let copy = c.copy() as? TextTagAttributedStringContent else {
            XCTFail("copy should return TextTagAttributedStringContent")
            return
        }
        XCTAssertEqual(copy.attributedText.string, "rich")
    }

    func testSwiftStyleAliasMatchesMethod() {
        let c = TextTagStringContent(text: "y")
        XCTAssertEqual(c.contentAttributedString.string, c.getContentAttributedString().string)
    }
}

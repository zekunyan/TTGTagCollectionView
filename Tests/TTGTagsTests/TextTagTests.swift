//
//  TextTagTests.swift
//  TTGTagsTests
//

import XCTest
@testable import TTGTags

final class TextTagTests: XCTestCase {

    func testUniqueTagId() {
        let tag1 = TextTag()
        let tag2 = TextTag()
        XCTAssertNotEqual(tag1.tagId, tag2.tagId)
    }

    func testEqualityByTagId() {
        let tag = TextTag()
        XCTAssertTrue(tag.isEqual(to: tag))
        XCTAssertFalse(tag.isEqual(to: TextTag()))
        XCTAssertFalse(tag.isEqual(to: nil))
    }

    func testCopyPreservesFieldsButNewId() {
        let content = TextTagStringContent(text: "hello")
        let style = TextTagStyle()
        style.cornerRadius = 8
        let tag = TextTag(content: content, style: style)
        tag.selected = true
        tag.attachment = "foo" as NSString

        guard let copied = tag.copy() as? TextTag else {
            XCTFail("copy should return TextTag")
            return
        }

        XCTAssertTrue((copied.content as? TextTagStringContent)?.text == "hello")
        XCTAssertEqual(copied.style.cornerRadius, 8)
        XCTAssertTrue(copied.selected)
        XCTAssertEqual(copied.attachment as? String, "foo")
    }

    func testCopyDeepCopiesMutableContentAndStyle() {
        let content = TextTagStringContent(text: "hello")
        let style = TextTagStyle()
        style.cornerRadius = 8
        let selectedContent = TextTagStringContent(text: "selected")
        let selectedStyle = TextTagStyle()
        selectedStyle.cornerRadius = 12

        let tag = TextTag(
            content: content,
            style: style,
            selectedContent: selectedContent,
            selectedStyle: selectedStyle
        )

        guard let copied = tag.copy() as? TextTag,
              let copiedContent = copied.content as? TextTagStringContent,
              let copiedSelectedContent = copied.selectedContent as? TextTagStringContent else {
            XCTFail("copy should preserve concrete content types")
            return
        }

        copiedContent.text = "changed"
        copied.style.cornerRadius = 20
        copiedSelectedContent.text = "changed selected"
        copied.selectedStyle.cornerRadius = 24

        XCTAssertEqual(content.text, "hello")
        XCTAssertEqual(style.cornerRadius, 8)
        XCTAssertEqual(selectedContent.text, "selected")
        XCTAssertEqual(selectedStyle.cornerRadius, 12)
    }

    func testSelectedStateChangedCallback() {
        let tag = TextTag()
        var captured: Bool?
        tag.onSelectStateChanged = { selected in
            captured = selected
        }
        tag.selected = true
        XCTAssertEqual(captured, true)
        tag.selected = false
        XCTAssertEqual(captured, false)
    }

    func testSelectedContentFallbacksToContentCopy() {
        let content = TextTagStringContent(text: "hi")
        let style = TextTagStyle()
        let tag = TextTag(content: content, style: style)

        // selectedContent not explicitly set, should fall back to a copy of content
        guard let fallback = tag.selectedContent as? TextTagStringContent else {
            XCTFail("selectedContent fallback should be string content")
            return
        }
        XCTAssertEqual(fallback.text, "hi")
        // Should be a copy, not the same object
        XCTAssertFalse(fallback === content)
    }

    func testRightfulStyleFollowsSelectedState() {
        let normal = TextTagStyle()
        normal.cornerRadius = 2
        let selected = TextTagStyle()
        selected.cornerRadius = 10

        let tag = TextTag(
            content: TextTagStringContent(text: "x"),
            style: normal,
            selectedContent: nil,
            selectedStyle: selected
        )
        XCTAssertEqual(tag.rightfulStyle.cornerRadius, 2)
        tag.selected = true
        XCTAssertEqual(tag.rightfulStyle.cornerRadius, 10)
    }
}

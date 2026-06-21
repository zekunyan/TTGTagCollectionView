//
//  DemoUI.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

enum DemoUI {

    static func applyScreenBackground(_ view: UIView) {
        view.backgroundColor = .systemBackground
    }

    static func titleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }

    static func descriptionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }

    static func sectionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }

    static func styleTagSurface(_ view: UIView) {
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    }

    static func styleLogLabel(_ label: UILabel) {
        label.text = "Tap a tag to inspect the callback."
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
    }

    static func styleLogTextView(_ textView: UITextView) {
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 10
        textView.textColor = .secondaryLabel
        textView.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isEditable = false
    }

    static func stylePrimaryButton(_ button: UIButton) {
        var configuration = UIButton.Configuration.plain()
        if let title = button.title(for: .normal) {
            var attributedTitle = AttributedString(title)
            attributedTitle.font = .systemFont(ofSize: 15, weight: .semibold)
            configuration.attributedTitle = attributedTitle
        }
        configuration.baseForegroundColor = .systemBlue
        configuration.background.backgroundColor = .systemGray6
        configuration.background.cornerRadius = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)
        button.configuration = configuration
    }

    static func content(text: String) -> TextTagStringContent {
        let content = TextTagStringContent(text: text)
        content.textFont = .systemFont(ofSize: 14, weight: .medium)
        content.textColor = .white
        return content
    }

    static func tag(text: String) -> TextTag {
        let tag = TextTag(content: content(text: text), style: primaryTagStyle())
        tag.selectedStyle = selectedTagStyle(color: .systemIndigo)
        return tag
    }

    static func primaryTagStyle() -> TextTagStyle {
        let style = TextTagStyle()
        style.backgroundColor = .systemBlue
        style.cornerRadius = 14
        style.extraSpace = CGSize(width: 12, height: 6)
        style.borderWidth = 0
        style.shadowOpacity = 0
        return style
    }

    static func selectedTagStyle(color: UIColor) -> TextTagStyle {
        let style = primaryTagStyle()
        style.backgroundColor = color
        return style
    }
}

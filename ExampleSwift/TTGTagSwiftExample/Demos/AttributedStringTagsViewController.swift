//
//  AttributedStringTagsViewController.swift
//  TTGTagSwiftExample
//
//  Demo: TextTagAttributedStringContent + NSAttributedString

import UIKit
import TTGTags

// MARK: - AttributedTagExamples

private enum AttributedTagExamples {

    static func allDemonstrationTags() -> [TextTag] {
        var tags: [TextTag] = [
            tagWithDefaultChrome(content: mixedFontAndColorString()),
            tagWithDefaultChrome(content: strikethroughAndUnderlineString()),
            tagWithDefaultChrome(content: kernSpacingString()),
            tagWithDefaultChrome(content: shadowTextString()),
            tagWithDefaultChrome(content: strokeTextString()),
            tagWithDefaultChrome(content: superscriptString()),
            tagWithDefaultChrome(content: imageAttachmentString()),
        ]

        for text in ["NEW", "HOT", "PRO", "FREE"] {
            tags.append(badgeTag(text: text))
        }

        tags.append(selectableAttributedTag())
        tags.append(tagWithDefaultChrome(content: paragraphStyleString()))
        return tags
    }

    // MARK: - Attributed Strings

    private static func mixedFontAndColorString() -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(NSAttributedString(string: "Bold ", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.systemBlue,
        ]))
        result.append(NSAttributedString(string: "Italic ", attributes: [
            .font: UIFont.italicSystemFont(ofSize: 14),
            .foregroundColor: UIColor.systemRed,
        ]))
        result.append(NSAttributedString(string: "Mono", attributes: [
            .font: UIFont.monospacedSystemFont(ofSize: 13, weight: .medium),
            .foregroundColor: UIColor.systemGreen,
        ]))
        return result
    }

    private static func strikethroughAndUnderlineString() -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(NSAttributedString(string: "Strikethrough", attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.darkGray,
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.systemRed,
        ]))
        result.append(NSAttributedString(string: " + ", attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.gray,
        ]))
        result.append(NSAttributedString(string: "Underline", attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.darkGray,
            .underlineStyle: NSUnderlineStyle.double.rawValue,
            .underlineColor: UIColor.systemBlue,
        ]))
        return result
    }

    private static func kernSpacingString() -> NSAttributedString {
        NSAttributedString(string: "W I D E   S P A C I N G", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 13),
            .foregroundColor: UIColor.systemIndigo,
            .kern: 4.0,
        ])
    }

    private static func shadowTextString() -> NSAttributedString {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        shadow.shadowBlurRadius = 3
        return NSAttributedString(string: "Text Shadow", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.systemOrange,
            .shadow: shadow,
        ])
    }

    private static func strokeTextString() -> NSAttributedString {
        NSAttributedString(string: "Stroke Text", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 22),
            .foregroundColor: UIColor.systemPurple,
            .strokeColor: UIColor.systemPurple,
            .strokeWidth: 3.0,
        ])
    }

    private static func superscriptString() -> NSAttributedString {
        let result = NSMutableAttributedString()
        let normalAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.italicSystemFont(ofSize: 18),
            .foregroundColor: UIColor.label,
        ]
        let superAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor: UIColor.systemRed,
            .baselineOffset: 8.0,
        ]
        let subAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.systemBlue,
            .baselineOffset: -4.0,
        ]
        result.append(NSAttributedString(string: "E=mc", attributes: normalAttrs))
        result.append(NSAttributedString(string: "2", attributes: superAttrs))
        result.append(NSAttributedString(string: "  H", attributes: normalAttrs))
        result.append(NSAttributedString(string: "2", attributes: subAttrs))
        result.append(NSAttributedString(string: "O", attributes: normalAttrs))
        return result
    }

    private static func imageAttachmentString() -> NSAttributedString {
        let result = NSMutableAttributedString()
        let textAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.systemPink,
        ]
        let attachment = NSTextAttachment()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let heart = UIImage(systemName: "heart.fill", withConfiguration: config)
        attachment.image = heart?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)

        result.append(NSAttributedString(attachment: attachment))
        result.append(NSAttributedString(string: " Favorite ", attributes: textAttrs))
        result.append(NSAttributedString(attachment: attachment))
        return result
    }

    private static func paragraphStyleString() -> NSAttributedString {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6
        paraStyle.alignment = .center

        let result = NSMutableAttributedString(
            string: "Paragraph Style\nwith line spacing",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.secondaryLabel,
                .paragraphStyle: paraStyle,
            ]
        )
        result.addAttributes([
            .font: UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor: UIColor.label,
        ], range: NSRange(location: 0, length: 15))
        return result
    }

    // MARK: - Tag Factories

    private static func tagWithDefaultChrome(content attributedString: NSAttributedString) -> TextTag {
        let tag = TextTag()
        tag.content = TextTagAttributedStringContent(attributedText: attributedString)

        let style = TextTagStyle()
        style.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)
        style.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.87, alpha: 1)
        style.borderWidth = 1
        style.cornerRadius = 8
        style.extraSpace = CGSize(width: 10, height: 8)
        style.shadowColor = UIColor(white: 0, alpha: 0.08)
        style.shadowOffset = CGSize(width: 0, height: 1)
        style.shadowOpacity = 1
        style.shadowRadius = 2

        let selectedStyle = style.copy() as! TextTagStyle
        selectedStyle.backgroundColor = UIColor(red: 0.90, green: 0.93, blue: 1.00, alpha: 1)
        selectedStyle.borderColor = .systemBlue
        selectedStyle.borderWidth = 1.5

        tag.style = style
        tag.selectedStyle = selectedStyle
        return tag
    }

    private static func badgeTag(text: String) -> TextTag {
        let attributedString = NSAttributedString(string: text, attributes: [
            .font: UIFont.boldSystemFont(ofSize: 13),
            .foregroundColor: UIColor.white,
            .kern: 1.5,
        ])

        let tag = TextTag()
        tag.content = TextTagAttributedStringContent(attributedText: attributedString)

        var backgroundColor: UIColor
        switch text {
        case "HOT": backgroundColor = .systemOrange
        case "PRO": backgroundColor = .systemBlue
        case "FREE": backgroundColor = .systemGreen
        default: backgroundColor = .systemRed
        }

        let style = TextTagStyle()
        style.backgroundColor = backgroundColor
        style.cornerRadius = 12
        style.extraSpace = CGSize(width: 12, height: 6)
        style.shadowColor = backgroundColor.withAlphaComponent(0.4)
        style.shadowOffset = CGSize(width: 0, height: 2)
        style.shadowOpacity = 1
        style.shadowRadius = 4

        let selectedStyle = style.copy() as! TextTagStyle
        selectedStyle.backgroundColor = backgroundColor.withAlphaComponent(0.7)
        selectedStyle.shadowOpacity = 0

        tag.style = style
        tag.selectedStyle = selectedStyle
        return tag
    }

    private static func selectableAttributedTag() -> TextTag {
        let normalContent = NSAttributedString(string: "☆ Tap to Select", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.systemGray,
        ])
        let selectedContent = NSAttributedString(string: "★ Selected!", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.systemYellow,
        ])

        let tag = TextTag()
        tag.content = TextTagAttributedStringContent(attributedText: normalContent)
        tag.selectedContent = TextTagAttributedStringContent(attributedText: selectedContent)

        let style = TextTagStyle()
        style.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)
        style.borderColor = .systemGray
        style.borderWidth = 1
        style.cornerRadius = 8
        style.extraSpace = CGSize(width: 10, height: 8)

        let selectedStyle = style.copy() as! TextTagStyle
        selectedStyle.backgroundColor = UIColor(red: 0.20, green: 0.20, blue: 0.25, alpha: 1)
        selectedStyle.borderColor = .systemYellow
        selectedStyle.borderWidth = 2

        tag.style = style
        tag.selectedStyle = selectedStyle
        return tag
    }
}

// MARK: - ViewController

class AttributedStringTagsViewController: UIViewController {

    private let titleLabel = DemoUI.titleLabel("Attributed string tags")
    private let descriptionLabel = DemoUI.descriptionLabel("TextTagAttributedStringContent supports mixed fonts, colors, paragraph styles, symbols, and selectable attributed content.")
    private let textTagCollectionView = TextTagCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)
        setupSubviews()
        configureCollectionView()
        installDemonstrationTags()
    }

    private func setupSubviews() {
        DemoUI.styleTagSurface(textTagCollectionView)
        [titleLabel, descriptionLabel, textTagCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            textTagCollectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 18),
            textTagCollectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textTagCollectionView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            textTagCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

    private func configureCollectionView() {
        textTagCollectionView.delegate = self
        textTagCollectionView.alignment = .fillByExpandingWidth
        textTagCollectionView.horizontalSpacing = 8
        textTagCollectionView.verticalSpacing = 10
        textTagCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    private func installDemonstrationTags() {
        for tag in AttributedTagExamples.allDemonstrationTags() {
            textTagCollectionView.add(tag: tag)
        }
        textTagCollectionView.reload()
    }
}

// MARK: - TextTagCollectionViewDelegate

extension AttributedStringTagsViewController: TextTagCollectionViewDelegate {

    func textTagCollectionView(_ textTagCollectionView: TextTagCollectionView!,
                               didTapTag tag: TextTag!,
                               at index: Int) {
        let plain = tag.content.getContentAttributedString().string
        print("Tap [\(index)]: \"\(plain)\" selected: \(tag.selected)")
    }
}

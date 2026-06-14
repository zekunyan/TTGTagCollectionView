//
//  ScreenshotShowcaseViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

final class ScreenshotShowcaseViewController: UIViewController {

    enum Scenario: String {
        case posterOverview
        case posterAttributed
        case posterLayouts
        case quickStartCreate
        case quickStartStyle
        case quickStartSelection
        case quickStartLayout
    }

    private let scenario: Scenario
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    init(scenario: Scenario) {
        self.scenario = scenario
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.965, green: 0.976, blue: 0.988, alpha: 1)
        setupStack()
        buildScenario()
    }

    private func setupStack() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 18
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 22),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 18),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -18),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -28),
        ])
    }

    private func buildScenario() {
        switch scenario {
        case .posterOverview:
            addHeader("TTGTagCollectionView", subtitle: "Text tags, custom views, alignment, selection, rich style, and Auto Layout in one small UIKit component.")
            addMetricRow()
            addShowcasePanel(title: "Gradient text tags", subtitle: "Per-tag style: gradients, borders, shadows, padding, selected states.", tagView: gradientTags())
            addShowcasePanel(title: "Fill alignment", subtitle: "Rows can fill space or width while preserving tag order.", tagView: fillAlignmentTags())
            addShowcasePanel(title: "Horizontal line limits", subtitle: "One, two, or three-line horizontal collections for filters and chips.", tagView: horizontalTags())
            addCustomViewPanel()
        case .posterAttributed:
            addHeader("Attributed strings", subtitle: "TextTagAttributedStringContent renders mixed fonts, color, decorations, symbols, paragraph styles, and selectable attributed text.")
            addShowcasePanel(title: "Mixed font + color", subtitle: "Use NSAttributedString for bold, italic, monospace, color, kerning, and shadows.", tagView: attributedPrimaryTags())
            addShowcasePanel(title: "Decorations + symbols", subtitle: "Underline, strikethrough, stroke, superscript, subscript, and SF Symbol attachments render inside tags.", tagView: attributedDecorationTags())
            addShowcasePanel(title: "Selectable attributed content", subtitle: "Selected tags can swap both style and attributed content.", tagView: attributedSelectionTags())
            addCodeCard("""
            let content = TextTagAttributedStringContent(
                attributedText: attributedString
            )

            let tag = TextTag(content: content, style: style)
            tag.selectedContent = selectedContent
            tagView.reload()
            """)
        case .posterLayouts:
            addHeader("Layout engine", subtitle: "The same component powers wrapping tag clouds, fill-width rows, horizontal filter bars, custom UIView tags, and self-sizing cells.")
            addShowcasePanel(title: "Fill-width rows", subtitle: "Six alignment modes cover left, center, right, expanding space, and expanding width.", tagView: fillAlignmentTags())
            addShowcasePanel(title: "Horizontal filters", subtitle: "Set scrollDirection and numberOfLines for compact filter bars with overflow content.", tagView: horizontalTags())
            addShowcasePanel(title: "Dense cell preview", subtitle: "Precompute content size for table/list rows and reload once per reuse pass.", tagView: denseCellTags())
            addCustomViewPanel()
        case .quickStartCreate:
            addHeader("Quick Start 01", subtitle: "Create a TextTagCollectionView, add it to your view hierarchy, then reload after mutations.")
            addShowcasePanel(title: "Create the view", subtitle: "A plain tag cloud starts with one view instance.", tagView: basicTags())
            addCodeCard("""
            import TTGTags

            let tagView = TextTagCollectionView()
            tagView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(tagView)
            """)
        case .quickStartStyle:
            addHeader("Quick Start 02", subtitle: "Build each TextTag from content plus style. Style owns colors, radius, padding, shadow, and size constraints.")
            addShowcasePanel(title: "Content + style", subtitle: "Each tag can have its own look without subclassing.", tagView: gradientTags())
            addCodeCard("""
            let content = TextTagStringContent(text: "Swift")
            content.textFont = .boldSystemFont(ofSize: 14)
            content.textColor = .white

            let style = TextTagStyle()
            style.backgroundColor = .systemBlue
            style.cornerRadius = 12
            style.extraSpace = CGSize(width: 14, height: 8)
            """)
        case .quickStartSelection:
            addHeader("Quick Start 03", subtitle: "Enable tap selection with selectedStyle and receive delegate callbacks.")
            let tagView = selectableTags()
            addShowcasePanel(title: "Selection states", subtitle: "Selected tags switch style automatically.", tagView: tagView)
            addCodeCard("""
            tag.selectedStyle = selectedStyle
            tagView.selectionLimit = 3
            tagView.delegate = self

            func textTagCollectionView(_ view: TextTagCollectionView,
                                       didTapTag tag: TextTag,
                                       at index: Int) {
                print(index, tag.selected)
            }
            """)
        case .quickStartLayout:
            addHeader("Quick Start 04", subtitle: "Choose alignment, spacing, scroll direction, and line limits for different product surfaces.")
            addShowcasePanel(title: "Layout controls", subtitle: "Vertical wrapping, fill alignment, and horizontal scrolling use the same API.", tagView: fillAlignmentTags())
            addShowcasePanel(title: "Horizontal filters", subtitle: "Set scrollDirection and numberOfLines for compact filter bars.", tagView: horizontalTags())
            addCodeCard("""
            tagView.alignment = .fillByExpandingWidth
            tagView.horizontalSpacing = 8
            tagView.verticalSpacing = 8
            tagView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

            tagView.scrollDirection = .horizontal
            tagView.numberOfLines = 2
            """)
        }
    }

    private func addHeader(_ title: String, subtitle: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 30, weight: .black)
        titleLabel.textColor = UIColor(red: 0.055, green: 0.075, blue: 0.115, alpha: 1)
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.82

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = UIColor(red: 0.36, green: 0.42, blue: 0.51, alpha: 1)
        subtitleLabel.numberOfLines = 0

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.setCustomSpacing(24, after: subtitleLabel)
    }

    private func addMetricRow() {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 10
        row.distribution = .fillEqually
        [
            ("2", "view types"),
            ("6", "alignments"),
            ("SPM", "ready")
        ].forEach { value, label in
            let card = UIView()
            card.backgroundColor = .white
            card.layer.cornerRadius = 14
            card.layer.borderWidth = 1
            card.layer.borderColor = UIColor.black.withAlphaComponent(0.06).cgColor

            let valueLabel = UILabel()
            valueLabel.text = value
            valueLabel.font = .systemFont(ofSize: 22, weight: .black)
            valueLabel.textColor = .systemBlue

            let caption = UILabel()
            caption.text = label
            caption.font = .systemFont(ofSize: 11, weight: .semibold)
            caption.textColor = .secondaryLabel

            let column = UIStackView(arrangedSubviews: [valueLabel, caption])
            column.axis = .vertical
            column.alignment = .center
            column.spacing = 2
            column.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview(column)
            NSLayoutConstraint.activate([
                column.centerXAnchor.constraint(equalTo: card.centerXAnchor),
                column.centerYAnchor.constraint(equalTo: card.centerYAnchor),
                card.heightAnchor.constraint(equalToConstant: 76),
            ])
            row.addArrangedSubview(card)
        }
        stackView.addArrangedSubview(row)
    }

    private func addShowcasePanel(title: String, subtitle: String, tagView: TextTagCollectionView) {
        let panel = panelView()

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .label

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        DemoUI.styleTagSurface(tagView)
        tagView.backgroundColor = UIColor(red: 0.965, green: 0.976, blue: 0.988, alpha: 1)
        tagView.translatesAutoresizingMaskIntoConstraints = false

        let inner = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, tagView])
        inner.axis = .vertical
        inner.spacing = 8
        inner.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(inner)

        NSLayoutConstraint.activate([
            inner.topAnchor.constraint(equalTo: panel.topAnchor, constant: 16),
            inner.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 16),
            inner.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -16),
            inner.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -16),
            tagView.heightAnchor.constraint(equalToConstant: tagView.scrollDirection == .horizontal ? 104 : 156),
        ])

        stackView.addArrangedSubview(panel)
    }

    private func addCustomViewPanel() {
        let panel = panelView()
        let titleLabel = UILabel()
        titleLabel.text = "Custom UIView tags"
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Use TagCollectionView directly when each tag needs avatars, icons, buttons, or custom controls."
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        let chipRow = UIStackView()
        chipRow.axis = .horizontal
        chipRow.spacing = 8
        chipRow.distribution = .fillEqually
        let colors: [UIColor] = [.systemIndigo, .systemTeal, .systemPink]
        ["Avatar", "Icon", "Badge"].enumerated().forEach { index, text in
            let chip = UILabel()
            chip.text = text
            chip.textAlignment = .center
            chip.font = .systemFont(ofSize: 13, weight: .bold)
            chip.textColor = .white
            chip.backgroundColor = colors[index]
            chip.layer.cornerRadius = 18
            chip.layer.masksToBounds = true
            chip.heightAnchor.constraint(equalToConstant: 46).isActive = true
            chipRow.addArrangedSubview(chip)
        }

        let inner = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, chipRow])
        inner.axis = .vertical
        inner.spacing = 10
        inner.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(inner)
        NSLayoutConstraint.activate([
            inner.topAnchor.constraint(equalTo: panel.topAnchor, constant: 16),
            inner.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 16),
            inner.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -16),
            inner.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -16),
        ])
        stackView.addArrangedSubview(panel)
    }

    private func addCodeCard(_ code: String) {
        let label = UILabel()
        label.text = code
        label.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 0.83, green: 0.9, blue: 1, alpha: 1)
        label.numberOfLines = 0

        let panel = UIView()
        panel.backgroundColor = UIColor(red: 0.055, green: 0.075, blue: 0.115, alpha: 1)
        panel.layer.cornerRadius = 16
        panel.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: panel.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -16),
        ])
        stackView.addArrangedSubview(panel)
    }

    private func panelView() -> UIView {
        let panel = UIView()
        panel.backgroundColor = .white
        panel.layer.cornerRadius = 18
        panel.layer.borderWidth = 1
        panel.layer.borderColor = UIColor.black.withAlphaComponent(0.06).cgColor
        panel.layer.shadowColor = UIColor.black.cgColor
        panel.layer.shadowOpacity = 0.08
        panel.layer.shadowRadius = 18
        panel.layer.shadowOffset = CGSize(width: 0, height: 8)
        return panel
    }

    private func basicTags() -> TextTagCollectionView {
        let tagView = baseTagView()
        tagView.add(tags: ["Swift", "UIKit", "Tags", "Layout", "Reload"].map { solidTag($0, color: .systemBlue) })
        tagView.reload()
        return tagView
    }

    private func gradientTags() -> TextTagCollectionView {
        let tagView = baseTagView()
        let items = [
            ("Gradient", UIColor.systemBlue, UIColor.systemPurple),
            ("Selected", UIColor.systemOrange, UIColor.systemPink),
            ("Corners", UIColor.systemTeal, UIColor.systemGreen),
            ("Shadow", UIColor.systemIndigo, UIColor.systemCyan),
            ("Padding", UIColor.systemPink, UIColor.systemRed),
            ("Max width", UIColor.systemGreen, UIColor.systemMint),
            ("Rich text", UIColor.systemPurple, UIColor.systemBlue),
            ("Border", UIColor.systemGray, UIColor.systemBrown)
        ]
        for (index, item) in items.enumerated() {
            let tag = gradientTag(item.0, start: item.1, end: item.2)
            if index == 1 || index == 6 {
                tag.selected = true
            }
            tagView.add(tag: tag)
        }
        tagView.reload()
        return tagView
    }

    private func selectableTags() -> TextTagCollectionView {
        let tagView = baseTagView()
        tagView.selectionLimit = 3
        for (index, text) in ["iOS", "Swift", "Objective-C", "UIKit", "AutoLayout", "SPM", "CocoaPods", "Accessible"].enumerated() {
            let tag = solidTag(text, color: index.isMultiple(of: 2) ? .systemBlue : .systemTeal)
            tag.selectedStyle = gradientStyle(start: .systemOrange, end: .systemPink)
            tag.selected = index == 1 || index == 4 || index == 7
            tagView.add(tag: tag)
        }
        tagView.reload()
        return tagView
    }

    private func fillAlignmentTags() -> TextTagCollectionView {
        let tagView = baseTagView()
        tagView.alignment = .fillByExpandingWidthExceptLastLine
        let colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemIndigo]
        tagView.add(tags: ["Left", "Center", "Right", "Fill space", "Fill width", "Except last", "Spacing", "Insets", "Auto height", "Cache"].enumerated().map { index, text in
            solidTag(text, color: colors[index % colors.count])
        })
        tagView.reload()
        return tagView
    }

    private func horizontalTags() -> TextTagCollectionView {
        let tagView = baseTagView()
        tagView.scrollDirection = .horizontal
        tagView.numberOfLines = 2
        tagView.alignment = .fillByExpandingWidth
        tagView.add(tags: ["Filter", "Pinned", "Long chip text", "One line", "Two lines", "Horizontal", "Scrollable", "Reusable", "Fast layout"].map {
            solidTag($0, color: .systemIndigo)
        })
        tagView.reload()
        return tagView
    }

    private func attributedPrimaryTags() -> TextTagCollectionView {
        let tagView = baseTagView()
        tagView.alignment = .fillByExpandingWidth
        [
            attributedChromeTag(mixedFontAndColorString()),
            attributedChromeTag(kernSpacingString()),
            attributedChromeTag(shadowTextString()),
            badgeTag("NEW"),
            badgeTag("HOT"),
            badgeTag("PRO"),
            badgeTag("FREE")
        ].forEach { tagView.add(tag: $0) }
        tagView.reload()
        return tagView
    }

    private func attributedDecorationTags() -> TextTagCollectionView {
        let tagView = baseTagView()
        tagView.alignment = .fillByExpandingWidth
        [
            attributedChromeTag(strikethroughAndUnderlineString()),
            attributedChromeTag(strokeTextString()),
            attributedChromeTag(superscriptString()),
            attributedChromeTag(imageAttachmentString()),
            attributedChromeTag(paragraphStyleString())
        ].forEach { tagView.add(tag: $0) }
        tagView.reload()
        return tagView
    }

    private func attributedSelectionTags() -> TextTagCollectionView {
        let tagView = baseTagView()
        tagView.selectionLimit = 2
        let selected = selectableAttributedTag()
        selected.selected = true
        tagView.add(tag: selected)
        tagView.add(tag: attributedChromeTag(NSAttributedString(string: "Tap plain attributed", attributes: [
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold),
            .foregroundColor: UIColor.systemBlue
        ])))
        tagView.add(tag: attributedChromeTag(NSAttributedString(string: "Selected content swaps", attributes: [
            .font: UIFont.italicSystemFont(ofSize: 15),
            .foregroundColor: UIColor.systemPurple
        ])))
        tagView.reload()
        return tagView
    }

    private func mixedFontAndColorString() -> NSAttributedString {
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

    private func strikethroughAndUnderlineString() -> NSAttributedString {
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

    private func kernSpacingString() -> NSAttributedString {
        NSAttributedString(string: "W I D E   S P A C I N G", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 13),
            .foregroundColor: UIColor.systemIndigo,
            .kern: 4.0,
        ])
    }

    private func shadowTextString() -> NSAttributedString {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.4)
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        shadow.shadowBlurRadius = 3
        return NSAttributedString(string: "Text Shadow", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.systemOrange,
            .shadow: shadow,
        ])
    }

    private func strokeTextString() -> NSAttributedString {
        NSAttributedString(string: "Stroke Text", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 22),
            .foregroundColor: UIColor.systemPurple,
            .strokeColor: UIColor.systemPurple,
            .strokeWidth: 3.0,
        ])
    }

    private func superscriptString() -> NSAttributedString {
        let result = NSMutableAttributedString()
        let normalAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.italicSystemFont(ofSize: 18),
            .foregroundColor: UIColor.label,
        ]
        result.append(NSAttributedString(string: "E=mc", attributes: normalAttrs))
        result.append(NSAttributedString(string: "2", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor: UIColor.systemRed,
            .baselineOffset: 8.0,
        ]))
        result.append(NSAttributedString(string: "  H", attributes: normalAttrs))
        result.append(NSAttributedString(string: "2", attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.systemBlue,
            .baselineOffset: -4.0,
        ]))
        result.append(NSAttributedString(string: "O", attributes: normalAttrs))
        return result
    }

    private func imageAttachmentString() -> NSAttributedString {
        let result = NSMutableAttributedString()
        let attachment = NSTextAttachment()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        attachment.image = UIImage(systemName: "heart.fill", withConfiguration: config)?
            .withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        result.append(NSAttributedString(attachment: attachment))
        result.append(NSAttributedString(string: " Favorite ", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.systemPink,
        ]))
        result.append(NSAttributedString(attachment: attachment))
        return result
    }

    private func paragraphStyleString() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        let result = NSMutableAttributedString(string: "Paragraph Style\nwith line spacing", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor.secondaryLabel,
            .paragraphStyle: paragraphStyle,
        ])
        result.addAttributes([
            .font: UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor: UIColor.label,
        ], range: NSRange(location: 0, length: 15))
        return result
    }

    private func attributedChromeTag(_ attributedString: NSAttributedString) -> TextTag {
        let tag = TextTag(content: TextTagAttributedStringContent(attributedText: attributedString), style: attributedChromeStyle())
        let selectedStyle = attributedChromeStyle()
        selectedStyle.backgroundColor = UIColor(red: 0.90, green: 0.93, blue: 1.00, alpha: 1)
        selectedStyle.borderColor = .systemBlue
        selectedStyle.borderWidth = 1.5
        tag.selectedStyle = selectedStyle
        return tag
    }

    private func badgeTag(_ text: String) -> TextTag {
        let attributedString = NSAttributedString(string: text, attributes: [
            .font: UIFont.boldSystemFont(ofSize: 13),
            .foregroundColor: UIColor.white,
            .kern: 1.5,
        ])
        let color: UIColor
        switch text {
        case "HOT": color = .systemOrange
        case "PRO": color = .systemBlue
        case "FREE": color = .systemGreen
        default: color = .systemRed
        }
        let style = solidStyle(color)
        style.cornerRadius = 12
        style.extraSpace = CGSize(width: 12, height: 6)
        return TextTag(content: TextTagAttributedStringContent(attributedText: attributedString), style: style)
    }

    private func selectableAttributedTag() -> TextTag {
        let normalContent = TextTagAttributedStringContent(attributedText: NSAttributedString(string: "☆ Tap to Select", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.systemGray,
        ]))
        let selectedContent = TextTagAttributedStringContent(attributedText: NSAttributedString(string: "★ Selected!", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.systemYellow,
        ]))
        let style = attributedChromeStyle()
        let selectedStyle = attributedChromeStyle()
        selectedStyle.backgroundColor = UIColor(red: 0.20, green: 0.20, blue: 0.25, alpha: 1)
        selectedStyle.borderColor = .systemYellow
        selectedStyle.borderWidth = 2

        let tag = TextTag(content: normalContent, style: style)
        tag.selectedContent = selectedContent
        tag.selectedStyle = selectedStyle
        return tag
    }

    private func attributedChromeStyle() -> TextTagStyle {
        let style = TextTagStyle()
        style.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)
        style.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.87, alpha: 1)
        style.borderWidth = 1
        style.cornerRadius = 8
        style.extraSpace = CGSize(width: 10, height: 8)
        style.shadowColor = UIColor.black.withAlphaComponent(0.08)
        style.shadowOffset = CGSize(width: 0, height: 1)
        style.shadowOpacity = 1
        style.shadowRadius = 2
        return style
    }

    private func denseCellTags() -> TextTagCollectionView {
        let tagView = baseTagView()
        tagView.alignment = .fillByExpandingWidth
        tagView.horizontalSpacing = 6
        tagView.verticalSpacing = 6
        tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let words = [
            "cache", "measure", "height", "reuse", "table", "cell", "layout", "pure",
            "swift", "objc", "size", "stable", "fast", "dense", "batch", "reload"
        ]
        let colors: [UIColor] = [.systemBlue, .systemGreen, .systemIndigo, .systemOrange]
        for (index, word) in words.enumerated() {
            tagView.add(tag: solidTag(word, color: colors[index % colors.count]))
        }
        tagView.reload()
        return tagView
    }

    private func baseTagView() -> TextTagCollectionView {
        let tagView = TextTagCollectionView()
        tagView.alignment = .left
        tagView.horizontalSpacing = 8
        tagView.verticalSpacing = 8
        tagView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        tagView.showsHorizontalScrollIndicator = false
        tagView.showsVerticalScrollIndicator = false
        return tagView
    }

    private func solidTag(_ text: String, color: UIColor) -> TextTag {
        let content = TextTagStringContent(text: text)
        content.textFont = .systemFont(ofSize: 14, weight: .bold)
        content.textColor = .white
        let tag = TextTag(content: content, style: solidStyle(color))
        tag.selectedStyle = gradientStyle(start: .systemOrange, end: .systemPink)
        return tag
    }

    private func gradientTag(_ text: String, start: UIColor, end: UIColor) -> TextTag {
        let content = TextTagStringContent(text: text)
        content.textFont = .systemFont(ofSize: 14, weight: .bold)
        content.textColor = .white
        let tag = TextTag(content: content, style: gradientStyle(start: start, end: end))
        tag.selectedStyle = gradientStyle(start: .systemOrange, end: .systemPink)
        return tag
    }

    private func solidStyle(_ color: UIColor) -> TextTagStyle {
        let style = TextTagStyle()
        style.backgroundColor = color
        style.cornerRadius = 13
        style.extraSpace = CGSize(width: 14, height: 8)
        style.borderWidth = 0
        style.shadowOpacity = 0.08
        style.shadowRadius = 4
        style.shadowOffset = CGSize(width: 0, height: 2)
        return style
    }

    private func gradientStyle(start: UIColor, end: UIColor) -> TextTagStyle {
        let style = solidStyle(start)
        style.enableGradientBackground = true
        style.gradientBackgroundStartColor = start
        style.gradientBackgroundEndColor = end
        style.gradientBackgroundStartPoint = CGPoint(x: 0, y: 0.5)
        style.gradientBackgroundEndPoint = CGPoint(x: 1, y: 0.5)
        return style
    }
}

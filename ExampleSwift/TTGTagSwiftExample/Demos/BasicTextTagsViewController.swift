//
//  BasicTextTagsViewController.swift
//  TTGTagSwiftExample
//
//  Demo: TextTagCollectionView 基础用法（两列、样式、选中、delegate）

import UIKit
import TTGTags

class BasicTextTagsViewController: UIViewController {

    private let tagCollectionView1 = TextTagCollectionView()
    private let tagCollectionView2 = TextTagCollectionView()
    private let logLabel = UILabel()

    private let sampleWords = TagSampleData.autoLayoutLongParagraphWords

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        configureAppearance()
        loadTagsForBothCollections()
        applyInitialSelection()
        tagCollectionView1.reload()
        tagCollectionView2.reload()
    }

    // MARK: - Setup

    private func setupSubviews() {
        logLabel.font = .systemFont(ofSize: 14)
        logLabel.textColor = .darkGray
        logLabel.adjustsFontSizeToFitWidth = true
        logLabel.text = "Tap a tag..."
        logLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logLabel)

        for tagView in [tagCollectionView1, tagCollectionView2] {
            tagView.translatesAutoresizingMaskIntoConstraints = false
            tagView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1)
            view.addSubview(tagView)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            logLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tagCollectionView1.topAnchor.constraint(equalTo: logLabel.bottomAnchor, constant: 12),
            tagCollectionView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagCollectionView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tagCollectionView1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),

            tagCollectionView2.topAnchor.constraint(equalTo: tagCollectionView1.bottomAnchor, constant: 16),
            tagCollectionView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagCollectionView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tagCollectionView2.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

    private func configureAppearance() {
        tagCollectionView1.scrollView.contentInsetAdjustmentBehavior = .never
        tagCollectionView2.scrollView.contentInsetAdjustmentBehavior = .never

        tagCollectionView1.delegate = self
        tagCollectionView2.delegate = self

        tagCollectionView1.showsVerticalScrollIndicator = false
        tagCollectionView2.showsVerticalScrollIndicator = false

        tagCollectionView1.horizontalSpacing = 6
        tagCollectionView1.verticalSpacing = 8
        tagCollectionView2.horizontalSpacing = 8
        tagCollectionView2.verticalSpacing = 8

        tagCollectionView1.alignment = .fillByExpandingWidth
        tagCollectionView2.alignment = .fillByExpandingWidthExceptLastLine
    }

    // MARK: - Content

    private func loadTagsForBothCollections() {
        tagCollectionView1.add(tags: buildStyleOneTags())
        tagCollectionView2.add(tags: buildStyleTwoTags())
    }

    private func buildStyleOneTags() -> [TextTag] {
        let contentTemplate = TextTagStringContent()
        contentTemplate.textFont = .boldSystemFont(ofSize: 18)
        contentTemplate.textColor = UIColor(red: 0.23, green: 0.23, blue: 0.23, alpha: 1)

        let selectedContentTemplate = TextTagStringContent()
        selectedContentTemplate.textFont = contentTemplate.textFont
        selectedContentTemplate.textColor = .white

        let style = TextTagStyle()
        style.backgroundColor = UIColor(red: 0.31, green: 0.70, blue: 0.80, alpha: 1)
        style.borderColor = UIColor(red: 0.18, green: 0.19, blue: 0.22, alpha: 1)
        style.borderWidth = 1
        style.shadowColor = .gray
        style.shadowOffset = CGSize(width: 0, height: 1)
        style.shadowOpacity = 0.5
        style.shadowRadius = 2
        style.cornerRadius = 2
        style.extraSpace = CGSize(width: 4, height: 4)

        let selectedStyle = TextTagStyle()
        selectedStyle.backgroundColor = UIColor(red: 0.38, green: 0.36, blue: 0.63, alpha: 1)
        selectedStyle.borderColor = UIColor(red: 0.18, green: 0.19, blue: 0.22, alpha: 1)
        selectedStyle.borderWidth = 1
        selectedStyle.shadowColor = .green
        selectedStyle.shadowOffset = CGSize(width: 0, height: 2)
        selectedStyle.shadowOpacity = 0.5
        selectedStyle.shadowRadius = 1
        selectedStyle.cornerRadius = 4
        selectedStyle.extraSpace = CGSize(width: 4, height: 4)

        return sampleWords.map { word in
            let content = contentTemplate.copy() as! TextTagStringContent
            content.text = word
            let selectedContent = selectedContentTemplate.copy() as! TextTagStringContent
            selectedContent.text = word

            let tag = TextTag()
            tag.content = content
            tag.selectedContent = selectedContent
            tag.style = style
            tag.selectedStyle = selectedStyle
            return tag.copy() as! TextTag
        }
    }

    private func buildStyleTwoTags() -> [TextTag] {
        let contentTemplate = TextTagStringContent()
        contentTemplate.textFont = .systemFont(ofSize: 18)
        contentTemplate.textColor = .white

        let selectedContentTemplate = TextTagStringContent()
        selectedContentTemplate.textFont = .systemFont(ofSize: 20)
        selectedContentTemplate.textColor = .green

        let style = TextTagStyle()
        style.extraSpace = CGSize(width: 12, height: 12)
        style.backgroundColor = UIColor(red: 0.10, green: 0.53, blue: 0.85, alpha: 1)
        style.cornerRadius = 12
        style.cornerBottomRight = true
        style.cornerBottomLeft = false
        style.cornerTopRight = false
        style.cornerTopLeft = true
        style.borderWidth = 1
        style.borderColor = .red
        style.shadowColor = .black
        style.shadowOffset = CGSize(width: 0, height: 4)
        style.shadowOpacity = 0.3
        style.shadowRadius = 4

        let selectedStyle = TextTagStyle()
        selectedStyle.extraSpace = CGSize(width: 12, height: 12)
        selectedStyle.backgroundColor = UIColor(red: 0.21, green: 0.29, blue: 0.36, alpha: 1)
        selectedStyle.cornerRadius = 8
        selectedStyle.cornerBottomRight = true
        selectedStyle.cornerBottomLeft = false
        selectedStyle.cornerTopRight = true
        selectedStyle.cornerTopLeft = false
        selectedStyle.borderWidth = 4
        selectedStyle.borderColor = .orange
        selectedStyle.shadowColor = .red
        selectedStyle.shadowOffset = CGSize(width: 0, height: 1)
        selectedStyle.shadowOpacity = 0.3
        selectedStyle.shadowRadius = 2

        return sampleWords.map { word in
            let content = contentTemplate.copy() as! TextTagStringContent
            content.text = word
            let selectedContent = selectedContentTemplate.copy() as! TextTagStringContent
            selectedContent.text = word + "!"

            let tag = TextTag()
            tag.content = content
            tag.selectedContent = selectedContent
            tag.style = style
            tag.selectedStyle = selectedStyle
            return tag.copy() as! TextTag
        }
    }

    private func applyInitialSelection() {
        for index in [0, 4, 6, 17] {
            tagCollectionView1.updateTag(at: index, selected: true)
            tagCollectionView2.updateTag(at: index, selected: true)
        }
    }
}

// MARK: - TextTagCollectionViewDelegate

extension BasicTextTagsViewController: TextTagCollectionViewDelegate {

    func textTagCollectionView(_ textTagCollectionView: TextTagCollectionView!,
                               didTapTag tag: TextTag!,
                               at index: Int) {
        let text = tag.content.getContentAttributedString().string
        logLabel.text = "Tap tag: \(text), at: \(index), selected: \(tag.selected)"
    }

    func textTagCollectionView(_ textTagCollectionView: TextTagCollectionView!,
                               updateContentSize contentSize: CGSize) {
        print("TextTagCollectionView contentSize: \(contentSize)")
    }
}

//
//  AutoLayoutFormViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

class AutoLayoutFormViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let interestTagView = TextTagCollectionView()
    private let languageTagView = TextTagCollectionView()
    private let summaryLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)
        setupScrollView()
        setupContent()
        populateTags()
        updateSummary()
    }

    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
        ])
    }

    private func setupContent() {
        contentStack.addArrangedSubview(DemoUI.titleLabel("Auto Layout form"))
        contentStack.addArrangedSubview(DemoUI.descriptionLabel("Embed tag collection views inside a form. Intrinsic height keeps the form layout stable as selected items change."))

        addSection(title: "Interests", detail: "Single-line labels expand into multiple rows without fixed heights.", tagView: interestTagView)
        addSection(title: "Languages", detail: "Different selected styles can communicate grouping or state.", tagView: languageTagView)

        summaryLabel.numberOfLines = 0
        DemoUI.styleLogLabel(summaryLabel)
        contentStack.addArrangedSubview(summaryLabel)
    }

    private func addSection(title: String, detail: String, tagView: TextTagCollectionView) {
        contentStack.addArrangedSubview(DemoUI.sectionLabel(title))
        contentStack.addArrangedSubview(DemoUI.descriptionLabel(detail))
        configure(tagView)
        contentStack.addArrangedSubview(tagView)
    }

    private func configure(_ tagView: TextTagCollectionView) {
        DemoUI.styleTagSurface(tagView)
        tagView.alignment = .fillByExpandingWidth
        tagView.horizontalSpacing = 8
        tagView.verticalSpacing = 8
        tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tagView.delegate = self
        tagView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func populateTags() {
        let interests = ["Design", "iOS", "UIKit", "SwiftUI", "Auto Layout", "Animation", "Accessibility", "Open Source", "Testing", "Architecture"]
        let languages = ["Objective-C", "Swift", "Kotlin", "TypeScript", "Dart", "Rust", "Go", "Python"]

        interestTagView.add(tags: interests.map { selectableTag(text: $0, selectedColor: .systemBlue) })
        languageTagView.add(tags: languages.map { selectableTag(text: $0, selectedColor: .systemGreen) })

        interestTagView.updateTag(at: 1, selected: true)
        interestTagView.updateTag(at: 3, selected: true)
        languageTagView.updateTag(at: 0, selected: true)
        languageTagView.updateTag(at: 1, selected: true)

        interestTagView.reload()
        languageTagView.reload()
    }

    private func selectableTag(text: String, selectedColor: UIColor) -> TextTag {
        let content = TextTagStringContent()
        content.text = text
        content.textFont = .systemFont(ofSize: 15, weight: .medium)
        content.textColor = .label

        let selectedContent = content.copy() as! TextTagStringContent
        selectedContent.textColor = .white

        let style = TextTagStyle()
        style.backgroundColor = .systemGray5
        style.cornerRadius = 14
        style.extraSpace = CGSize(width: 12, height: 6)
        style.borderWidth = 0

        let selectedStyle = style.copy() as! TextTagStyle
        selectedStyle.backgroundColor = selectedColor

        let tag = TextTag()
        tag.content = content
        tag.selectedContent = selectedContent
        tag.style = style
        tag.selectedStyle = selectedStyle
        return tag
    }

    private func updateSummary() {
        let selectedInterests = interestTagView.allSelectedTags().compactMap { ($0.content as? TextTagStringContent)?.text }
        let selectedLanguages = languageTagView.allSelectedTags().compactMap { ($0.content as? TextTagStringContent)?.text }
        summaryLabel.text = "Selected interests: \(selectedInterests.joined(separator: ", "))\nSelected languages: \(selectedLanguages.joined(separator: ", "))"
    }
}

extension AutoLayoutFormViewController: TextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TextTagCollectionView!,
                               didTapTag tag: TextTag!,
                               at index: Int) {
        updateSummary()
    }
}

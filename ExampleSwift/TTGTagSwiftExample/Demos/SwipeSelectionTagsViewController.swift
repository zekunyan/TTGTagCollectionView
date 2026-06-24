//
//  SwipeSelectionTagsViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

final class SwipeSelectionTagsViewController: UIViewController, TextTagCollectionViewDelegate {

    private let titleLabel = DemoUI.titleLabel("Swipe select")
    private let descriptionLabel = DemoUI.descriptionLabel("Drag across tags to select multiple items. Tap still toggles one tag at a time.")
    private let tagView = TextTagCollectionView()
    private let logLabel = UILabel()
    private let resetButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)
        setupSubviews()
        populateTags()
        updateLog(prefix: "No tags selected.")
    }

    private func setupSubviews() {
        DemoUI.styleTagSurface(tagView)
        tagView.delegate = self
        tagView.enableSwipeSelection = true
        tagView.selectionLimit = 6
        tagView.alignment = .fillByExpandingWidth
        tagView.horizontalSpacing = 8
        tagView.verticalSpacing = 8
        tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(resetSelection), for: .touchUpInside)
        DemoUI.stylePrimaryButton(resetButton)

        DemoUI.styleLogLabel(logLabel)

        let actionRow = UIStackView(arrangedSubviews: [DemoUI.sectionLabel("Selection limit: 6"), resetButton])
        actionRow.axis = .horizontal
        actionRow.alignment = .center
        actionRow.distribution = .equalSpacing

        [titleLabel, descriptionLabel, tagView, actionRow, logLabel].forEach {
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

            tagView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 18),
            tagView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tagView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            tagView.heightAnchor.constraint(equalToConstant: 230),

            actionRow.topAnchor.constraint(equalTo: tagView.bottomAnchor, constant: 14),
            actionRow.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            actionRow.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            logLabel.topAnchor.constraint(equalTo: actionRow.bottomAnchor, constant: 14),
            logLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            logLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }

    private func populateTags() {
        let words = [
            "Travel", "Food", "Music", "Books", "Fitness", "Design", "Swift",
            "UIKit", "Photos", "Family", "Work", "Ideas", "Weekend", "Learning",
        ]
        let tags = words.map { word -> TextTag in
            let tag = DemoUI.tag(text: word)
            tag.selectedStyle = DemoUI.selectedTagStyle(color: .systemGreen)
            return tag
        }

        tagView.add(tags: tags)
        tagView.reload()
    }

    @objc private func resetSelection() {
        tagView.allTags().forEach { $0.selected = false }
        tagView.reload()
        updateLog(prefix: "Selection reset.")
    }

    private func updateLog(prefix: String) {
        let selectedTitles = tagView.allSelectedTags().map { $0.content.getContentAttributedString().string }
        if selectedTitles.isEmpty {
            logLabel.text = prefix
        } else {
            logLabel.text = "\(prefix) Selected: \(selectedTitles.joined(separator: ", "))"
        }
    }

    func textTagCollectionView(
        _ collectionView: TextTagCollectionView,
        didTapTag tag: TextTag,
        at index: Int
    ) {
        updateLog(prefix: "Tapped index \(index).")
    }

    func textTagCollectionView(
        _ collectionView: TextTagCollectionView,
        didSwipeSelectTag tag: TextTag,
        at index: Int
    ) {
        updateLog(prefix: "Swipe selected index \(index).")
    }
}

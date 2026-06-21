//
//  ProgrammaticTagsViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

class ProgrammaticTagsViewController: UIViewController {

    private let titleLabel = DemoUI.titleLabel("Programmatic APIs")
    private let descriptionLabel = DemoUI.descriptionLabel("Create tags in code, allow selected tags to wrap, update tags by tagId, and scroll directly to a known tag.")
    private let tagView = TextTagCollectionView()
    private let logLabel = UILabel()
    private let selectByIdButton = UIButton(type: .system)
    private let scrollToLastButton = UIButton(type: .system)
    private var highlightedTagId: Int?
    private var lastTagId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)
        setupSubviews()
        populateTagsFromSampleWords()
    }

    private func setupSubviews() {
        DemoUI.styleTagSurface(tagView)
        tagView.alignment = .fillByExpandingWidth
        tagView.horizontalSpacing = 8
        tagView.verticalSpacing = 8
        tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tagView.contentVerticalAlignment = .center

        DemoUI.styleLogLabel(logLabel)
        logLabel.text = "Use the buttons to update a tag by id or scroll to the last tag."

        selectByIdButton.setTitle("Select by ID", for: .normal)
        scrollToLastButton.setTitle("Scroll to Last", for: .normal)
        DemoUI.stylePrimaryButton(selectByIdButton)
        DemoUI.stylePrimaryButton(scrollToLastButton)
        selectByIdButton.addTarget(self, action: #selector(selectHighlightedTag), for: .touchUpInside)
        scrollToLastButton.addTarget(self, action: #selector(scrollToLastTag), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [selectByIdButton, scrollToLastButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually

        tagView.onTapAllArea = { location in
            print("onTapAllArea: \(location)")
        }
        tagView.onTapBlankArea = { location in
            print("onTapBlankArea: \(location)")
        }

        [titleLabel, descriptionLabel, tagView, buttonStack, logLabel].forEach {
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
            tagView.heightAnchor.constraint(equalToConstant: 170),

            buttonStack.topAnchor.constraint(equalTo: tagView.bottomAnchor, constant: 12),
            buttonStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            logLabel.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 16),
            logLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            logLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }

    private func populateTagsFromSampleWords() {
        var tags = TagSampleData.shortWordsRepeated(count: 2).map { DemoUI.tag(text: $0) }
        let multilineTag = DemoUI.tag(text: "A long selected tag can wrap onto multiple lines when numberOfLines is zero and maxWidth is set")
        multilineTag.style.numberOfLines = 0
        multilineTag.style.maxWidth = 220
        multilineTag.selectedStyle = multilineTag.style.copy() as! TextTagStyle
        multilineTag.selectedStyle.backgroundColor = .systemIndigo
        tags.insert(multilineTag, at: 3)
        highlightedTagId = multilineTag.tagId
        lastTagId = tags.last?.tagId

        tagView.add(tags: tags)
        if let highlightedTagId {
            tagView.updateTag(byId: highlightedTagId, selected: true)
        }
        tagView.reload()
    }

    @objc private func selectHighlightedTag() {
        guard let highlightedTagId else { return }
        tagView.updateTag(byId: highlightedTagId, selected: true)
        logLabel.text = "Selected tag id \(highlightedTagId)."
    }

    @objc private func scrollToLastTag() {
        guard let lastTagId else { return }
        tagView.scrollToTag(byId: lastTagId, position: .end, animated: true)
        logLabel.text = "Scrolled to tag id \(lastTagId)."
    }
}

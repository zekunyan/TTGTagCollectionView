//
//  SelfSizingDemoViewController.swift
//  TTGTagSwiftExample
//
//  Demo 3: Self-sizing via intrinsicContentSize.
//  Demonstrates that the view's height automatically adjusts as content
//  changes — no manual height calculation required.

import UIKit
import TTGTags

class SelfSizingDemoViewController: UIViewController {

    private let tagView = TextTagCollectionView()
    private var allWords: [String] = []
    private var currentCount: Int = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        allWords = TagSampleData.shortSampleWords
        setupUI()
        updateTags()
    }

    // MARK: - Setup

    private func setupUI() {
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = "intrinsicContentSize Demo"
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textAlignment = .center

        // Description label
        let descLabel = UILabel()
        descLabel.text = "The gray view's height adjusts automatically as tags are added or removed. No manual height calculation."
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.textColor = .secondaryLabel
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center

        // Tag view
        tagView.backgroundColor = .systemGray6
        tagView.layer.cornerRadius = 8
        tagView.horizontalSpacing = 6
        tagView.verticalSpacing = 6
        tagView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        // Control buttons
        let addBtn = UIButton(type: .system)
        addBtn.setTitle("Add Tag (+)", for: .normal)
        addBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        addBtn.addTarget(self, action: #selector(addTag), for: .touchUpInside)

        let removeBtn = UIButton(type: .system)
        removeBtn.setTitle("Remove Tag (−)", for: .normal)
        removeBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        removeBtn.addTarget(self, action: #selector(removeTag), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [addBtn, removeBtn])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 16

        // Arrange everything in a vertical stack
        let mainStack = UIStackView(arrangedSubviews: [titleLabel, descLabel, tagView, buttonStack])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.setCustomSpacing(8, after: titleLabel)
        mainStack.setCustomSpacing(24, after: descLabel)
        mainStack.setCustomSpacing(24, after: tagView)
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    // MARK: - Actions

    @objc private func addTag() {
        guard currentCount < allWords.count else { return }
        currentCount += 1
        updateTags()
    }

    @objc private func removeTag() {
        guard currentCount > 1 else { return }
        currentCount -= 1
        updateTags()
    }

    private func updateTags() {
        tagView.removeAllTags()

        let words = Array(allWords.prefix(currentCount))
        for word in words {
            let content = TextTagStringContent(text: word)
            content.textFont = .systemFont(ofSize: 14, weight: .medium)
            content.textColor = .white

            let style = TextTagStyle()
            style.backgroundColor = .systemIndigo
            style.cornerRadius = 14
            style.extraSpace = CGSize(width: 12, height: 6)

            tagView.add(tag: TextTag(content: content, style: style))
        }

        // reload() triggers invalidateIntrinsicContentSize internally,
        // so the StackView/Auto Layout picks up the new height automatically.
        tagView.reload()
    }
}

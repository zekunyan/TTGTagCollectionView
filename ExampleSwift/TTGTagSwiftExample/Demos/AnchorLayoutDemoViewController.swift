//
//  AnchorLayoutDemoViewController.swift
//  TTGTagSwiftExample
//
//  Demo 1: Pure anchor-based Auto Layout.
//  The tag view is pinned with NSLayoutConstraint anchors — no frame math,
//  no manual height. The height is derived from intrinsicContentSize.

import UIKit
import TTGTags

class AnchorLayoutDemoViewController: UIViewController {

    private let tagView = TextTagCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTagView()
        populateTags()
    }

    private func setupTagView() {
        tagView.translatesAutoresizingMaskIntoConstraints = false
        tagView.backgroundColor = .systemGray6
        tagView.horizontalSpacing = 8
        tagView.verticalSpacing = 8
        tagView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.addSubview(tagView)

        // Pin to safe area with anchors — height is auto-calculated via intrinsicContentSize
        NSLayoutConstraint.activate([
            tagView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tagView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tagView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }

    private func populateTags() {
        let words = TagSampleData.shortSampleWords
        let colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemPurple, .systemPink]

        for (index, word) in words.enumerated() {
            let content = TextTagStringContent(text: word)
            content.textFont = .systemFont(ofSize: 14, weight: .medium)
            content.textColor = .white

            let style = TextTagStyle()
            style.backgroundColor = colors[index % colors.count]
            style.cornerRadius = 14
            style.extraSpace = CGSize(width: 12, height: 6)

            let tag = TextTag(content: content, style: style)
            tagView.add(tag: tag)
        }

        tagView.reload()
    }
}

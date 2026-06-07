//
//  AnchorLayoutDemoViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

class AnchorLayoutDemoViewController: UIViewController {

    private let titleLabel = DemoUI.titleLabel("Anchor constraint layout")
    private let descriptionLabel = DemoUI.descriptionLabel("The tag view is pinned with NSLayoutConstraint anchors. Its height comes from intrinsicContentSize, so no frame math or storyboard sizing is needed.")
    private let tagView = TextTagCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)
        setupViews()
        populateTags()
    }

    private func setupViews() {
        DemoUI.styleTagSurface(tagView)
        tagView.horizontalSpacing = 8
        tagView.verticalSpacing = 8
        tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tagView.alignment = .fillByExpandingWidth

        [titleLabel, descriptionLabel, tagView].forEach {
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
        ])
    }

    private func populateTags() {
        TagSampleData.shortSampleWords.enumerated().forEach { index, word in
            let tag = DemoUI.tag(text: word)
            let colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemPurple, .systemPink]
            tag.style.backgroundColor = colors[index % colors.count]
            tagView.add(tag: tag)
        }
        tagView.reload()
    }
}

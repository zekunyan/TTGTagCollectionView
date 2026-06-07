//
//  ProgrammaticTagsViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

class ProgrammaticTagsViewController: UIViewController {

    private let titleLabel = DemoUI.titleLabel("Programmatic layout & auto height")
    private let descriptionLabel = DemoUI.descriptionLabel("The tag view is created entirely in code. No height constraint is required because TTGTagCollectionView reports intrinsic height from its content.")
    private let tagView = TextTagCollectionView()
    private let logLabel = UILabel()

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

        DemoUI.styleLogLabel(logLabel)
        logLabel.text = "Tap blank area or tags to inspect callbacks in console."

        tagView.onTapAllArea = { location in
            print("onTapAllArea: \(location)")
        }
        tagView.onTapBlankArea = { location in
            print("onTapBlankArea: \(location)")
        }

        [titleLabel, descriptionLabel, tagView, logLabel].forEach {
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

            logLabel.topAnchor.constraint(equalTo: tagView.bottomAnchor, constant: 16),
            logLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            logLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }

    private func populateTagsFromSampleWords() {
        let words = TagSampleData.shortSampleWords
        tagView.add(tags: words.map { DemoUI.tag(text: $0) })

        for _ in 0..<5 {
            tagView.updateTag(at: Int(arc4random_uniform(UInt32(words.count))), selected: true)
        }
        tagView.reload()
    }
}

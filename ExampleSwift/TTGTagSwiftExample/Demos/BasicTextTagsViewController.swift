//
//  BasicTextTagsViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

class BasicTextTagsViewController: UIViewController {

    private let titleLabel = DemoUI.titleLabel("Basic text tags")
    private let descriptionLabel = DemoUI.descriptionLabel("Two tag collections demonstrate fill alignment, selected states, and delegate callbacks with the same default style as the Objective-C demo.")
    private let sectionLabel1 = DemoUI.sectionLabel("Fill by expanding width")
    private let sectionLabel2 = DemoUI.sectionLabel("Fill except last line")
    private let tagCollectionView1 = TextTagCollectionView()
    private let tagCollectionView2 = TextTagCollectionView()
    private let logLabel = UILabel()

    private let sampleWords = TagSampleData.autoLayoutLongParagraphWords

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)
        setupSubviews()
        configureAppearance()
        loadTagsForBothCollections()
        applyInitialSelection()
        tagCollectionView1.reload()
        tagCollectionView2.reload()
    }

    private func setupSubviews() {
        DemoUI.styleLogLabel(logLabel)
        logLabel.text = "Tap a tag..."

        [titleLabel, descriptionLabel, sectionLabel1, tagCollectionView1, sectionLabel2, tagCollectionView2, logLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        for tagView in [tagCollectionView1, tagCollectionView2] {
            DemoUI.styleTagSurface(tagView)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            sectionLabel1.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 18),
            sectionLabel1.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sectionLabel1.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            tagCollectionView1.topAnchor.constraint(equalTo: sectionLabel1.bottomAnchor, constant: 8),
            tagCollectionView1.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tagCollectionView1.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            tagCollectionView1.heightAnchor.constraint(equalToConstant: 210),

            sectionLabel2.topAnchor.constraint(equalTo: tagCollectionView1.bottomAnchor, constant: 16),
            sectionLabel2.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sectionLabel2.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            tagCollectionView2.topAnchor.constraint(equalTo: sectionLabel2.bottomAnchor, constant: 8),
            tagCollectionView2.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tagCollectionView2.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            tagCollectionView2.heightAnchor.constraint(equalToConstant: 170),

            logLabel.topAnchor.constraint(equalTo: tagCollectionView2.bottomAnchor, constant: 16),
            logLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            logLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            logLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

    private func configureAppearance() {
        for tagView in [tagCollectionView1, tagCollectionView2] {
            tagView.scrollView.contentInsetAdjustmentBehavior = .never
            tagView.delegate = self
            tagView.showsVerticalScrollIndicator = false
            tagView.horizontalSpacing = 8
            tagView.verticalSpacing = 8
            tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }

        tagCollectionView1.alignment = .fillByExpandingWidth
        tagCollectionView2.alignment = .fillByExpandingWidthExceptLastLine
    }

    private func loadTagsForBothCollections() {
        tagCollectionView1.add(tags: sampleWords.map { DemoUI.tag(text: $0) })
        tagCollectionView2.add(tags: sampleWords.map { word in
            let tag = DemoUI.tag(text: word)
            tag.style.backgroundColor = .systemIndigo
            tag.selectedStyle.backgroundColor = .systemBlue
            return tag
        })
    }

    private func applyInitialSelection() {
        for index in [0, 4, 6, 17] {
            tagCollectionView1.updateTag(at: index, selected: true)
            tagCollectionView2.updateTag(at: index, selected: true)
        }
    }
}

extension BasicTextTagsViewController: TextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TextTagCollectionView!,
                               didTapTag tag: TextTag!,
                               at index: Int) {
        let text = tag.content.getContentAttributedString().string
        logLabel.text = "Tap tag: \(text), at: \(index), selected: \(tag.selected)"
    }
}

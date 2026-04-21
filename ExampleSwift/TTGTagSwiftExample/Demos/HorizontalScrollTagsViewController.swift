//
//  HorizontalScrollTagsViewController.swift
//  TTGTagSwiftExample
//
//  Demo: 水平滚动和 numberOfLines 行数限制

import UIKit
import TTGTags

class HorizontalScrollTagsViewController: UIViewController {

    private let oneLineTagView = TextTagCollectionView()
    private let twoLineTagView = TextTagCollectionView()
    private let threeLineTagView = TextTagCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        configureScrollAndLineLimits()
        loadSameTagsIntoAllRows()
    }

    // MARK: - Setup

    private func setupSubviews() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])

        let rows: [(String, TextTagCollectionView)] = [
            ("One line", oneLineTagView),
            ("Two lines", twoLineTagView),
            ("Three lines", threeLineTagView),
        ]

        for (labelText, tagView) in rows {
            let label = UILabel()
            label.text = labelText
            label.font = .systemFont(ofSize: 18, weight: .medium)
            label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            stackView.addArrangedSubview(label)

            tagView.backgroundColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1)
            tagView.translatesAutoresizingMaskIntoConstraints = false
            tagView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            stackView.addArrangedSubview(tagView)
        }
    }

    private func configureScrollAndLineLimits() {
        for tagView in [oneLineTagView, twoLineTagView, threeLineTagView] {
            tagView.scrollDirection = .horizontal
            tagView.alignment = .fillByExpandingWidth
        }
        oneLineTagView.numberOfLines = 1
        twoLineTagView.numberOfLines = 2
        threeLineTagView.numberOfLines = 3
    }

    // MARK: - Data

    private func loadSameTagsIntoAllRows() {
        let tags = buildTextTags()
        oneLineTagView.add(tags: tags)
        twoLineTagView.add(tags: tags)
        threeLineTagView.add(tags: tags)
        oneLineTagView.reload()
        twoLineTagView.reload()
        threeLineTagView.reload()
    }

    private func buildTextTags() -> [TextTag] {
        TagSampleData.shortSampleWords.map { word in
            let tag = TextTag(
                content: TextTagStringContent(text: word),
                style: TextTagStyle()
            )
            tag.selectedStyle.backgroundColor = .green
            return tag
        }
    }
}

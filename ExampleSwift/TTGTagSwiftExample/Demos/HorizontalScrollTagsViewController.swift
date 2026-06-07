//
//  HorizontalScrollTagsViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

class HorizontalScrollTagsViewController: UIViewController {

    private let titleLabel = DemoUI.titleLabel("Horizontal scroll & line limits")
    private let descriptionLabel = DemoUI.descriptionLabel("Limit horizontal tag views to one, two, or three rows. Swipe each row to inspect overflow content.")
    private let oneLineTagView = TextTagCollectionView()
    private let twoLineTagView = TextTagCollectionView()
    private let threeLineTagView = TextTagCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)
        setupSubviews()
        configureScrollAndLineLimits()
        loadSameTagsIntoAllRows()
    }

    private func setupSubviews() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        addRow(title: "One line", tagView: oneLineTagView, height: 78, to: stackView)
        addRow(title: "Two lines", tagView: twoLineTagView, height: 116, to: stackView)
        addRow(title: "Three lines", tagView: threeLineTagView, height: 154, to: stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

    private func addRow(title: String, tagView: TextTagCollectionView, height: CGFloat, to stackView: UIStackView) {
        stackView.addArrangedSubview(DemoUI.sectionLabel(title))
        DemoUI.styleTagSurface(tagView)
        tagView.heightAnchor.constraint(equalToConstant: height).isActive = true
        stackView.addArrangedSubview(tagView)
    }

    private func configureScrollAndLineLimits() {
        for tagView in [oneLineTagView, twoLineTagView, threeLineTagView] {
            tagView.scrollDirection = .horizontal
            tagView.alignment = .fillByExpandingWidth
            tagView.horizontalSpacing = 8
            tagView.verticalSpacing = 8
            tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            tagView.showsHorizontalScrollIndicator = false
        }
        oneLineTagView.numberOfLines = 1
        twoLineTagView.numberOfLines = 2
        threeLineTagView.numberOfLines = 3
    }

    private func loadSameTagsIntoAllRows() {
        oneLineTagView.add(tags: buildTextTags())
        twoLineTagView.add(tags: buildTextTags())
        threeLineTagView.add(tags: buildTextTags())
        oneLineTagView.reload()
        twoLineTagView.reload()
        threeLineTagView.reload()
    }

    private func buildTextTags() -> [TextTag] {
        TagSampleData.shortSampleWords.map { DemoUI.tag(text: $0) }
    }
}

//
//  ProgrammaticTagsViewController.swift
//  TTGTagSwiftExample
//
//  Demo: Programmatic TextTagCollectionView + Auto Layout (intrinsic height)

import UIKit
import TTGTags

class ProgrammaticTagsViewController: UIViewController {

    private let tagView = TextTagCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTagCollectionView()
        applyLayoutConstraints()
        populateTagsFromSampleWords()
    }

    // MARK: - View Hierarchy

    private func setupTagCollectionView() {
        tagView.alignment = .fillByExpandingWidth
        tagView.layer.borderColor = UIColor.gray.cgColor
        tagView.layer.borderWidth = 1
        tagView.translatesAutoresizingMaskIntoConstraints = false

        tagView.onTapAllArea = { location in
            print("onTapAllArea: \(location)")
        }
        tagView.onTapBlankArea = { location in
            print("onTapBlankArea: \(location)")
        }

        view.addSubview(tagView)
    }

    // MARK: - Layout

    private func applyLayoutConstraints() {
        NSLayoutConstraint.activate([
            tagView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tagView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tagView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
        ])
    }

    // MARK: - Data

    private func populateTagsFromSampleWords() {
        let words = TagSampleData.shortSampleWords
        let tags: [TextTag] = words.map { word in
            let tag = TextTag(
                content: TextTagStringContent(text: word),
                style: TextTagStyle()
            )
            tag.selectedStyle.backgroundColor = .green
            return tag
        }
        tagView.add(tags: tags)

        for _ in 0..<5 {
            tagView.updateTag(at: Int(arc4random_uniform(UInt32(words.count))), selected: true)
        }
        tagView.reload()
    }
}

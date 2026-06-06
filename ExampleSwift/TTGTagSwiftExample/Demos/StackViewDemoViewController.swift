//
//  StackViewDemoViewController.swift
//  TTGTagSwiftExample
//
//  Demo 2: TextTagCollectionView embedded in UIStackView.
//  Shows that the component works seamlessly with StackView's
//  distribution, alignment, and spacing — including isHidden collapse.

import UIKit
import TTGTags

class StackViewDemoViewController: UIViewController {

    private let stackView = UIStackView()
    private let topicTagView = TextTagCollectionView()
    private let skillTagView = TextTagCollectionView()
    private let hobbyTagView = TextTagCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupStackView()
        setupTagViews()
        populateTags()
    }

    // MARK: - Setup

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func setupTagViews() {
        configure(tagView: topicTagView, title: "Topics")
        configure(tagView: skillTagView, title: "Skills")
        configure(tagView: hobbyTagView, title: "Hobbies")
    }

    private func configure(tagView: TextTagCollectionView, title: String) {
        tagView.backgroundColor = .systemGray6
        tagView.horizontalSpacing = 6
        tagView.verticalSpacing = 6
        tagView.contentInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .semibold)

        let groupStack = UIStackView(arrangedSubviews: [label, tagView])
        groupStack.axis = .vertical
        groupStack.spacing = 6
        groupStack.setCustomSpacing(6, after: label)
        stackView.addArrangedSubview(groupStack)
    }

    // MARK: - Data

    private func populateTags() {
        addTags(["iOS", "Swift", "UIKit", "SwiftUI", "CoreData"], to: topicTagView, color: .systemBlue)
        addTags(["Auto Layout", "StackView", "GCD", "ARC", "Metal", "Combine"], to: skillTagView, color: .systemGreen)
        addTags(["Photography", "Hiking", "Reading", "Cooking", "Travel"], to: hobbyTagView, color: .systemOrange)

        topicTagView.reload()
        skillTagView.reload()
        hobbyTagView.reload()

        // Add toggle button to demonstrate isHidden auto-collapse in StackView
        let toggleButton = UIButton(type: .system)
        toggleButton.setTitle("Toggle Hobbies visibility", for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleHobbies), for: .touchUpInside)
        stackView.addArrangedSubview(toggleButton)
    }

    private func addTags(_ texts: [String], to tagView: TextTagCollectionView, color: UIColor) {
        for text in texts {
            let content = TextTagStringContent(text: text)
            content.textFont = .systemFont(ofSize: 13, weight: .medium)
            content.textColor = .white

            let style = TextTagStyle()
            style.backgroundColor = color
            style.cornerRadius = 12
            style.extraSpace = CGSize(width: 10, height: 4)

            tagView.add(tag: TextTag(content: content, style: style))
        }
    }

    @objc private func toggleHobbies() {
        hobbyTagView.superview?.isHidden.toggle()
    }
}

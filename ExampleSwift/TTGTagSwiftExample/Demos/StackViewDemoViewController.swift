//
//  StackViewDemoViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

class StackViewDemoViewController: UIViewController {

    private let stackView = UIStackView()
    private let topicTagView = TextTagCollectionView()
    private let skillTagView = TextTagCollectionView()
    private let hobbyTagView = TextTagCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)
        setupStackView()
        setupTagViews()
        populateTags()
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        stackView.addArrangedSubview(DemoUI.titleLabel("UIStackView integration"))
        stackView.addArrangedSubview(DemoUI.descriptionLabel("Embed tag views inside vertical stack groups. Toggling a group uses StackView's normal hidden-state collapse behavior."))

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
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
        DemoUI.styleTagSurface(tagView)
        tagView.horizontalSpacing = 8
        tagView.verticalSpacing = 8
        tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tagView.alignment = .fillByExpandingWidth

        let groupStack = UIStackView(arrangedSubviews: [DemoUI.sectionLabel(title), tagView])
        groupStack.axis = .vertical
        groupStack.spacing = 8
        stackView.addArrangedSubview(groupStack)
    }

    private func populateTags() {
        addTags(["iOS", "Swift", "UIKit", "SwiftUI", "CoreData"], to: topicTagView, color: .systemBlue)
        addTags(["Auto Layout", "StackView", "GCD", "ARC", "Metal", "Combine"], to: skillTagView, color: .systemGreen)
        addTags(["Photography", "Hiking", "Reading", "Cooking", "Travel"], to: hobbyTagView, color: .systemOrange)

        topicTagView.reload()
        skillTagView.reload()
        hobbyTagView.reload()

        let toggleButton = UIButton(type: .system)
        toggleButton.setTitle("Toggle Hobbies visibility", for: .normal)
        DemoUI.stylePrimaryButton(toggleButton)
        toggleButton.addTarget(self, action: #selector(toggleHobbies), for: .touchUpInside)
        stackView.addArrangedSubview(toggleButton)
    }

    private func addTags(_ texts: [String], to tagView: TextTagCollectionView, color: UIColor) {
        texts.forEach { text in
            let tag = DemoUI.tag(text: text)
            tag.style.backgroundColor = color
            tagView.add(tag: tag)
        }
    }

    @objc private func toggleHobbies() {
        hobbyTagView.superview?.isHidden.toggle()
    }
}

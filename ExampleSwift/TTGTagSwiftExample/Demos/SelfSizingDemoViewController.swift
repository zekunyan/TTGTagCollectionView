//
//  SelfSizingDemoViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

class SelfSizingDemoViewController: UIViewController {

    private let tagView = TextTagCollectionView()
    private var allWords: [String] = []
    private var currentCount = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)
        allWords = TagSampleData.shortSampleWords
        setupUI()
        updateTags()
    }

    private func setupUI() {
        DemoUI.styleTagSurface(tagView)
        tagView.horizontalSpacing = 8
        tagView.verticalSpacing = 8
        tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tagView.alignment = .fillByExpandingWidth

        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Tag", for: .normal)
        DemoUI.stylePrimaryButton(addButton)
        addButton.addTarget(self, action: #selector(addTag), for: .touchUpInside)

        let removeButton = UIButton(type: .system)
        removeButton.setTitle("Remove Tag", for: .normal)
        DemoUI.stylePrimaryButton(removeButton)
        removeButton.addTarget(self, action: #selector(removeTag), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [addButton, removeButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 12

        let mainStack = UIStackView(arrangedSubviews: [
            DemoUI.titleLabel("Self-sizing"),
            DemoUI.descriptionLabel("The tag view's intrinsicContentSize changes as tags are added or removed. StackView and Auto Layout pick up the new height after reload()."),
            tagView,
            buttonStack,
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

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
        Array(allWords.prefix(currentCount)).forEach { word in
            let tag = DemoUI.tag(text: word)
            tag.style.backgroundColor = .systemIndigo
            tagView.add(tag: tag)
        }
        tagView.reload()
    }
}

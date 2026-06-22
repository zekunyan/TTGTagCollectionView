//
//  ReorderTagsViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

final class ReorderTagsViewController: UIViewController, TextTagCollectionViewDelegate {

    private let titleLabel = DemoUI.titleLabel("Reorder & delete")
    private let descriptionLabel = DemoUI.descriptionLabel("Long-press a tag, drag to reorder, or release it over the delete zone.")
    private let tagView = TextTagCollectionView()
    private let logLabel = UILabel()
    private let deleteSwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)
        setupSubviews()
        populateTags()
    }

    private func setupSubviews() {
        DemoUI.styleTagSurface(tagView)
        tagView.delegate = self
        tagView.enableTagSelection = false
        tagView.enableTagReordering = true
        tagView.enableDragToDelete = true
        tagView.alignment = .fillByExpandingWidth
        tagView.horizontalSpacing = 8
        tagView.verticalSpacing = 8
        tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tagView.dragDeleteZoneHeight = 52
        tagView.dragDeleteZoneInsets = UIEdgeInsets(top: 0, left: 18, bottom: 12, right: 18)
        tagView.dragDeleteZoneCornerRadius = 16
        tagView.dragDeleteZoneBackgroundColor = UIColor.systemGray.withAlphaComponent(0.92)
        tagView.dragDeleteZoneHighlightedBackgroundColor = UIColor.systemPink.withAlphaComponent(0.96)
        tagView.dragDeleteZoneText = "Drop tag to remove"
        tagView.dragDeleteZoneImage = UIImage(systemName: "trash.fill")

        deleteSwitch.isOn = true
        deleteSwitch.addTarget(self, action: #selector(toggleDelete), for: .valueChanged)

        let switchLabel = DemoUI.sectionLabel("Drag-to-delete")
        let switchRow = UIStackView(arrangedSubviews: [switchLabel, deleteSwitch])
        switchRow.axis = .horizontal
        switchRow.alignment = .center
        switchRow.distribution = .equalSpacing

        DemoUI.styleLogLabel(logLabel)
        logLabel.text = "Move tags to update order. Drag to the delete zone to remove."

        [titleLabel, descriptionLabel, tagView, switchRow, logLabel].forEach {
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
            tagView.heightAnchor.constraint(equalToConstant: 230),

            switchRow.topAnchor.constraint(equalTo: tagView.bottomAnchor, constant: 14),
            switchRow.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            switchRow.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            logLabel.topAnchor.constraint(equalTo: switchRow.bottomAnchor, constant: 14),
            logLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            logLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }

    private func populateTags() {
        let tags = [
            "Design", "Swift", "UIKit", "Layout", "Reusable", "Fast", "Docs",
            "Tests", "CocoaPods", "SPM", "Accessibility", "Release",
        ].map { text -> TextTag in
            let tag = DemoUI.tag(text: text)
            tag.enableAutoDetectAccessibility = true
            return tag
        }

        tagView.add(tags: tags)
        tagView.reload()
    }

    @objc private func toggleDelete() {
        tagView.enableDragToDelete = deleteSwitch.isOn
        logLabel.text = deleteSwitch.isOn
            ? "Drag-to-delete enabled."
            : "Drag-to-delete disabled. Reordering is still enabled."
    }

    func textTagCollectionView(
        _ collectionView: TextTagCollectionView,
        didMoveTag tag: TextTag,
        fromIndex: Int,
        toIndex: Int
    ) {
        let title = tag.content.getContentAttributedString().string
        logLabel.text = "Moved \(title) from \(fromIndex) to \(toIndex)."
    }

    func textTagCollectionView(
        _ collectionView: TextTagCollectionView,
        canDeleteTag tag: TextTag,
        at index: Int
    ) -> Bool {
        return collectionView.allTags().count > 1
    }

    func textTagCollectionView(
        _ collectionView: TextTagCollectionView,
        didDeleteTag tag: TextTag,
        at index: Int
    ) {
        let title = tag.content.getContentAttributedString().string
        logLabel.text = "Deleted \(title) at index \(index)."
    }
}

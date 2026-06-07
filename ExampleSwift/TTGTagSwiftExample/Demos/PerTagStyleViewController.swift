//
//  PerTagStyleViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

class PerTagStyleViewController: UIViewController {

    private let titleLabel = DemoUI.titleLabel("Each tag can be different")
    private let descriptionLabel = DemoUI.descriptionLabel("Each TextTag owns independent content, style, selectedStyle, accessibility metadata, and attachment data.")
    private let tagView = TextTagCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)
        setupSubviews()
        loadColorBatches()
        tagView.reload()
    }

    private func setupSubviews() {
        DemoUI.styleTagSurface(tagView)
        tagView.alignment = .fillByExpandingWidth
        tagView.delegate = self
        tagView.horizontalSpacing = 8
        tagView.verticalSpacing = 8
        tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

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
            tagView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

    private func loadColorBatches() {
        let pool = TagSampleData.shortWordsRepeated(count: 3)
        let batchSize = 8
        let palette: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemTeal, .systemGray, .systemPink, .systemCyan, .systemIndigo]

        for (groupIndex, color) in palette.enumerated() {
            let startIndex = groupIndex * batchSize
            guard startIndex + batchSize <= pool.count else { break }
            let slice = Array(pool[startIndex..<(startIndex + batchSize)])
            addBatch(words: slice, backgroundColor: color, groupIndex: groupIndex)
            tagView.updateTag(at: startIndex + Int(arc4random_uniform(UInt32(batchSize))), selected: true)
        }
    }

    private func addBatch(words: [String], backgroundColor: UIColor, groupIndex: Int) {
        for text in words {
            let tag = DemoUI.tag(text: text)
            tag.style.backgroundColor = backgroundColor
            tag.selectedStyle.backgroundColor = complementApproximate(color: backgroundColor)
            tag.selectedStyle.borderColor = .label
            tag.selectedStyle.borderWidth = 1
            tag.attachment = ["group": groupIndex + 1] as NSDictionary
            tag.isAccessibilityElement = true
            tag.accessibilityLabel = text
            tag.accessibilityIdentifier = "identifier: \(text)"
            tag.accessibilityHint = "hint: \(text)"
            tag.accessibilityValue = "value: \(text)"
            tagView.add(tag: tag)
        }
    }

    private func complementApproximate(color: UIColor) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        return UIColor(red: max(0.12, 1 - red), green: max(0.12, 1 - green), blue: max(0.12, 1 - blue), alpha: 1)
    }
}

extension PerTagStyleViewController: TextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TextTagCollectionView!,
                               didTapTag tag: TextTag!,
                               at index: Int) {
        print("Did tap: \(tag.content), attachment: \(String(describing: tag.attachment))")
    }
}

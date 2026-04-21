//
//  PerTagStyleViewController.swift
//  TTGTagSwiftExample
//
//  Demo: Per-tag independent style, selectedStyle and attachment

import UIKit
import TTGTags

class PerTagStyleViewController: UIViewController {

    private let tagView = TextTagCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        tagView.alignment = .fillByExpandingWidth
        tagView.delegate = self
        loadColorBatches()
        tagView.reload()
    }

    // MARK: - Setup

    private func setupSubviews() {
        tagView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tagView)

        NSLayoutConstraint.activate([
            tagView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tagView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tagView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

    // MARK: - Data

    private func loadColorBatches() {
        let pool = TagSampleData.shortWordsRepeated(count: 3)
        let batchSize = 8
        let palette: [UIColor] = [
            UIColor(red: 0.24, green: 0.72, blue: 0.94, alpha: 1),
            UIColor(red: 0.30, green: 0.72, blue: 0.53, alpha: 1),
            UIColor(red: 0.97, green: 0.64, blue: 0.27, alpha: 1),
            UIColor(red: 0.73, green: 0.91, blue: 0.41, alpha: 1),
            UIColor(red: 0.35, green: 0.35, blue: 0.36, alpha: 1),
            UIColor(red: 1.00, green: 0.41, blue: 0.42, alpha: 1),
            UIColor(red: 0.50, green: 0.86, blue: 0.90, alpha: 1),
            UIColor(red: 0.33, green: 0.23, blue: 0.34, alpha: 1),
        ]

        for (groupIndex, color) in palette.enumerated() {
            let startIndex = groupIndex * batchSize
            guard startIndex + batchSize <= pool.count else { break }
            let slice = Array(pool[startIndex..<(startIndex + batchSize)])
            addBatch(words: slice, backgroundColor: color, groupIndex: groupIndex)
            tagView.updateTag(at: startIndex + Int(arc4random_uniform(UInt32(batchSize))), selected: true)
        }
    }

    private func addBatch(words: [String], backgroundColor: UIColor, groupIndex: Int) {
        let baseStyle = TextTagStyle()
        baseStyle.backgroundColor = .white
        baseStyle.borderColor = .white
        baseStyle.borderWidth = 1
        baseStyle.cornerRadius = 4
        baseStyle.extraSpace = CGSize(width: 8, height: 8)
        baseStyle.shadowColor = .black
        baseStyle.shadowOpacity = 0.3
        baseStyle.shadowRadius = 2
        baseStyle.shadowOffset = CGSize(width: 1, height: 1)

        for text in words {
            let tag = TextTag()

            tag.isAccessibilityElement = true
            tag.accessibilityLabel = text
            tag.accessibilityIdentifier = "identifier: \(text)"
            tag.accessibilityHint = "hint: \(text)"
            tag.accessibilityValue = "value: \(text)"

            let style = baseStyle.copy() as! TextTagStyle
            style.backgroundColor = backgroundColor

            let selectedStyle = style.copy() as! TextTagStyle
            selectedStyle.backgroundColor = complementApproximate(color: backgroundColor)
            selectedStyle.borderColor = .black
            selectedStyle.cornerRadius = 8
            selectedStyle.shadowColor = .green

            let content = TextTagStringContent()
            content.textFont = .systemFont(ofSize: 20)
            content.textColor = .white
            content.text = text

            tag.style = style
            tag.selectedStyle = selectedStyle
            tag.content = content
            tag.attachment = ["group": groupIndex + 1] as NSDictionary
            tagView.add(tag: tag)
        }
    }

    private func complementApproximate(color: UIColor) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        return UIColor(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: 1)
    }
}

// MARK: - TextTagCollectionViewDelegate

extension PerTagStyleViewController: TextTagCollectionViewDelegate {

    func textTagCollectionView(_ textTagCollectionView: TextTagCollectionView!,
                               didTapTag tag: TextTag!,
                               at index: Int) {
        print("Did tap: \(tag.content), attachment: \(String(describing: tag.attachment))")
    }
}

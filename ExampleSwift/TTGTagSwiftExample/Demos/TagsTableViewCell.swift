//
//  TagsTableViewCell.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

class TagsTableViewCell: UITableViewCell {

    static let reuseIdentifier = "TagsTableViewCell"

    private let surfaceView = UIView()
    private let titleLabel = UILabel()
    private let tagView = TextTagCollectionView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if updatePreferredMaxLayoutWidthIfNeeded() {
            tagView.reload()
        }
    }

    @discardableResult
    private func updatePreferredMaxLayoutWidthIfNeeded() -> Bool {
        let maxWidth = max(0, surfaceView.bounds.width - 24)
        if abs(tagView.preferredMaxLayoutWidth - maxWidth) > 0.5 {
            tagView.preferredMaxLayoutWidth = maxWidth
            return true
        }
        return false
    }

    private func setupSubviews() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear

        surfaceView.backgroundColor = .secondarySystemBackground
        surfaceView.layer.cornerRadius = 10
        surfaceView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(surfaceView)

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        surfaceView.addSubview(titleLabel)

        DemoUI.styleTagSurface(tagView)
        tagView.backgroundColor = .clear
        tagView.alignment = .fillByExpandingWidth
        tagView.manualCalculateHeight = true
        tagView.showsHorizontalScrollIndicator = false
        tagView.scrollView.alwaysBounceHorizontal = false
        tagView.scrollDirection = .vertical
        tagView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        tagView.horizontalSpacing = 8
        tagView.verticalSpacing = 8
        tagView.translatesAutoresizingMaskIntoConstraints = false
        surfaceView.addSubview(tagView)

        NSLayoutConstraint.activate([
            surfaceView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            surfaceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            surfaceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            surfaceView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            titleLabel.topAnchor.constraint(equalTo: surfaceView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: surfaceView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: surfaceView.trailingAnchor, constant: -12),

            tagView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tagView.leadingAnchor.constraint(equalTo: surfaceView.leadingAnchor, constant: 12),
            tagView.trailingAnchor.constraint(equalTo: surfaceView.trailingAnchor, constant: -12),
            tagView.bottomAnchor.constraint(equalTo: surfaceView.bottomAnchor, constant: -12),
        ])
    }

    func configure(title: String, tags: [TextTag], availableWidth: CGFloat) {
        titleLabel.text = title

        let tagWidth = max(0, availableWidth - 24)
        if tagWidth > 0 {
            tagView.preferredMaxLayoutWidth = tagWidth
        }

        tagView.removeAllTags()
        tagView.add(tags: tags)

        if surfaceView.bounds.width <= 0 {
            let fallbackWidth = max(0, availableWidth - 24)
            tagView.preferredMaxLayoutWidth = fallbackWidth
        } else {
            _ = updatePreferredMaxLayoutWidthIfNeeded()
        }
        tagView.reload()
    }
}

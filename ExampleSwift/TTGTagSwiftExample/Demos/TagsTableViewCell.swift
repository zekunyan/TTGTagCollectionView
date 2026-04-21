//
//  TagsTableViewCell.swift
//  TTGTagSwiftExample
//
//  Tags embedded in UITableViewCell with self-sizing row height

import UIKit
import TTGTags

class TagsTableViewCell: UITableViewCell {

    static let reuseIdentifier = "TagsTableViewCell"

    let titleLabel = UILabel()
    let tagView = TextTagCollectionView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        titleLabel.font = .systemFont(ofSize: 18)
        titleLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        tagView.alignment = .fillByExpandingWidth
        tagView.manualCalculateHeight = true
        tagView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tagView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),

            tagView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tagView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tagView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            tagView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    func configure(with words: [String]) {
        tagView.removeAllTags()

        let tags: [TextTag] = words.map { word in
            let tag = TextTag(
                content: TextTagStringContent(text: word),
                style: TextTagStyle()
            )
            tag.selectedStyle.backgroundColor = .green
            return tag
        }
        tagView.add(tags: tags)

        tagView.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 16

        if !words.isEmpty {
            for _ in 0..<3 {
                tagView.updateTag(at: Int(arc4random_uniform(UInt32(words.count))), selected: true)
            }
        }
        tagView.reload()
    }
}

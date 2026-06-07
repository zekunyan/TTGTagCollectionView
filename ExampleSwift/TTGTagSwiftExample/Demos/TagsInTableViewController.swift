//
//  TagsInTableViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

class TagsInTableViewController: UITableViewController {

    private struct Row {
        let title: String
        let tags: [TextTag]
    }

    private let rowCount = 50
    private let wordPool = TagSampleData.shortSampleWords
    private lazy var rows: [Row] = buildRows()
    private var rowHeightCache: [String: CGFloat] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(tableView)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 96
        tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: TagsTableViewCell.reuseIdentifier)
        tableView.tableHeaderView = buildHeaderView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let headerView = tableView.tableHeaderView else { return }
        let fittingSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let height = headerView.systemLayoutSizeFitting(fittingSize).height
        if abs(headerView.frame.height - height) > 0.5 {
            headerView.frame.size.height = height
            tableView.tableHeaderView = headerView
        }
    }

    private func buildHeaderView() -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        let titleLabel = DemoUI.titleLabel("Tags in UITableViewCell")
        let descriptionLabel = DemoUI.descriptionLabel("Each row owns a tag collection view. The cell updates preferredMaxLayoutWidth from its content width to avoid horizontal scrolling inside the row.")

        [titleLabel, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
        ])

        return container
    }

    private func buildRows() -> [Row] {
        (0..<rowCount).map { index in
            let length = max(1, index % (wordPool.count + 1))
            let tags = Array(wordPool.prefix(length)).enumerated().map { tagIndex, word in
                let tag = DemoUI.tag(text: word)
                tag.selected = shouldPreselectTag(at: tagIndex, tagCount: length)
                return tag
            }
            return Row(title: "Cell \(index + 1)", tags: tags)
        }
    }

    private func shouldPreselectTag(at index: Int, tagCount: Int) -> Bool {
        guard tagCount > 0 else { return false }
        return (0..<min(3, tagCount)).contains { selectedSlot in
            index == (selectedSlot * 7 + tagCount / 2) % tagCount
        }
    }

    private func cachedHeight(for row: Row, tableWidth: CGFloat, index: Int) -> CGFloat {
        let width = max(0, tableWidth)
        let cacheKey = "\(index)|\(Int(width.rounded()))"
        if let cached = rowHeightCache[cacheKey] {
            return cached
        }

        let surfaceHorizontalInset: CGFloat = 32
        let tagHorizontalInset: CGFloat = 24
        let tagWidth = max(0, width - surfaceHorizontalInset - tagHorizontalInset)
        let tagSize = TextTagCollectionView.contentSize(
            for: row.tags,
            width: tagWidth,
            scrollDirection: .vertical,
            alignment: .fillByExpandingWidth,
            numberOfLines: 0,
            horizontalSpacing: 8,
            verticalSpacing: 8,
            contentInset: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        )

        let titleHeight = ceil(UIFont.systemFont(ofSize: 16, weight: .semibold).lineHeight)
        let height = 6 + 12 + titleHeight + 8 + ceil(tagSize.height) + 12 + 6
        rowHeightCache[cacheKey] = height
        return height
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TagsTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! TagsTableViewCell
        let row = rows[indexPath.row]
        cell.configure(title: row.title, tags: row.tags, availableWidth: tableView.bounds.width - 32)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cachedHeight(for: rows[indexPath.row], tableWidth: tableView.bounds.width, index: indexPath.row)
    }
}

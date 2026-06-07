//
//  TagsInTableViewController.swift
//  TTGTagSwiftExample
//

import UIKit

class TagsInTableViewController: UITableViewController {

    private let rowCount = 50
    private let wordPool = TagSampleData.shortSampleWords
    private lazy var rows: [[String]] = buildRows()

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

    private func buildRows() -> [[String]] {
        (0..<rowCount).map { index in
            let length = max(1, index % (wordPool.count + 1))
            return Array(wordPool.prefix(length))
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TagsTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! TagsTableViewCell
        cell.configure(title: "Cell \(indexPath.row + 1)", words: rows[indexPath.row])
        return cell
    }
}

//
//  TagsInTableViewController.swift
//  TTGTagSwiftExample
//
//  Demo: Tags embedded in UITableViewCell with self-sizing row height

import UIKit
import TTGTags

class TagsInTableViewController: UITableViewController {

    private let rowCount = 50
    private let wordPool = TagSampleData.shortSampleWords
    private lazy var rows: [[String]] = buildRows()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: TagsTableViewCell.reuseIdentifier)
    }

    // MARK: - Data

    private func buildRows() -> [[String]] {
        (0..<rowCount).map { index in
            let length = index % (wordPool.count + 1)
            return Array(wordPool.prefix(length))
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TagsTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! TagsTableViewCell
        cell.configure(with: rows[indexPath.row])
        cell.titleLabel.text = "Cell: \(indexPath.row)"
        return cell
    }
}

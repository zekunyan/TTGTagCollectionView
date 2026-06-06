//
//  DemoListViewController.swift
//  TTGTagSwiftExample
//

import UIKit

class DemoListViewController: UITableViewController {

    private struct DemoItem {
        let title: String
        let viewControllerType: UIViewController.Type
    }

    private let demoItems: [DemoItem] = [
        DemoItem(title: "Basic text tags (two columns)", viewControllerType: BasicTextTagsViewController.self),
        DemoItem(title: "Attributed string tags", viewControllerType: AttributedStringTagsViewController.self),
        DemoItem(title: "Horizontal scroll & line limits", viewControllerType: HorizontalScrollTagsViewController.self),
        DemoItem(title: "Per-tag style & attachment", viewControllerType: PerTagStyleViewController.self),
        DemoItem(title: "Programmatic (Auto Layout)", viewControllerType: ProgrammaticTagsViewController.self),
        DemoItem(title: "Bind data to tag", viewControllerType: TagAttachmentViewController.self),
        DemoItem(title: "Tags in UITableViewCell", viewControllerType: TagsInTableViewController.self),
        DemoItem(title: "🔗 Anchor constraint layout", viewControllerType: AnchorLayoutDemoViewController.self),
        DemoItem(title: "📦 UIStackView integration", viewControllerType: StackViewDemoViewController.self),
        DemoItem(title: "📐 Self-sizing (intrinsicContentSize)", viewControllerType: SelfSizingDemoViewController.self),
        DemoItem(title: "⚡ SwiftUI (TagCloudView)", viewControllerType: SwiftUIDemoViewController.self),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TTGTagCollectionView Demos"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DemoCell")
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
        cell.textLabel?.text = demoItems[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = demoItems[indexPath.row]
        let viewController = item.viewControllerType.init()
        viewController.title = item.title
        navigationController?.pushViewController(viewController, animated: true)
    }
}

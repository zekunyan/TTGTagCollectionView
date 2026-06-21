//
//  DemoListViewController.swift
//  TTGTagSwiftExample
//

import UIKit

class DemoListViewController: UITableViewController {

    private struct DemoItem {
        let title: String
        let detail: String
        let viewControllerType: UIViewController.Type
    }

    private let demoItems: [DemoItem] = [
        DemoItem(title: "1. Basic text tags", detail: "Two vertical tag collections with shared default styling.", viewControllerType: BasicTextTagsViewController.self),
        DemoItem(title: "2. Custom UIView tags", detail: "Use labels, buttons, and image views as custom tag content.", viewControllerType: CustomSubviewTagsViewController.self),
        DemoItem(title: "3. Programmatic APIs", detail: "Multiline tags, tagId updates, and scroll-to-tag.", viewControllerType: ProgrammaticTagsViewController.self),
        DemoItem(title: "4. Tags in UITableViewCell", detail: "Self-sizing table cells with wrapped tags.", viewControllerType: TagsInTableViewController.self),
        DemoItem(title: "5. Horizontal scroll & line limits", detail: "One, two, and three-line horizontal scrolling tag rows.", viewControllerType: HorizontalScrollTagsViewController.self),
        DemoItem(title: "6. Pull to refresh", detail: "Native refresh control plus near-bottom loading.", viewControllerType: PullRefreshTagsViewController.self),
        DemoItem(title: "7. Each tag can be different", detail: "Independent content, styles, selected styles, and attachments.", viewControllerType: PerTagStyleViewController.self),
        DemoItem(title: "8. Bind data to tag", detail: "Tap tags and inspect the attached model payload.", viewControllerType: TagAttachmentViewController.self),
        DemoItem(title: "9. Attributed string tags", detail: "Rich text content with mixed font weight and color.", viewControllerType: AttributedStringTagsViewController.self),
        DemoItem(title: "10. Anchor constraint layout", detail: "Auto Layout anchor constraints around a tag view.", viewControllerType: AnchorLayoutDemoViewController.self),
        DemoItem(title: "11. UIStackView integration", detail: "Tag views embedded in vertical stack layouts.", viewControllerType: StackViewDemoViewController.self),
        DemoItem(title: "12. Self-sizing", detail: "Intrinsic content size and dynamic container updates.", viewControllerType: SelfSizingDemoViewController.self),
        DemoItem(title: "13. Auto Layout form", detail: "Form sections using tag views without fixed heights.", viewControllerType: AutoLayoutFormViewController.self),
        DemoItem(title: "14. SwiftUI integration", detail: "Use TagCloudView from SwiftUI and keep UIKit behavior.", viewControllerType: SwiftUIDemoViewController.self),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TTGTag"
        DemoUI.applyScreenBackground(tableView)
        tableView.separatorStyle = .none
        tableView.rowHeight = 72
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DemoCell")
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
        let item = demoItems[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = item.detail
        content.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
        content.secondaryTextProperties.font = .systemFont(ofSize: 13)
        content.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration = content
        cell.backgroundColor = .clear
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

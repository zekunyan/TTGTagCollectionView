//
//  TagAttachmentViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

private class CustomPayload: NSObject {
    let info: String

    init(info: String) {
        self.info = info
    }

    override var description: String {
        "CustomPayload{\(info)}"
    }
}

class TagAttachmentViewController: UIViewController {

    private let titleLabel = DemoUI.titleLabel("Bind data to tag")
    private let descriptionLabel = DemoUI.descriptionLabel("Every tag can carry arbitrary attachment data. Tap a tag to inspect the bound object in the log.")
    private let tagView = TextTagCollectionView()
    private let logTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)
        setupViews()
        loadAttachmentDemonstrationTags()
        tagView.delegate = self
    }

    private func setupViews() {
        DemoUI.styleTagSurface(tagView)
        tagView.alignment = .fillByExpandingWidth
        tagView.horizontalSpacing = 8
        tagView.verticalSpacing = 8
        tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        DemoUI.styleLogTextView(logTextView)
        logTextView.text = "Tap a tag to print its attachment..."

        [titleLabel, descriptionLabel, tagView, logTextView].forEach {
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
            tagView.heightAnchor.constraint(equalToConstant: 170),

            logTextView.topAnchor.constraint(equalTo: tagView.bottomAnchor, constant: 16),
            logTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            logTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            logTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

    private func loadAttachmentDemonstrationTags() {
        let payload = CustomPayload(info: "Custom NSObject payload")

        let items: [(title: String, attachment: AnyObject)] = [
            ("Bind NSObject", payload),
            ("Bind NSDictionary", ["info": "NSDictionary payload"] as NSDictionary),
            ("Bind NSString A", "String A" as NSString),
            ("Bind NSString B", "String B" as NSString),
        ]

        for item in items {
            let tag = DemoUI.tag(text: item.title)
            tag.attachment = item.attachment
            tagView.add(tag: tag)
        }

        tagView.reload()
    }
}

extension TagAttachmentViewController: TextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TextTagCollectionView,
                               didTapTag tag: TextTag,
                               at index: Int) {
        let prefix = logTextView.text == nil || logTextView.text.isEmpty ? "" : "\(logTextView.text!)\n\n"
        logTextView.text = "\(prefix)Tapped attachment:\n\(String(describing: tag.attachment))"
    }
}

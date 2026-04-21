//
//  TagAttachmentViewController.swift
//  TTGTagSwiftExample
//
//  Demo: Bind arbitrary data via tag.attachment

import UIKit
import TTGTags

// MARK: - Sample Data Model

private class CustomPayload: NSObject {
    let info: String

    init(info: String) {
        self.info = info
    }

    override var description: String {
        "CustomPayload{\(info)}"
    }
}

// MARK: - ViewController

class TagAttachmentViewController: UIViewController {

    private let tagView = TextTagCollectionView()
    private let logTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        loadAttachmentDemonstrationTags()
        tagView.delegate = self
    }

    // MARK: - UI

    private func setupViews() {
        tagView.alignment = .fillByExpandingWidth
        tagView.layer.borderColor = UIColor.gray.cgColor
        tagView.layer.borderWidth = 1
        tagView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tagView)

        logTextView.layer.borderColor = UIColor.gray.cgColor
        logTextView.layer.borderWidth = 1
        logTextView.textColor = .gray
        logTextView.font = .systemFont(ofSize: 12)
        logTextView.isEditable = false
        logTextView.translatesAutoresizingMaskIntoConstraints = false
        logTextView.contentInset = .zero
        logTextView.textContainerInset = .zero
        logTextView.showsHorizontalScrollIndicator = true
        view.addSubview(logTextView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tagView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tagView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tagView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tagView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            logTextView.topAnchor.constraint(equalTo: tagView.bottomAnchor, constant: 20),
            logTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }

    // MARK: - Tags

    private func sharedBlueTagStyle() -> TextTagStyle {
        let style = TextTagStyle()
        style.backgroundColor = UIColor(red: 0.24, green: 0.72, blue: 0.94, alpha: 1)
        style.borderColor = .white
        style.borderWidth = 1
        style.cornerRadius = 4
        style.extraSpace = CGSize(width: 8, height: 8)
        style.shadowColor = .black
        style.shadowOpacity = 0.3
        style.shadowRadius = 2
        style.shadowOffset = CGSize(width: 1, height: 1)
        return style
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
            let content = TextTagStringContent()
            content.text = item.title
            let tag = TextTag()
            tag.attachment = item.attachment
            tag.style = sharedBlueTagStyle()
            tag.content = content
            tagView.add(tag: tag)
        }

        tagView.reload()
    }
}

// MARK: - TextTagCollectionViewDelegate

extension TagAttachmentViewController: TextTagCollectionViewDelegate {

    func textTagCollectionView(_ textTagCollectionView: TextTagCollectionView!,
                               didTapTag tag: TextTag!,
                               at index: Int) {
        let currentText = logTextView.text ?? ""
        logTextView.text = "\(currentText)\nTapped attachment:\n\(String(describing: tag.attachment))\n"
    }
}

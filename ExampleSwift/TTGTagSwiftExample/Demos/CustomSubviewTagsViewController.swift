//
//  CustomSubviewTagsViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

class CustomSubviewTagsViewController: UIViewController {

    private let tagCollectionView = TagCollectionView()
    private let logLabel = UILabel()
    private var tagViews: [UIView] = []
    private var tagSizes: [CGSize] = []
    private var didReloadAfterLayout = false

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)
        setupSubviews()
        buildDemoTagViews()
        tagCollectionView.reload()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didReloadAfterLayout, tagCollectionView.bounds.width > 0 {
            didReloadAfterLayout = true
            tagCollectionView.reload()
        }
    }

    private func setupSubviews() {
        let titleLabel = DemoUI.titleLabel("Custom UIView tags")
        let descriptionLabel = DemoUI.descriptionLabel("Feeds labels, buttons, and image views through TagCollectionViewDataSource. The collection view measures each custom UIView via sizeForTagAtIndex.")
        DemoUI.styleTagSurface(tagCollectionView)
        DemoUI.styleLogLabel(logLabel)

        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.horizontalSpacing = 8
        tagCollectionView.verticalSpacing = 8
        tagCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        [titleLabel, descriptionLabel, tagCollectionView, logLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tagCollectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 18),
            tagCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tagCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tagCollectionView.heightAnchor.constraint(equalToConstant: 320),

            logLabel.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor, constant: 14),
            logLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: logLabel.bottomAnchor, constant: 12),
        ])
    }

    private func buildDemoTagViews() {
        let teal = UIColor.systemTeal
        let blue = UIColor.systemBlue
        let orange = UIColor.systemOrange

        func add(_ view: UIView) {
            tagViews.append(view)
            tagSizes.append(view.frame.size)
        }

        add(label(text: "AutoLayout", fontSize: 14, textColor: .white, background: teal))
        add(button(title: "Button1", fontSize: 18, background: blue))
        add(image(name: "bluefaces_1"))
        add(label(text: "dynamically", fontSize: 20, textColor: .white, background: teal))
        add(button(title: "Button2", fontSize: 16, background: orange))
        add(button(title: "Button3", fontSize: 15, background: blue))
        add(image(name: "bluefaces_2"))
        add(label(text: "the", fontSize: 16, textColor: .white, background: teal))
        add(button(title: "Button4", fontSize: 22, background: blue))
        add(image(name: "bluefaces_3"))
        add(label(text: "views", fontSize: 12, textColor: UIColor(red: 0.21, green: 0.29, blue: 0.36, alpha: 1), background: orange))
        add(button(title: "Button5", fontSize: 15, background: teal))
        add(image(name: "bluefaces_4"))
        add(image(name: "bluefaces_4"))
    }

    private func label(text: String, fontSize: CGFloat, textColor: UIColor, background: UIColor) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.text = text
        label.textColor = textColor
        label.backgroundColor = background
        label.sizeToFit()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12
        pad(label, width: 12, height: 8)
        return label
    }

    private func button(title: String, fontSize: CGFloat, background: UIColor) -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: fontSize)
        button.setTitle(title, for: .normal)
        button.backgroundColor = background
        button.sizeToFit()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        pad(button, width: 12, height: 8)
        button.addTarget(self, action: #selector(tagButtonTapped), for: .touchUpInside)
        return button
    }

    private func image(name: String) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: name))
        imageView.sizeToFit()
        return imageView
    }

    private func pad(_ view: UIView, width: CGFloat, height: CGFloat) {
        var frame = view.frame
        frame.size.width += width
        frame.size.height += height
        view.frame = frame
    }

    @objc private func tagButtonTapped() {
        logLabel.text = "Tap tag button!"
    }
}

extension CustomSubviewTagsViewController: TagCollectionViewDelegate, TagCollectionViewDataSource {

    func tagCollectionView(_ tagCollectionView: TagCollectionView, sizeForTagAt index: Int) -> CGSize {
        tagSizes[index]
    }

    func tagCollectionView(_ tagCollectionView: TagCollectionView, didSelectTag tagView: UIView, at index: Int) {
        logLabel.text = "Tap tag: \(type(of: tagView)), at: \(index)"
    }

    func numberOfTags(in tagCollectionView: TagCollectionView) -> Int {
        tagViews.count
    }

    func tagCollectionView(_ tagCollectionView: TagCollectionView, tagViewFor index: Int) -> UIView {
        tagViews[index]
    }
}

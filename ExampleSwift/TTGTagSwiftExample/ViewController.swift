//
//  ViewController.swift
//  TTGTagSwiftExample
//
//  Created by zekunyan on 2021/4/30.
//

import UIKit
import TTGTags

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let tagView = TextTagCollectionView(
            frame: CGRect(
                x: 16,
                y: 100,
                width: UIScreen.main.bounds.width - 32,
                height: 300
            )
        )
        tagView.backgroundColor = .lightGray
        view.addSubview(tagView)

        let strings = ["AutoLayout", "dynamically", "calculates", "the", "size", "and", "position",
                       "of", "all", "the", "views", "in", "your", "view", "hierarchy", "based",
                       "on", "constraints", "placed", "on", "those", "views"]

        for text in strings {
            let content = TextTagStringContent(text: text)
            content.textColor = .black
            content.textFont = .boldSystemFont(ofSize: 20)

            let normalStyle = TextTagStyle()
            normalStyle.backgroundColor = .white
            normalStyle.extraSpace = CGSize(width: 8, height: 8)

            let selectedStyle = TextTagStyle()
            selectedStyle.backgroundColor = .green
            selectedStyle.extraSpace = CGSize(width: 8, height: 8)

            let tag = TextTag(content: content, style: normalStyle)
            tag.selectedStyle = selectedStyle

            tagView.add(tag: tag)
        }

        tagView.reload()
    }
}

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
        
        let tagView = TTGTextTagCollectionView.init(frame: CGRect.init(x: 16, y: 100, width: UIScreen.main.bounds.width - 32, height: 300))
        tagView.backgroundColor = UIColor.lightGray
        self.view.addSubview(tagView)
        
        let strings = ["AutoLayout", "dynamically", "calculates", "the", "size", "and", "position",
                       "of", "all", "the", "views", "in", "your", "view", "hierarchy", "based",
                       "on", "constraints", "placed", "on", "those", "views"]
        
        for text in strings {
            let content = TTGTextTagStringContent.init(text: text)
            content.textColor = UIColor.black
            content.textFont = UIFont.boldSystemFont(ofSize: 20)
            
            let normalStyle = TTGTextTagStyle.init()
            normalStyle.backgroundColor = UIColor.white
            normalStyle.extraSpace = CGSize.init(width: 8, height: 8)
            
            let selectedStyle = TTGTextTagStyle.init()
            selectedStyle.backgroundColor = UIColor.green
            selectedStyle.extraSpace = CGSize.init(width: 8, height: 8)
            
            let tag = TTGTextTag.init()
            tag.content = content
            tag.style = normalStyle
            tag.selectedStyle = selectedStyle
            
            tagView.addTag(tag)
        }
        
        tagView.reload()
    }
}


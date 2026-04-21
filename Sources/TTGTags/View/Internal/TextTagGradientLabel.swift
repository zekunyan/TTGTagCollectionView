//
//  TextTagGradientLabel.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// `UILabel` 子类，将 layer 替换为 `CAGradientLayer` 以支持渐变背景。
final class TextTagGradientLabel: UILabel {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

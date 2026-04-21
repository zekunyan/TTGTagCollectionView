//
//  TextTagGradientLabel.swift
//  TTGTags
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

import UIKit

/// `UILabel` subclass that replaces the layer with `CAGradientLayer` for gradient background support.
final class TextTagGradientLabel: UILabel {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

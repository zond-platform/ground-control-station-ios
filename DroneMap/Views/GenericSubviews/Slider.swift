//
//  TableCellSlider.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 21.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class Slider : UISlider {
    let thumbRadius = AppDimensions.MissionView.Row.Slider.sliderThumbRadius
    var idPath: IdPath?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let thumbView = UIView()
        thumbView.backgroundColor = AppColor.Text.detailTitle
        thumbView.frame = CGRect(x: 0, y: 0, width: thumbRadius, height: thumbRadius)
        thumbView.layer.cornerRadius = thumbRadius / CGFloat(2)
        let imageRenderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        let thumbImage = imageRenderer.image { thumbView.layer.render(in: $0.cgContext) }
        setThumbImage(thumbImage, for: .normal)
        minimumTrackTintColor = AppColor.Text.detailTitle
        maximumTrackTintColor = AppColor.Text.inactiveTitle
    }
}

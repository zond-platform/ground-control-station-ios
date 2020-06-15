//
//  TableCellSlider.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 21.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class TableSlider : UISlider {
    var idPath: IdPath?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let thumbView = UIView()
        let thumbRadius = MissionView.TableRow.height * CGFloat(0.6)
        thumbView.backgroundColor = Colors.Text.detailTitle
        thumbView.frame = CGRect(x: 0, y: 0, width: thumbRadius, height: thumbRadius)
        thumbView.layer.cornerRadius = thumbRadius * CGFloat(0.5)
        let imageRenderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        let thumbImage = imageRenderer.image { thumbView.layer.render(in: $0.cgContext) }
        setThumbImage(thumbImage, for: .normal)
        minimumTrackTintColor = Colors.Text.detailTitle
        maximumTrackTintColor = Colors.Text.inactiveTitle
    }
}

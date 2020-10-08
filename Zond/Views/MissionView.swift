//
//  MissionView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 5/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class MissionView : UITableView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: -Dimensions.missionMenuWidth,
            y: Dimensions.tileSize,
            width: Dimensions.missionMenuWidth,
            height: Dimensions.screenHeight - Dimensions.tileSize
        ), style: .grouped)
        separatorStyle = .none
        isScrollEnabled = false
        backgroundColor = Colors.Overlay.primaryColor
    }
}

// Public methods
extension MissionView {
    func showFromSide(_ show: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.x = show ? 0 : -Dimensions.missionMenuWidth
        })
    }
}

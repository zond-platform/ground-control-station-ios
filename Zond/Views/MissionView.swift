//
//  MissionView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 5/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class MissionView : UITableView {
    private var x: CGFloat {
        return 0
    }
    private var y: CGFloat {
        return Dimensions.tileSize
    }
    private var width: CGFloat {
        return Dimensions.missionMenuWidth
    }
    private var height: CGFloat {
        return Dimensions.screenHeight - Dimensions.tileSize
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(), style: .grouped)
        frame = CGRect(
            x: -width,
            y: y,
            width: width,
            height: height
        )
        separatorStyle = .none
        isScrollEnabled = false
        backgroundColor = Colors.primary
    }
}

// Public methods
extension MissionView {
    func showFromSide(_ show: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.x = show ? self.x : -self.width
        })
    }
}

//
//  TabView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

/*************************************************************************************************/
class TabView : UIView {
    let statusViewHeight: CGFloat = 116.0
    private var statusView = UIView()
    private var consoleView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: CGRect())
    }
    
    func addSubviews(_ statusView: UIView,
                     _ consoleView: UIView) {
        self.statusView.addSubview(statusView)
        self.consoleView.addSubview(consoleView)
        addSubview(self.statusView)
        addSubview(self.consoleView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        statusView.frame = CGRect(
            x: 0,
            y: 0,
            width: frame.width,
            height: statusViewHeight
        )
        consoleView.frame = CGRect(
            x: 0,
            y: statusViewHeight,
            width: frame.width,
            height: frame.height - statusViewHeight
        )
    }
}

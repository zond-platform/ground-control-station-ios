//
//  TabViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 18.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class TabViewController : UIViewController {
    private var tabView: TabView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        tabView = TabView()
        tabView.addDelegate(self)
        view = tabView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Listen to view events
extension TabViewController : TabViewDelegate {
    internal func buttonSelected(_ id: TabButtonId, _ selected: Bool) {
        switch id {
            case .mission:
                Environment.settingsViewController.showView(selected)
        case .controls:
                Environment.controlViewController.showView(selected)
            default:
                break
        }
    }
}

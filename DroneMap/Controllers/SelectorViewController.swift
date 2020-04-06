//
//  SelectorViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 03.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class SelectorViewController : UIViewController {
    private var env: Environment!
    private var selectorView: SelectorView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ env: Environment) {
        super.init(nibName: nil, bundle: nil)
        selectorView = SelectorView()
        selectorView.assignViews([env.navigationViewConroller().view,
                                  env.statusViewController().view], forItem: .mission)
        selectorView.assignViews([env.consoleViewController().view], forItem: .status)
        selectorView.delegate = self
        view = selectorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Handle view updates
extension SelectorViewController : SelectorViewDelegate {
    func tabSelected(_ itemName: SelectorItemName) {
        selectorView.presentView(itemName)
    }
}

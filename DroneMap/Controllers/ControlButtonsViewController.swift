//
//  ControlButtonsViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 14.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class ControlButtonsViewController : UIViewController {
    private var controlButtonsView: ControlButtonsView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        controlButtonsView = ControlButtonsView()
        controlButtonsView.addDelegate(self)
        view = controlButtonsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Public methods
extension ControlButtonsViewController {
    func showView(_ show: Bool) {
        controlButtonsView.show(show)
    }
}

// Subscribe to view updates
extension ControlButtonsViewController : ControlButtonsViewDelegate {
    func buttonPressed(_ id: ControlButtonId) {
        switch id {
            default:
                break
        }
    }

    func animationCompleted() {}
}

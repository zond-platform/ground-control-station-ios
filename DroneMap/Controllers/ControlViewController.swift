//
//  ControlViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 14.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class ControlViewController : UIViewController {
    private var controlView: ControlView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        controlView = ControlView()
        controlView.addDelegate(self)
        view = controlView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Public methods
extension ControlViewController {
    func showView(_ show: Bool) {
        controlView.show(show)
    }
}

// Subscribe to view updates
extension ControlViewController : ControlViewDelegate {
    func buttonPressed(_ id: ControlButtonId) {
        switch id {
            default:
                break
        }
    }

    func animationCompleted() {}
}

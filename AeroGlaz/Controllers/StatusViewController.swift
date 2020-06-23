//
//  StatusViewController.swift
//  Aeroglaz
//
//  Created by Evgeny Agamirzov on 23.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class StatusViewController : UIViewController {
    private var statusView: StatusView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        statusView = StatusView()
        registerListeners()
        view = statusView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Private methods
extension StatusViewController {
    private func registerListeners() {
        Environment.telemetryService.telemetryDataChanged = { id, value in
            self.statusView.updateData(id, value)
        }
    }
}

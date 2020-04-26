//
//  ConsoleViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 18.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class ConsoleViewController : UIViewController {
    private var consoleView: ConsoleView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        consoleView = ConsoleView()
        Environment.commandService.logMessage = { message, type in
            self.consoleView.logMessage(message, type)
        }
        view = consoleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

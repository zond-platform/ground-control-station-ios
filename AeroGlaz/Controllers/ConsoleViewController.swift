//
//  ConsoleViewController.swift
//  Aeroglaz
//
//  Created by Evgeny Agamirzov on 18.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import os.log

import UIKit

class ConsoleViewController : UIViewController {
    private var consoleView: ConsoleView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        consoleView = ConsoleView()
        registerListeners()
        view = consoleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Private methods
extension ConsoleViewController {
    private func registerListeners() {
        Environment.commandService.logConsole = { message, type in
            self.logConsole(message, type)
        }
        Environment.mapViewController.logConsole = { message, type in
            self.logConsole(message, type)
        }
        Environment.simulatorService.logConsole = { message, type in
            self.logConsole(message, type)
        }
        Environment.connectionService.logConsole = { message, type in
            self.logConsole(message, type)
        }
    }

    func currentDateString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }

    private func logConsole(_ message: String, _ type: OSLogType) {
        self.consoleView.logMessage(currentDateString() + "\t" + message, type)
    }
}

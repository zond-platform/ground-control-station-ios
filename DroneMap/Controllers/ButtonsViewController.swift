//
//  ButtonsViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 14.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class ButtonsViewController : UIViewController {
    private var env: Environment!
    private var buttonsView: ButtonsView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ env: Environment) {
        super.init(nibName: nil, bundle: nil)

        self.env = env
        buttonsView = ButtonsView()
        view = buttonsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

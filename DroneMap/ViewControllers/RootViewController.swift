//
//  RootViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/24/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

/*************************************************************************************************/
class RootViewController : UIViewController {
    var rootView: RootView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(_ env: Environment) {
        super.init(nibName: nil, bundle: nil)
        rootView = RootView(env.mapViewController().view,
                            env.navigationViewConroller().view,
                            env.consoleStatusViewController().view,
                            env.consoleLogViewController().view)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showConsoleView(_ show: Bool) {
        rootView.showConsoleView(show);
    }
}

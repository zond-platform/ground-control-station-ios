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
                            env.statusViewController().view,
                            env.consoleViewController().view)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showTabView(_ show: Bool) {
        rootView.showTabView(show);
    }
}

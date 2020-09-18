//
//  RootViewController.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 4/24/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class RootViewController : UIViewController {
    private var rootView: RootView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        rootView = RootView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

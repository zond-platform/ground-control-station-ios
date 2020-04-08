//
//  SettingsViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/6/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

fileprivate var settingsData = [
    SettingsSectionData(id: .simulator,
                        entries: [SettingsCellData(id: .simulator, type: .switcher, value: false)]),
    SettingsSectionData(id: .mission,
                        entries: [SettingsCellData(id: .edit,      type: .switcher, value: false),
                                  SettingsCellData(id: .altitude,  type: .slider,   value: 0.0),
                                  SettingsCellData(id: .distance,  type: .slider,   value: 0.0),
                                  SettingsCellData(id: .upload,    type: .button,   value: false)]),
    SettingsSectionData(id: .status,
                        entries: [SettingsCellData(id: .model,     type: .info,     value: "N/A"),
                                  SettingsCellData(id: .altitude,  type: .info,     value: "N/A"),
                                  SettingsCellData(id: .battery,   type: .info,     value: "N/A")])
]

class SettingsViewController : UIViewController {
    private var settingsView: SettingsView!
    private var dataSource: SettingsViewDataSource!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ env: Environment) {
        super.init(nibName: nil, bundle: nil)

        settingsView = SettingsView()
        dataSource = SettingsViewDataSource(env, settingsView, settingsData)
        settingsView.dataSource = dataSource
        view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Subscribe to table view updates
extension SettingsViewController : UITableViewDelegate {
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

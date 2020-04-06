//
//  SettingsViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/6/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

struct Model {
    static let data = [
        SettingsSection(title: "",
                        cellData: [SettingType.Switch(text: "Simulator")]),
        SettingsSection(title: "Mission",
                        cellData: [SettingType.Switch(text: "Edit Mode"),
                                   SettingType.Tune(text: "Altitude"),
                                   SettingType.Tune(text: "Distance"),
                                   SettingType.Segue(text: "Upload")]),
        SettingsSection(title: "Status",
                        cellData: [SettingType.Info(text: "Model", detail: "Phantom 4 V2"),
                                   SettingType.Info(text: "Altitude", detail: "10m"),
                                   SettingType.Info(text: "Battery", detail: "48%"),
                                   SettingType.Info(text: "GPS Sattelites", detail: "8"),
                                   SettingType.Info(text: "GPS Signal", detail: "Very Good")])
    ]
}

class SettingsViewController : UIViewController {
    var settingsView: SettingsView!
    let dataSource = SettingsViewDataSource(sections: Model.data)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ env: Environment) {
        super.init(nibName: nil, bundle: nil)
        settingsView = SettingsView()
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

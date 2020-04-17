//
//  SettingsViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/6/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

fileprivate var settingsData = [
    SettingsSection(id: .simulator,
                    entries: [SettingsCell(id: .simulator,  type: .switcher, enabled: false,  value: false)]),
    SettingsSection(id: .mission,
                    entries: [SettingsCell(id: .edit,       type: .switcher, enabled: true,  value: false),
                              SettingsCell(id: .altitude,   type: .slider,   enabled: false, value: 0.0),
                              SettingsCell(id: .distance,   type: .slider,   enabled: false, value: 0.0),
                              SettingsCell(id: .upload,     type: .button,   enabled: false, value: false)]),
    SettingsSection(id: .status,
                    entries: [SettingsCell(id: .model,      type: .info,     enabled: true,  value: "-"),
                              SettingsCell(id: .mode,       type: .info,     enabled: true,  value: "-"),
                              SettingsCell(id: .altitude,   type: .info,     enabled: true,  value: "-"),
                              SettingsCell(id: .battery,    type: .info,     enabled: true,  value: "-"),
                              SettingsCell(id: .signal,     type: .info,     enabled: true,  value: "-"),
                              SettingsCell(id: .satellites, type: .info,     enabled: true,  value: "-")])
]

class SettingsViewController : UIViewController {
    private var settingsView: SettingsView!
    private var dataSource: SettingsViewDataSource!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        settingsView = SettingsView()
        dataSource = SettingsViewDataSource(settingsView, settingsData)
        settingsView.tableView.dataSource = dataSource
        settingsView.tableView.delegate = self
        view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Subscribe to table view updates
extension SettingsViewController : UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry: SettingsCell = settingsData[indexPath.section].entries[indexPath.row]
        if entry.id == .upload {
            let coordinates = Environment.mapViewController.missionCoordinates()
            if Environment.commandService.setMissionCoordinates(coordinates) {
                Environment.commandService.executeMissionCommand(.upload)
            }
            settingsView.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

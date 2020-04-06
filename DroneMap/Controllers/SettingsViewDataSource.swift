//
//  SettingsViewDataSource.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 06.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum SettingType {
    case Switch(text: String)
    case Segue(text: String)
    case Info(text: String, detail: String)
    case Tune(text: String)

    var identifier: String {
        switch self {
            case .Info: return "infoCell"
            case .Segue: return "segueCell"
            case .Switch: return "switchCell"
            case .Tune: return "tuneCell"
        }
    }
}

struct SettingsSection {
    var title: String?
    var cellData: [SettingType]

    init(title: String?, cellData: [SettingType]) {
        self.title = title
        self.cellData = cellData
    }
}

class SettingsViewDataSource : NSObject, UITableViewDataSource {
    var sections: [SettingsSection]

    init(sections: [SettingsSection]) {
        self.sections = sections
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cellData.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting: SettingType = sections[indexPath.section].cellData[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: setting.identifier)
        switch setting {
            case .Switch(text: let text):
                cell.textLabel?.text = text
                cell.accessoryType = .detailButton
                cell.accessoryView = UISwitch()
            case .Segue(text: let text):
                cell.textLabel?.text = text
                cell.accessoryType = .disclosureIndicator
            case .Info(text: let text, detail: let detailText):
                cell.textLabel?.text = text
                cell.detailTextLabel?.text = detailText
            case .Tune(text: let text):
                cell.textLabel?.text = text
                cell.accessoryType = .detailButton
                cell.accessoryView = UISlider()
        }
        return cell
    }
}

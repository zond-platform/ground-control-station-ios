//
//  SettingsViewDataSource.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 06.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class SettingsViewDataSource : NSObject {
    private var env: Environment!
    private var settingsView: SettingsView!
    private var sections: [SettingsSectionData] = []

    init(_ env: Environment, _ settingsView: SettingsView, _ sections: [SettingsSectionData]) {
        super.init()
        
        self.env = env
        self.settingsView = settingsView
        self.sections = sections
        env.simulatorService().addDelegate(self)
        env.batteryService().addDelegate(self)
        env.productService().addDelegate(self)
        env.locationService().addDelegate(self)
    }
}

// Private methods
extension SettingsViewDataSource {
    private func updateCellValue<ValueType>(sectionId: SectionId, cellId: CellId, with value: ValueType) {
        sections.first(where: {$0.id == sectionId})?.entries.first(where: {$0.id == cellId})?.value = value
        settingsView.reloadData()
    }
}

// Handle table view updates
extension SettingsViewDataSource : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].entries.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry: SettingsCellData = sections[indexPath.section].entries[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: entry.type.reuseIdentifier)
        switch entry.type {
            case .button:
                cell.textLabel?.text = entry.title
                cell.accessoryType = .disclosureIndicator
            case .info:
                cell.textLabel?.text = entry.title
                cell.detailTextLabel?.text = entry.value as? String
                cell.selectionStyle = .none
            case .slider:
                cell.textLabel?.text = entry.title
                cell.accessoryType = .detailButton
                cell.selectionStyle = .none

                // Configure acessory view
                let slider = UISlider()
                switch entry.id {
                    case .altitude:
                        slider.addTarget(self, action: #selector(onAltitudeSliderMoved(_:)), for: .touchUpInside)
                        
                    case .distance:
                        slider.addTarget(self, action: #selector(onDistanceSliderMoved(_:)), for: .touchUpInside)
                    default:
                        break
                }
                slider.value = entry.value as? Float ?? 0.0
                cell.accessoryView = slider
            case .switcher:
                cell.textLabel?.text = entry.title
                cell.accessoryType = .detailButton
                cell.selectionStyle = .none

                // Configure acessory view
                let switcher = UISwitch()
                switch entry.id {
                    case .simulator:
                        switcher.addTarget(self, action: #selector(onSimulatorSwitchTriggered(_:)), for: .valueChanged)
                    case .edit:
                        switcher.addTarget(self, action: #selector(onEditMissionSwitchTriggered(_:)), for: .valueChanged)
                    default:
                        break
                }
                switcher.isOn = entry.value as? Bool ?? false
                cell.accessoryView = switcher
        }
        return cell
    }
}

// Handle control events
extension SettingsViewDataSource {
    @objc private func onSimulatorSwitchTriggered(_ sender: UISwitch) {
        sender.isOn ? env.simulatorService().startSimulator(nil)
                    : env.simulatorService().stopSimulator()
    }

    @objc private func onEditMissionSwitchTriggered(_ sender: UISwitch) {
        updateCellValue(sectionId: .mission, cellId: .edit, with: sender.isOn)
        env.mapViewController().enableMissionEditing(sender.isOn)
    }

    @objc private func onAltitudeSliderMoved(_ sender: UISlider) {
        updateCellValue(sectionId: .mission, cellId: .altitude, with: sender.value)
        print("Altitude: \(sender.value)")
    }

    @objc private func onDistanceSliderMoved(_ sender: UISlider) {
        updateCellValue(sectionId: .mission, cellId: .distance, with: sender.value)
        print("Distance: \(sender.value)")
    }
}

// Subscribe to simulator updates
extension SettingsViewDataSource : SimulatorServiceDelegate {
    func simulatorStarted(_ success: Bool) {
        updateCellValue(sectionId: .simulator, cellId: .simulator, with: success)
    }

    func simulatorStopped(_ success: Bool) {
        updateCellValue(sectionId: .simulator, cellId: .simulator, with: !success)
    }
}

// Subscribe to battery status updates
extension SettingsViewDataSource : BatteryServiceDelegate {
    func batteryChargeChanged(_ charge: UInt) {
        // TODO: Log battery status
    }
}

// Subscribe to location updates
extension SettingsViewDataSource : LocationServiceDelegate {
    // TODO: Decide which location data is relevant
}

// Subscribe to connected product updates
extension SettingsViewDataSource : ProductServiceDelegate {
    func modelChanged(_ model: String) {
        // TODO: Disable controls if product is not a flying object
    }
}

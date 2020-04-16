//
//  SettingsViewDataSource.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 06.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import os.log

import CoreLocation
import DJISDK
import UIKit

class SettingsViewDataSource : NSObject {
    private var env: Environment!
    private var settingsView: SettingsView!
    private var sections: [SettingsSection]!
    private var aircraftConnected: Bool!
    private var editingEnabled: Bool!

    init(_ env: Environment, _ settingsView: SettingsView, _ sections: [SettingsSection]) {
        super.init()
        
        self.env = env
        self.settingsView = settingsView
        self.sections = sections
        self.aircraftConnected = false
        self.editingEnabled = false
        env.simulatorService().addDelegate(self)
        env.batteryService().addDelegate(self)
        env.productService().addDelegate(self)
        env.locationService().addDelegate(self)
    }
}

// Private methods
extension SettingsViewDataSource {
    private func indexPath(_ section: SectionId, _ cell: CellId) -> IndexPath? {
        if let sectionIndex = sections.firstIndex(where: {$0.id == section}) {
            if let cellIndex = sections[sectionIndex].entries.firstIndex(where: {$0.id == cell}) {
                return IndexPath(row: cellIndex, section: sectionIndex)
            }
        }
        return nil
    }

    private func updateCell<ValueType>(value: ValueType, section: SectionId, cell: CellId, reload: Bool) {
        if let indexPath = indexPath(section, cell) {
            sections[indexPath.section].entries[indexPath.row].value = value
            if reload {
                settingsView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }

    private func enableCell(_ enable: Bool, section: SectionId, cell: CellId) {
        if let indexPath = indexPath(section, cell) {
            sections[indexPath.section].entries[indexPath.row].enabled = enable
            settingsView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

// Handle table view updates
extension SettingsViewDataSource : UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].entries.count
    }

    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry: SettingsCell = sections[indexPath.section].entries[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: entry.type.reuseIdentifier)
        switch entry.type {
            case .button:
                cell.textLabel?.text = entry.title
                cell.textLabel?.textColor = UIColor.blue
                cell.accessoryType = .none
            case .info:
                cell.selectionStyle = .none
                cell.textLabel?.text = entry.title
                cell.detailTextLabel?.text = entry.value as? String
            case .slider:
                let slider = UISlider()
                switch entry.id {
                    case .altitude:
                        slider.minimumValue = 20
                        slider.maximumValue = 200
                        slider.addTarget(self, action: #selector(onAltitudeSliderMoved(_:)), for: .touchUpInside)
                    case .distance:
                        slider.minimumValue = 10
                        slider.maximumValue = 50
                        slider.addTarget(self, action: #selector(onDistanceSliderMoved(_:)), for: .touchUpInside)
                    default:
                        break
                }
                slider.value = entry.value as? Float ?? 0.0
                cell.selectionStyle = .none
                cell.textLabel?.text = entry.title
                cell.detailTextLabel?.text = String(format: "%.0f m", slider.value)
                cell.accessoryView = slider
            case .switcher:
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
                cell.selectionStyle = .none
                cell.textLabel?.text = entry.title
                cell.accessoryView = switcher
        }
        cell.isUserInteractionEnabled = entry.enabled
        if !entry.enabled {
            cell.textLabel?.textColor = UIColor.lightGray
            cell.detailTextLabel?.textColor = UIColor.lightGray
        }
        return cell
    }
}

// Handle control events
extension SettingsViewDataSource {
    @objc private func onSimulatorSwitchTriggered(_ sender: UISwitch) {
        let userLocation = env.mapViewController().userLocation()
        sender.isOn ? env.simulatorService().startSimulator(userLocation)
                    : env.simulatorService().stopSimulator()
    }

    @objc private func onEditMissionSwitchTriggered(_ sender: UISwitch) {
        env.mapViewController().enableMissionEditing(sender.isOn)
        editingEnabled = sender.isOn
        updateCell(value: sender.isOn, section: .mission, cell: .edit, reload: true)
        enableCell(sender.isOn, section: .mission, cell: .altitude)
        enableCell(sender.isOn, section: .mission, cell: .distance)
        enableCell(aircraftConnected && editingEnabled, section: .mission, cell: .upload)
        enableCell(aircraftConnected && editingEnabled, section: .mission, cell: .start)
        enableCell(aircraftConnected && editingEnabled, section: .mission, cell: .stop)
    }

    @objc private func onAltitudeSliderMoved(_ sender: UISlider) {
        updateCell(value: sender.value, section: .mission, cell: .altitude, reload: true)
    }

    @objc private func onDistanceSliderMoved(_ sender: UISlider) {
        updateCell(value: sender.value, section: .mission, cell: .distance, reload: true)
        env.mapViewController().gridDistance = CGFloat(sender.value)
    }
}

// Subscribe to simulator updates
extension SettingsViewDataSource : SimulatorServiceDelegate {
    internal func simulatorStarted(_ success: Bool) {
        // No neet to reload the cell, UISwitch has already changed the state
        updateCell(value: success, section: .simulator, cell: .simulator, reload: false)
    }

    internal func simulatorStopped(_ success: Bool) {
        // No neet to reload the cell, UISwitch has already changed the state
        updateCell(value: !success, section: .simulator, cell: .simulator, reload: false)
    }
}

// Subscribe to battery status updates
extension SettingsViewDataSource : BatteryServiceDelegate {
    internal func batteryChargeChanged(_ charge: UInt?) {
        let stringValue = charge != nil ? String(charge!) : "-"
        updateCell(value: stringValue, section: .status, cell: .battery, reload: true)
    }
}

// Subscribe to location updates
extension SettingsViewDataSource : LocationServiceDelegate {
    internal func signalStatusChanged(_ status: String?) {
        let stringValue = status ?? "-"
        updateCell(value: stringValue, section: .status, cell: .signal, reload: true)
    }

    internal func satelliteCountChanged(_ count: UInt?) {
        let stringValue = count != nil ? String(format: "%.1f", count!) : "-"
        updateCell(value: stringValue, section: .status, cell: .satellites, reload: true)
    }

    internal func altitudeChanged(_ count: UInt?) {
        let stringValue = count != nil ? String(count!) : "-"
        updateCell(value: stringValue, section: .status, cell: .altitude, reload: true)
    }

    internal func flightModeChanged(_ mode: String?) {
        let stringValue = mode ?? "-"
        updateCell(value: stringValue, section: .status, cell: .mode, reload: true)
    }
}

// Subscribe to connected product updates
extension SettingsViewDataSource : ProductServiceDelegate {
    internal func modelChanged(_ model: String?) {
        aircraftConnected = model != nil && model != DJIAircraftModeNameOnlyRemoteController
        if !aircraftConnected {
            updateCell(value: false, section: .simulator, cell: .simulator, reload: true)
        }
        updateCell(value: model ?? "-", section: .status, cell: .model, reload: true)
        enableCell(aircraftConnected, section: .simulator, cell: .simulator)
        enableCell(aircraftConnected && editingEnabled, section: .mission, cell: .upload)
        enableCell(aircraftConnected && editingEnabled, section: .mission, cell: .start)
        enableCell(aircraftConnected && editingEnabled, section: .mission, cell: .stop)
    }
}

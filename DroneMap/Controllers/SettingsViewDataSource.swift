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
    private var sections: [SettingsSectionData]!
    private var aircraftConnected: Bool!
    private var editingEnabled: Bool!

    init(_ env: Environment, _ settingsView: SettingsView, _ sections: [SettingsSectionData]) {
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
    private func indexPath(for sectionId: SectionId, and cellId: CellId) -> IndexPath? {
        if let sectionIndex = sections.firstIndex(where: {$0.id == sectionId}) {
            if let cellIndex = sections[sectionIndex].entries.firstIndex(where: {$0.id == cellId}) {
                return IndexPath(row: cellIndex, section: sectionIndex)
            }
        }
        return nil
    }

    private func updateCell<ValueType>(value: ValueType, sectionId: SectionId, cellId: CellId) {
        if let indexPath = indexPath(for: sectionId, and: cellId) {
            sections[indexPath.section].entries[indexPath.row].value = value
            settingsView.reloadRows(at: [indexPath], with: .none)
        }
    }

    private func enableCell(_ enable: Bool, sectionId: SectionId, cellId: CellId) {
        if let indexPath = indexPath(for: sectionId, and: cellId) {
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
        let entry: SettingsCellData = sections[indexPath.section].entries[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: entry.type.reuseIdentifier)
        switch entry.type {
            case .button:
                cell.textLabel?.text = entry.title
                cell.accessoryType = .disclosureIndicator
            case .info:
                cell.selectionStyle = .none
                cell.textLabel?.text = entry.title
                cell.detailTextLabel?.text = entry.value as? String
            case .slider:
                let slider = UISlider()
                // TODO: Fix stuck slider when updating cell on every value change
                switch entry.id {
                    case .altitude:
                        slider.minimumValue = 20
                        slider.maximumValue = 200
                        slider.addTarget(self, action: #selector(onAltitudeSliderFinishedMoving(_:)), for: .touchUpInside)
                        slider.addTarget(self, action: #selector(onAltitudeSliderMoved(_:)), for: .valueChanged)
                    case .distance:
                        slider.minimumValue = 10
                        slider.maximumValue = 50
                        slider.addTarget(self, action: #selector(onDistanceSliderFinishedMoving(_:)), for: .touchUpInside)
                        slider.addTarget(self, action: #selector(onDistanceSliderMoved(_:)), for: .valueChanged)
                    default:
                        break
                }
//                slider.value = entry.value as? Float ?? 0.0
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
        cell.textLabel?.textColor = entry.enabled ? UIColor.black : UIColor.gray
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
        updateCell(value: sender.isOn, sectionId: .mission, cellId: .edit)
        enableCell(sender.isOn, sectionId: .mission, cellId: .altitude)
        enableCell(sender.isOn, sectionId: .mission, cellId: .distance)
        enableCell(aircraftConnected && editingEnabled, sectionId: .mission, cellId: .upload)
    }

    @objc private func onAltitudeSliderFinishedMoving(_ sender: UISlider) {
        updateCell(value: sender.value, sectionId: .mission, cellId: .altitude)
    }

    @objc private func onDistanceSliderFinishedMoving(_ sender: UISlider) {
        updateCell(value: sender.value, sectionId: .mission, cellId: .distance)
    }

    @objc private func onAltitudeSliderMoved(_ sender: UISlider) {
        //
    }

    @objc private func onDistanceSliderMoved(_ sender: UISlider) {
        env.mapViewController().gridDistance = CGFloat(sender.value)
    }
}

// Subscribe to simulator updates
extension SettingsViewDataSource : SimulatorServiceDelegate {
    internal func simulatorStarted(_ success: Bool) {
        updateCell(value: success, sectionId: .simulator, cellId: .simulator)
    }

    internal func simulatorStopped(_ success: Bool) {
        updateCell(value: !success, sectionId: .simulator, cellId: .simulator)
    }
}

// Subscribe to battery status updates
extension SettingsViewDataSource : BatteryServiceDelegate {
    internal func batteryChargeChanged(_ charge: UInt?) {
        let stringValue = charge != nil ? String(charge!) : "-"
        updateCell(value: stringValue, sectionId: .status, cellId: .battery)
    }
}

// Subscribe to location updates
extension SettingsViewDataSource : LocationServiceDelegate {
    internal func signalStatusChanged(_ status: String?) {
        let stringValue = status ?? "-"
        updateCell(value: stringValue, sectionId: .status, cellId: .signal)
    }

    internal func satelliteCountChanged(_ count: UInt?) {
        let stringValue = count != nil ? String(format: "%.1f", count!) : "-"
        updateCell(value: stringValue, sectionId: .status, cellId: .satellites)
    }

    internal func altitudeChanged(_ count: UInt?) {
        let stringValue = count != nil ? String(format: "%.1f", count!) : "-"
        updateCell(value: stringValue, sectionId: .status, cellId: .altitude)
    }

    internal func flightModeChanged(_ mode: String?) {
        let stringValue = mode ?? "-"
        updateCell(value: stringValue, sectionId: .status, cellId: .mode)
    }
}

// Subscribe to connected product updates
extension SettingsViewDataSource : ProductServiceDelegate {
    internal func modelChanged(_ model: String?) {
        aircraftConnected = model != nil && model != DJIAircraftModeNameOnlyRemoteController
        if !aircraftConnected {
            updateCell(value: false, sectionId: .simulator, cellId: .simulator)
        }
        updateCell(value: model ?? "-", sectionId: .status, cellId: .model)
        enableCell(aircraftConnected, sectionId: .simulator, cellId: .simulator)
        enableCell(aircraftConnected && editingEnabled, sectionId: .mission, cellId: .upload)
    }
}

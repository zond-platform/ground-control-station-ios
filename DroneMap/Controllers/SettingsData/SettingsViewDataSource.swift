//
//  SettingsDataSource.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 06.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import os.log

import CoreLocation
import DJISDK
import UIKit

class SettingsDataSource : NSObject {
    private var settingsView: SettingsView!
    private var sections: [SettingsSection]!
    private var aircraftConnected: Bool!
    private var editingEnabled: Bool!

    init(_ settingsView: SettingsView, _ sections: [SettingsSection]) {
        super.init()
        self.settingsView = settingsView
        self.sections = sections
        self.aircraftConnected = false
        self.editingEnabled = false
        Environment.simulatorService.addDelegate(self)
        Environment.batteryService.addDelegate(self)
        Environment.productService.addDelegate(self)
        Environment.locationService.addDelegate(self)
        settingsView.tableView.register(SectionHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        settingsView.tableView.register(SectionFooter.self, forHeaderFooterViewReuseIdentifier: "sectionFooter")
    }
}

// Private methods
extension SettingsDataSource {
    private func indexPath(_ section: SectionId, _ cell: CellId) -> IndexPath? {
        if let sectionIndex = sections.firstIndex(where: {$0.id == section}) {
            if let cellIndex = sections[sectionIndex].entries.firstIndex(where: {$0.id == cell}) {
                return IndexPath(row: cellIndex, section: sectionIndex)
            }
        }
        return nil
    }

    private func updateCell<ValueType>(value: ValueType, section: SectionId, cell: CellId) {
        if let indexPath = indexPath(section, cell) {
            sections[indexPath.section].entries[indexPath.row].value = value
            let cell = settingsView.tableView.cellForRow(at: indexPath)
            let dataEntry = sections[indexPath.section].entries[indexPath.row]
            setupCell(cell!, dataEntry)
        }
    }

    private func enableCell(_ enable: Bool, section: SectionId, cell: CellId) {
        if let indexPath = indexPath(section, cell) {
            sections[indexPath.section].entries[indexPath.row].enabled = enable
            let cell = settingsView.tableView.cellForRow(at: indexPath)
            let dataEntry = sections[indexPath.section].entries[indexPath.row]
            setupCell(cell!, dataEntry)
        }
    }

    private func setupCell(_ cell: UITableViewCell, _ dataEntry: SettingsCell<Any>) {
        cell.isUserInteractionEnabled = dataEntry.enabled
        switch dataEntry.type {
            case .button:
                setupButtonCell(cell, dataEntry)
            case .info:
                setupInfoCell(cell, dataEntry)
            case .slider:
                setupSliderCell(cell, dataEntry)
            case .switcher:
                setupSwitcherCell(cell, dataEntry)
        }
    }

    private func setupInfoCell(_ cell: UITableViewCell, _ dataEntry: SettingsCell<Any>) {
        cell.textLabel?.text = dataEntry.title
        cell.textLabel?.textColor = cell.isUserInteractionEnabled ? UIColor.black : UIColor.lightGray
        cell.detailTextLabel?.text = dataEntry.value as? String
        cell.detailTextLabel?.textColor = cell.isUserInteractionEnabled ? UIColor.gray : UIColor.lightGray
        cell.selectionStyle = .none
        cell.accessoryType = .none
    }

    private func setupButtonCell(_ cell: UITableViewCell, _ dataEntry: SettingsCell<Any>) {
        cell.textLabel?.text = dataEntry.title
        cell.textLabel?.textColor = cell.isUserInteractionEnabled ? UIColor.blue : UIColor.lightGray
        cell.accessoryType = .none
    }

    private func setupSliderCell(_ cell: UITableViewCell, _ dataEntry: SettingsCell<Any>) {
        if cell.accessoryView == nil {
            let slider = UISlider()
            switch dataEntry.id {
                case .altitude:
                    slider.minimumValue = 20
                    slider.maximumValue = 200
                    slider.addTarget(self, action: #selector(onAltitudeSliderMoved(_:)), for: .valueChanged)
                case .distance:
                    slider.minimumValue = 10
                    slider.maximumValue = 50
                    slider.addTarget(self, action: #selector(onDistanceSliderMoved(_:)), for: .valueChanged)
                default:
                    break
            }
            slider.value = dataEntry.value as? Float ?? 0.0
            cell.accessoryView = slider
        }
        cell.textLabel?.text = dataEntry.title
        cell.textLabel?.textColor = cell.isUserInteractionEnabled ? UIColor.black : UIColor.lightGray
        cell.detailTextLabel?.text = String(format: "%.0f m", (cell.accessoryView as! UISlider).value)
        cell.detailTextLabel?.textColor = cell.isUserInteractionEnabled ? UIColor.gray : UIColor.lightGray
        cell.selectionStyle = .none
    }

    private func setupSwitcherCell(_ cell: UITableViewCell, _ dataEntry: SettingsCell<Any>) {
        let switcher = UISwitch()
        switch dataEntry.id {
            case .simulator:
                switcher.addTarget(self, action: #selector(onSimulatorSwitchTriggered(_:)), for: .valueChanged)
            case .edit:
                switcher.addTarget(self, action: #selector(onEditMissionSwitchTriggered(_:)), for: .valueChanged)
            default:
                break
        }
        switcher.isOn = dataEntry.value as? Bool ?? false
        cell.textLabel?.text = dataEntry.title
        cell.textLabel?.textColor = cell.isUserInteractionEnabled ? UIColor.black : UIColor.lightGray
        cell.accessoryView = switcher
        cell.selectionStyle = .none
    }
}

// Handle table view updates
extension SettingsDataSource : UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return AppDimensions.Settings.rowHeight
    }

    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppDimensions.Settings.rowHeight
    }

    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AppDimensions.Settings.sectionHeaderHeight
    }

    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return AppDimensions.Settings.sectionFooterHeight
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry: SettingsCell = sections[indexPath.section].entries[indexPath.row]
        if entry.id == .upload {
            let coordinates = Environment.mapViewController.missionCoordinates()
            if Environment.commandService.setMissionCoordinates(coordinates) {
                Environment.commandService.executeMissionCommand(.upload)
            }
            settingsView.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = settingsView.tableView.dequeueReusableHeaderFooterView(withIdentifier:
                    "sectionHeader") as! SectionHeader
        view.title.text = sections[section].title
        return view
    }

    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
                let view = settingsView.tableView.dequeueReusableHeaderFooterView(withIdentifier:
                    "sectionFooter") as! SectionFooter
        view.title.text = sections[section].message
        return view
    }
}

// Handle table view data source updates
extension SettingsDataSource : UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].entries.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataEntry: SettingsCell = sections[indexPath.section].entries[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: dataEntry.type.reuseIdentifier)
        cell.isUserInteractionEnabled = dataEntry.enabled
        cell.contentView.backgroundColor = AppColor.Overlay.semiTransparentWhite
        cell.textLabel?.font = AppFont.normalFont
        cell.detailTextLabel?.font = AppFont.normalFont
        switch dataEntry.type {
            case .button:
                setupButtonCell(cell, dataEntry)
            case .info:
                setupInfoCell(cell, dataEntry)
            case .slider:
                setupSliderCell(cell, dataEntry)
            case .switcher:
                setupSwitcherCell(cell, dataEntry)
        }
        return cell
    }
}

// Handle control events
extension SettingsDataSource {
    @objc private func onSimulatorSwitchTriggered(_ sender: UISwitch) {
        let userLocation = Environment.mapViewController.userLocation()
        sender.isOn ? Environment.simulatorService.startSimulator(userLocation)
                    : Environment.simulatorService.stopSimulator()
    }

    @objc private func onEditMissionSwitchTriggered(_ sender: UISwitch) {
        Environment.mapViewController.enableMissionEditing(sender.isOn)
        editingEnabled = sender.isOn
        updateCell(value: sender.isOn, section: .mission, cell: .edit)
        enableCell(sender.isOn, section: .mission, cell: .altitude)
        enableCell(sender.isOn, section: .mission, cell: .distance)
        enableCell(aircraftConnected && editingEnabled, section: .mission, cell: .upload)
    }

    @objc private func onAltitudeSliderMoved(_ sender: UISlider) {
        updateCell(value: sender.value, section: .mission, cell: .altitude)
    }

    @objc private func onDistanceSliderMoved(_ sender: UISlider) {
        updateCell(value: sender.value, section: .mission, cell: .distance)
        Environment.mapViewController.gridDistance = CGFloat(sender.value)
    }
}

// Subscribe to simulator updates
extension SettingsDataSource : SimulatorServiceDelegate {
    internal func simulatorStarted(_ success: Bool) {
        // No neet to reload the cell, UISwitch has already changed the state
        updateCell(value: success, section: .simulator, cell: .simulator)
    }

    internal func simulatorStopped(_ success: Bool) {
        // No neet to reload the cell, UISwitch has already changed the state
        updateCell(value: !success, section: .simulator, cell: .simulator)
    }
}

// Subscribe to battery status updates
extension SettingsDataSource : BatteryServiceDelegate {
    internal func batteryChargeChanged(_ charge: UInt?) {
        let stringValue = charge != nil ? String(charge!) : "-"
        updateCell(value: stringValue, section: .status, cell: .battery)
    }
}

// Subscribe to location updates
extension SettingsDataSource : LocationServiceDelegate {
    internal func signalStatusChanged(_ status: String?) {
        let stringValue = status ?? "-"
        updateCell(value: stringValue, section: .status, cell: .signal)
    }

    internal func satelliteCountChanged(_ count: UInt?) {
        let stringValue = count != nil ? String(count!) : "-"
        updateCell(value: stringValue, section: .status, cell: .satellites)
    }

    internal func altitudeChanged(_ count: UInt?) {
        let stringValue = count != nil ? String(count!) : "-"
        updateCell(value: stringValue, section: .status, cell: .altitude)
    }

    internal func flightModeChanged(_ mode: String?) {
        let stringValue = mode ?? "-"
        updateCell(value: stringValue, section: .status, cell: .mode)
    }
}

// Subscribe to connected product updates
extension SettingsDataSource : ProductServiceDelegate {
    internal func modelChanged(_ model: String?) {
        aircraftConnected = model != nil && model != DJIAircraftModeNameOnlyRemoteController
        if !aircraftConnected {
            updateCell(value: false, section: .simulator, cell: .simulator)
        }
        updateCell(value: model ?? "-", section: .status, cell: .model)
        enableCell(aircraftConnected, section: .simulator, cell: .simulator)
        enableCell(aircraftConnected && editingEnabled, section: .mission, cell: .upload)
    }
}

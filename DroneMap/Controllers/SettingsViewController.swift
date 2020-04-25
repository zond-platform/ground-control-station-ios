//
//  SettingsViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/6/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK
import UIKit

fileprivate var tableData = SettingsTableData([
    SettingsSectionData(
        id: .simulator,
        entries: [
            SettingsCellData(id: .simulator,  type: .switcher, value: false, isEnabled: false)
        ]),
    SettingsSectionData(
        id: .mission,
        entries: [
            SettingsCellData(id: .edit,          type: .switcher,  value: false, isEnabled: true),
            SettingsCellData(id: .gridDistance,  type: .slider,    value: 0.0,   isEnabled: false),
            SettingsCellData(id: .shootDistance, type: .slider,    value: 0.0,   isEnabled: false),
            SettingsCellData(id: .altitude,      type: .slider,    value: 0.0,   isEnabled: false),
            SettingsCellData(id: .flightSpeed,   type: .slider,    value: 0.0,   isEnabled: false),
            SettingsCellData(id: .upload,        type: .button,    value: false, isEnabled: false)
        ]),
    SettingsSectionData(
        id: .status,
        entries: [
            SettingsCellData(id: .model,      type: .info,      value: "-",   isEnabled: true),
            SettingsCellData(id: .mode,       type: .info,      value: "-",   isEnabled: true),
            SettingsCellData(id: .altitude,   type: .info,      value: "-",   isEnabled: true),
            SettingsCellData(id: .battery,    type: .info,      value: "-",   isEnabled: true),
            SettingsCellData(id: .signal,     type: .info,      value: "-",   isEnabled: true),
            SettingsCellData(id: .satellites, type: .info,      value: "-",   isEnabled: true)
        ])
])

class SettingsViewController : UIViewController {
    private var settingsView: SettingsView!
    private var dataSource: SettingsDataSource!
    private var aircraftConnected: Bool!
    private var editingEnabled: Bool!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        settingsView = SettingsView()
        dataSource = SettingsDataSource(&tableData)
        dataSource.delegate = self
        self.aircraftConnected = false
        self.editingEnabled = false
        settingsView.tableView.dataSource = self.dataSource
        settingsView.tableView.delegate = self
        settingsView.tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(SectionHeaderView.self))
        settingsView.tableView.register(SectionFooterView.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(SectionFooterView.self))
        settingsView.addDelegate(self)
        Environment.simulatorService.addDelegate(self)
        Environment.batteryService.addDelegate(self)
        Environment.productService.addDelegate(self)
        Environment.locationService.addDelegate(self)
        Environment.commandService.addDelegate(self)
        view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Public methods
extension SettingsViewController {
    func showView(_ show: Bool) {
        settingsView.show(show)
    }
}

// Private methods
extension SettingsViewController {
    private func updateCell<ValueType>(at idPath: IdPath, with value: ValueType) {
        if let data = tableData.updateEntry(at: idPath, with: value) {
            if let indexPath = tableData.indexPath(for: idPath) {
                if let cell = settingsView.tableView.cellForRow(at: indexPath) {
                    dataSource.setupCell(cell, data)
                }
            }
        }
    }

    private func enableCell(at idPath: IdPath, _ enable: Bool) {
        if let data = tableData.enableEntry(at: idPath, enable) {
            if let indexPath = tableData.indexPath(for: idPath) {
                if let cell = settingsView.tableView.cellForRow(at: indexPath) {
                    dataSource.setupCell(cell, data)
                }
            }
        }
    }
}

// Handle table view updates
extension SettingsViewController : UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return AppDimensions.Settings.rowHeight
    }

    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppDimensions.Settings.rowHeight
    }

    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableData.height(forHeaderIn: section)
    }

    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableData.height(forFooterIn: section)
    }

    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = settingsView.tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(SectionHeaderView.self)) as! SectionHeaderView
        view.title.text = tableData.title(forHeaderIn: section)
        return view
    }

    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return settingsView.tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(SectionFooterView.self)) as! SectionFooterView
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry: SettingsCellData = tableData.entry(at: indexPath)
        if entry.id == .upload {
//            let flightSpeed = tableData.entryValue(at: IdPath(.mission, .flightSpeed)) as! Float
//            let shootDistance = tableData.entryValue(at: IdPath(.mission, .shootDistance)) as! Float
//            let altitude = tableData.entryValue(at: IdPath(.mission, .altitude)) as! Float
//
//            let parameters = MissionParameters(flightSpeed: flightSpeed, shootDistance: shootDistance, altitude: altitude)
//            if !Environment.commandService.setMissionParameters(parameters) {
//                settingsView.tableView.deselectRow(at: indexPath, animated: true)
//                return
//            }
//            let coordinates = Environment.mapViewController.missionCoordinates()
//            if !Environment.commandService.setMissionCoordinates(coordinates) {
//                settingsView.tableView.deselectRow(at: indexPath, animated: true)
//                return
//            }
//            
//            Environment.commandService.executeMissionCommand(.upload)
//            settingsView.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// Handle data source updates
extension SettingsViewController : SettingsDataSourceDelegate {
    func sliderMoved(at idPath: IdPath, to value: Float) {
        updateCell(at: idPath, with: value)
        switch idPath.cell {
            case .gridDistance:
                Environment.mapViewController.gridDistance = CGFloat(value)
            default:
                break
        }
    }

    func switchTriggered(at idPath: IdPath, _ isOn: Bool) {
        switch idPath.cell {
            case .simulator:
                let userLocation = Environment.mapViewController.userLocation()
                isOn ? Environment.simulatorService.startSimulator(userLocation)
                     : Environment.simulatorService.stopSimulator()
            case .edit:
                Environment.mapViewController.enableMissionEditing(isOn)
                editingEnabled = isOn
                updateCell(at: IdPath(.mission, .edit), with: isOn)
                enableCell(at: IdPath(.mission, .altitude), isOn)
                enableCell(at: IdPath(.mission, .gridDistance), isOn)
                enableCell(at: IdPath(.mission, .shootDistance), isOn)
                enableCell(at: IdPath(.mission, .flightSpeed), isOn)
                enableCell(at: IdPath(.mission, .upload), aircraftConnected && editingEnabled)
            default:
                break
        }
    }
}

// Subscribe to simulator updates
extension SettingsViewController : SimulatorServiceDelegate {
    internal func simulatorStarted(_ success: Bool) {
        updateCell(at: IdPath(.simulator, .simulator), with: success)
    }

    internal func simulatorStopped(_ success: Bool) {
        updateCell(at: IdPath(.simulator, .simulator), with: !success)
    }
}

// Subscribe to battery status updates
extension SettingsViewController : BatteryServiceDelegate {
    internal func batteryChargeChanged(_ charge: UInt?) {
        let stringValue = charge != nil ? String(charge!) : "-"
        updateCell(at: IdPath(.status, .battery), with: stringValue)
    }
}

// Subscribe to location data updates
extension SettingsViewController : LocationServiceDelegate {
    internal func signalStatusChanged(_ status: String?) {
        let stringValue = status ?? "-"
        updateCell(at: IdPath(.status, .signal), with: stringValue)
    }

    internal func satelliteCountChanged(_ count: UInt?) {
        let stringValue = count != nil ? String(count!) : "-"
        updateCell(at: IdPath(.status, .satellites), with: stringValue)
    }

    internal func altitudeChanged(_ count: UInt?) {
        let stringValue = count != nil ? String(count!) : "-"
        updateCell(at: IdPath(.status, .altitude), with: stringValue)
    }

    internal func flightModeChanged(_ mode: String?) {
        let stringValue = mode ?? "-"
        updateCell(at: IdPath(.status, .mode), with: stringValue)
    }
}

// Subscribe to connected product updates
extension SettingsViewController : ProductServiceDelegate {
    internal func modelChanged(_ model: String?) {
        aircraftConnected = model != nil && model != DJIAircraftModeNameOnlyRemoteController
        if !aircraftConnected {
            updateCell(at: IdPath(.simulator, .simulator), with: false)
        }
        updateCell(at: IdPath(.status, .model), with: model ?? "-")
        enableCell(at: IdPath(.simulator, .simulator), aircraftConnected)
        enableCell(at: IdPath(.mission, .upload), aircraftConnected && editingEnabled)
    }
}

// Handle content view updates
extension SettingsViewController : SettingsViewDelegate {
    internal func animationCompleted() {}
}

// Subscribe to command responses
extension SettingsViewController : CommandServiceDelegate {
    func missionCommandResponded(_ commandId: MissionCommandId, _ success: Bool) {
        if success && commandId == .upload {
            editingEnabled = false
            updateCell(at: IdPath(.mission, .edit), with: false)
            enableCell(at: IdPath(.mission, .altitude), false)
            enableCell(at: IdPath(.mission, .gridDistance), false)
            enableCell(at: IdPath(.mission, .shootDistance), false)
            enableCell(at: IdPath(.mission, .flightSpeed), false)
            enableCell(at: IdPath(.mission, .upload), false)
        }
    }
}

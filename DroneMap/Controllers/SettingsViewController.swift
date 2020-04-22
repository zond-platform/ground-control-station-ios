//
//  SettingsViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/6/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK
import UIKit

fileprivate var tableData = TableData([
    TableSectionData(
        id: .simulator,
        entries: [
            TableCellData(id: .simulator,  type: .switcher, value: false, isEnabled: false)
        ]),
    TableSectionData(
        id: .mission,
        entries: [
            TableCellData(id: .edit,       type: .switcher,  value: false, isEnabled: true),
            TableCellData(id: .altitude,   type: .slider,    value: 0.0,   isEnabled: false),
            TableCellData(id: .distance,   type: .slider,    value: 0.0,   isEnabled: false),
            TableCellData(id: .upload,     type: .button,    value: false, isEnabled: false)
        ]),
    TableSectionData(
        id: .status,
        entries: [
            TableCellData(id: .model,      type: .info,      value: "-",   isEnabled: true),
            TableCellData(id: .mode,       type: .info,      value: "-",   isEnabled: true),
            TableCellData(id: .altitude,   type: .info,      value: "-",   isEnabled: true),
            TableCellData(id: .battery,    type: .info,      value: "-",   isEnabled: true),
            TableCellData(id: .signal,     type: .info,      value: "-",   isEnabled: true),
            TableCellData(id: .satellites, type: .info,      value: "-",   isEnabled: true)
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
        if let indexPath = tableData.indexPath(for: idPath) {
            let cell = settingsView.tableView.cellForRow(at: indexPath)
            let data = tableData.updateEntry(at: indexPath, with: value)
            dataSource.setupCell(cell!, data)
        }
    }

    private func enableCell(at idPath: IdPath, _ enable: Bool) {
        if let indexPath = tableData.indexPath(for: idPath) {
            let cell = settingsView.tableView.cellForRow(at: indexPath)
            let data = tableData.enableEntry(at: indexPath, enable)
            dataSource.setupCell(cell!, data)
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
        return AppDimensions.Settings.sectionHeaderHeight
    }

    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return AppDimensions.Settings.sectionFooterHeight
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry: TableCellData = tableData.entry(at: indexPath)
        if entry.id == .upload {
            let coordinates = Environment.mapViewController.missionCoordinates()
            if Environment.commandService.setMissionCoordinates(coordinates) {
                Environment.commandService.executeMissionCommand(.upload)
            }
            settingsView.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = settingsView.tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(SectionHeaderView.self)) as! SectionHeaderView
        view.title.text = tableData.title(forHeaderIn: section)
        return view
    }

    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = settingsView.tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(SectionFooterView.self)) as! SectionFooterView
        view.title.text = tableData.text(forFooterIn: section)
        return view
    }
}

// Handle data source updates
extension SettingsViewController : DataSourceDelegate {
    func sliderMoved(at indexPath: IndexPath, with value: Float) {
        switch tableData.entry(at: indexPath).id {
            case .altitude:
                updateCell(at: IdPath(.mission, .altitude), with: value)
            case .distance:
                updateCell(at: IdPath(.mission, .distance), with: value)
                Environment.mapViewController.gridDistance = CGFloat(value)
            default:
                break
        }
    }

    func switchTriggered(at indexPath: IndexPath, _ isOn: Bool) {
        switch tableData.entry(at: indexPath).id {
            case .simulator:
                let userLocation = Environment.mapViewController.userLocation()
                isOn ? Environment.simulatorService.startSimulator(userLocation)
                     : Environment.simulatorService.stopSimulator()
            case .edit:
                Environment.mapViewController.enableMissionEditing(isOn)
                editingEnabled = isOn
                updateCell(at: IdPath(.mission, .edit), with: isOn)
                enableCell(at: IdPath(.mission, .altitude), isOn)
                enableCell(at: IdPath(.mission, .distance), isOn)
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

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
        rows: [
            SettingsRowData(id: .simulator,  type: .switcher, value: false, isEnabled: false)
        ]),
    SettingsSectionData(
        id: .mission,
        rows: [
            SettingsRowData(id: .edit,          type: .switcher,  value: false, isEnabled: true),
            SettingsRowData(id: .gridDistance,  type: .slider,    value: 0.0,   isEnabled: false),
            SettingsRowData(id: .shootDistance, type: .slider,    value: 0.0,   isEnabled: false),
            SettingsRowData(id: .altitude,      type: .slider,    value: 0.0,   isEnabled: false),
            SettingsRowData(id: .flightSpeed,   type: .slider,    value: 0.0,   isEnabled: false),
            SettingsRowData(id: .upload,        type: .button,    value: false, isEnabled: false)
        ]),
    SettingsSectionData(
        id: .status,
        rows: [
            SettingsRowData(id: .model,      type: .info,      value: "-",   isEnabled: true),
            SettingsRowData(id: .mode,       type: .info,      value: "-",   isEnabled: true),
            SettingsRowData(id: .altitude,   type: .info,      value: "-",   isEnabled: true),
            SettingsRowData(id: .battery,    type: .info,      value: "-",   isEnabled: true),
            SettingsRowData(id: .signal,     type: .info,      value: "-",   isEnabled: true),
            SettingsRowData(id: .satellites, type: .info,      value: "-",   isEnabled: true)
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
        settingsView.tableView.register(TableViewInfoCell.self, forCellReuseIdentifier: SettingsRowType.info.reuseIdentifier)
        settingsView.tableView.register(TableViewButtonCell.self, forCellReuseIdentifier: SettingsRowType.button.reuseIdentifier)
        settingsView.tableView.register(TableViewSliderCell.self, forCellReuseIdentifier: SettingsRowType.slider.reuseIdentifier)
        settingsView.tableView.register(TableViewSwitchCell.self, forCellReuseIdentifier: SettingsRowType.switcher.reuseIdentifier)
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

// Handle table view updates
extension SettingsViewController : UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return AppDimensions.Settings.rowHeight
    }

    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppDimensions.Settings.rowHeight
    }

    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableData.sections[section].id.headerHeight
    }

    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableData.sections[section].id.footerHeight
    }

    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = settingsView.tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(SectionHeaderView.self)) as! SectionHeaderView
        view.title.text = tableData.sections[section].headerTitle
        return view
    }

    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return settingsView.tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(SectionFooterView.self)) as! SectionFooterView
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableData.idPath(for: indexPath) == SettingsIdPath(.mission, .upload) {
            let coordinates = Environment.mapViewController.missionCoordinates()
            if Environment.commandService.setMissionCoordinates(coordinates) {
                Environment.commandService.executeMissionCommand(.upload)
            }
            settingsView.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// Handle data source updates
extension SettingsViewController : SettingsDataSourceDelegate {
    func sliderMoved(at idPath: SettingsIdPath, to value: Float) {
        tableData.updateRow(at: idPath, with: value)
        switch idPath{
            case SettingsIdPath(.mission, .gridDistance):
                Environment.mapViewController.gridDistance = CGFloat(value)
            case SettingsIdPath(.mission, .altitude):
                Environment.commandService.missionParameters.altitude = Float(value)
            case SettingsIdPath(.mission, .shootDistance):
                Environment.commandService.missionParameters.shootDistance = Float(value)
            case SettingsIdPath(.mission, .flightSpeed):
                Environment.commandService.missionParameters.flightSpeed = Float(value)
            default:
                break
        }
    }

    func switchTriggered(at idPath: SettingsIdPath, _ isOn: Bool) {
        switch idPath.row {
            case .simulator:
                let userLocation = Environment.mapViewController.userLocation()
                isOn ? Environment.simulatorService.startSimulator(userLocation)
                     : Environment.simulatorService.stopSimulator()
            case .edit:
                Environment.mapViewController.enableMissionEditing(isOn)
                editingEnabled = isOn
                tableData.updateRow(at: SettingsIdPath(.mission, .edit), with: isOn)
                tableData.enableRow(at: SettingsIdPath(.mission, .altitude), isOn)
                tableData.enableRow(at: SettingsIdPath(.mission, .gridDistance), isOn)
                tableData.enableRow(at: SettingsIdPath(.mission, .shootDistance), isOn)
                tableData.enableRow(at: SettingsIdPath(.mission, .flightSpeed), isOn)
                tableData.enableRow(at: SettingsIdPath(.mission, .upload), aircraftConnected && editingEnabled)
            default:
                break
        }
    }
}

// Subscribe to simulator updates
extension SettingsViewController : SimulatorServiceDelegate {
    internal func simulatorStarted(_ success: Bool) {
        tableData.updateRow(at: SettingsIdPath(.simulator, .simulator), with: success)
    }

    internal func simulatorStopped(_ success: Bool) {
        tableData.updateRow(at: SettingsIdPath(.simulator, .simulator), with: !success)
    }
}

// Subscribe to battery status updates
extension SettingsViewController : BatteryServiceDelegate {
    internal func batteryChargeChanged(_ charge: UInt?) {
        let stringValue = charge != nil ? String(charge!) : "-"
        tableData.updateRow(at: SettingsIdPath(.status, .battery), with: stringValue)
    }
}

// Subscribe to location data updates
extension SettingsViewController : LocationServiceDelegate {
    internal func signalStatusChanged(_ status: String?) {
        let stringValue = status ?? "-"
        tableData.updateRow(at: SettingsIdPath(.status, .signal), with: stringValue)
    }

    internal func satelliteCountChanged(_ count: UInt?) {
        let stringValue = count != nil ? String(count!) : "-"
        tableData.updateRow(at: SettingsIdPath(.status, .satellites), with: stringValue)
    }

    internal func altitudeChanged(_ count: UInt?) {
        let stringValue = count != nil ? String(count!) : "-"
        tableData.updateRow(at: SettingsIdPath(.status, .altitude), with: stringValue)
    }

    internal func flightModeChanged(_ mode: String?) {
        let stringValue = mode ?? "-"
        tableData.updateRow(at: SettingsIdPath(.status, .mode), with: stringValue)
    }
}

// Subscribe to connected product updates
extension SettingsViewController : ProductServiceDelegate {
    internal func modelChanged(_ model: String?) {
        aircraftConnected = model != nil && model != DJIAircraftModeNameOnlyRemoteController
        if !aircraftConnected {
            tableData.updateRow(at: SettingsIdPath(.simulator, .simulator), with: false)
        }
        tableData.updateRow(at: SettingsIdPath(.status, .model), with: model ?? "-")
        tableData.enableRow(at: SettingsIdPath(.simulator, .simulator), aircraftConnected)
        tableData.enableRow(at: SettingsIdPath(.mission, .upload), aircraftConnected && editingEnabled)
    }
}

// Subscribe to command responses
extension SettingsViewController : CommandServiceDelegate {
    func missionCommandResponded(_ commandId: MissionCommandId, _ success: Bool) {
        if success && commandId == .upload {
            editingEnabled = false
            tableData.updateRow(at: SettingsIdPath(.mission, .edit), with: false)
            tableData.enableRow(at: SettingsIdPath(.mission, .altitude), false)
            tableData.enableRow(at: SettingsIdPath(.mission, .gridDistance), false)
            tableData.enableRow(at: SettingsIdPath(.mission, .shootDistance), false)
            tableData.enableRow(at: SettingsIdPath(.mission, .flightSpeed), false)
            tableData.enableRow(at: SettingsIdPath(.mission, .upload), false)
        }
    }
}

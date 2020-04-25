//
//  SettingsDataSource.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 06.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

protocol SettingsDataSourceDelegate : AnyObject {
    func switchTriggered(at idPath: SettingsIdPath, _ isOn: Bool)
    func sliderMoved(at idPath: SettingsIdPath, to value: Float)
}

class SettingsDataSource : NSObject {
    private var tableData: SettingsTableData
    weak var delegate: SettingsDataSourceDelegate?

    init(_ tableData: inout SettingsTableData) {
        self.tableData = tableData
        super.init()
    }
}

// Private methods
extension SettingsDataSource {
    private func setupInfoCell(_ cell: UITableViewCell, _ data: SettingsRowData<Any>) {
        cell.textLabel?.text = data.title
        cell.textLabel?.textColor = data.isEnabled ? UIColor.black : UIColor.lightGray
        cell.detailTextLabel?.text = data.value as? String
        cell.detailTextLabel?.textColor = data.isEnabled ? UIColor.gray : UIColor.lightGray
        cell.selectionStyle = .none
        cell.accessoryType = .none
    }

    private func setupButtonCell(_ cell: UITableViewCell, _ data: SettingsRowData<Any>) {
        cell.textLabel?.text = data.title
        cell.textLabel?.textColor = data.isEnabled ? UIColor.blue : UIColor.lightGray
        cell.isUserInteractionEnabled = data.isEnabled
        cell.accessoryType = .none
    }

    private func setupSliderCell(_ cell: UITableViewCell, _ data: SettingsRowData<Any>) {
        if cell.accessoryView == nil {
            let slider = SettingsCellSlider()
            switch data.id {
                case .altitude:
                    slider.minimumValue = 20
                    slider.maximumValue = 200
                case .gridDistance:
                    slider.minimumValue = 10
                    slider.maximumValue = 50
                case .flightSpeed:
                    slider.minimumValue = 1
                    slider.maximumValue = 15
                case .shootDistance:
                    slider.minimumValue = 10
                    slider.maximumValue = 50
                default:
                    break
            }
            slider.addTarget(self, action: #selector(onSliderMoved(_:)), for: .valueChanged)
            slider.idPath = data.idPath
            cell.accessoryView = slider
        }
        let unit = data.id == .flightSpeed ? "m/s" : "m"
        (cell.accessoryView as! UISlider).isUserInteractionEnabled = data.isEnabled
        (cell.accessoryView as! UISlider).value = data.value as? Float ?? 0.0
        cell.textLabel?.text = data.title
        cell.textLabel?.textColor = data.isEnabled ? UIColor.black : UIColor.lightGray
        cell.detailTextLabel?.text = String(format: "%.0f ", (cell.accessoryView as! UISlider).value) + unit
        cell.detailTextLabel?.textColor = data.isEnabled ? UIColor.gray : UIColor.lightGray
        cell.selectionStyle = .none
    }

    private func setupSwitcherCell(_ cell: UITableViewCell, _ data: SettingsRowData<Any>) {
        if cell.accessoryView == nil {
            let switcher = SettingsCellSwitch()
            switcher.addTarget(self, action: #selector(onSwitchTriggered(_:)), for: .valueChanged)
            switcher.idPath = data.idPath
            cell.accessoryView = switcher
        }
        (cell.accessoryView as! UISwitch).isUserInteractionEnabled = data.isEnabled
        (cell.accessoryView as! UISwitch).isOn = data.value as? Bool ?? false
        cell.textLabel?.text = data.title
        cell.textLabel?.textColor = data.isEnabled ? UIColor.black : UIColor.lightGray
        cell.selectionStyle = .none
    }
}

// Handle table view data source updates
extension SettingsDataSource : UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.sections.count
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.sections[section].rows.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data: SettingsRowData = tableData.rowData(at: indexPath)
        let cell = UITableViewCell(style: .value1, reuseIdentifier: data.type.reuseIdentifier)
        cell.textLabel?.font = AppFont.normalLightFont
        cell.detailTextLabel?.font = AppFont.normalLightFont
        cell.backgroundColor = AppColor.Overlay.transparentWhite
        data.updateDisplayedData = {
            switch data.type {
                case .button:
                    self.setupButtonCell(cell, data)
                case .info:
                    self.setupInfoCell(cell, data)
                case .slider:
                    self.setupSliderCell(cell, data)
                case .switcher:
                    self.setupSwitcherCell(cell, data)
            }
        }
        data.updateDisplayedData?()
        return cell
    }
}

// Handle control events
extension SettingsDataSource {
    @objc func onSwitchTriggered(_ sender: SettingsCellSwitch) {
        if let idPath = sender.idPath {
            delegate?.switchTriggered(at: idPath, sender.isOn)
        }
    }

    @objc func onSliderMoved(_ sender: SettingsCellSlider) {
        if let idPath = sender.idPath {
            delegate?.sliderMoved(at: idPath, to: sender.value)
        }
    }
}

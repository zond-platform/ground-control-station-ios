//
//  SettingsDataSource.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 06.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import os.log

import UIKit

protocol SettingsDataSourceDelegate : AnyObject {
    func switchTriggered(at indexPath: IndexPath, _ isOn: Bool)
    func sliderMoved(at indexPath: IndexPath, with value: Float)
}

class SettingsDataSource : NSObject {
    private var tableData: SettingsTableData!
    weak var delegate: SettingsDataSourceDelegate?

    init(_ tableData: inout SettingsTableData) {
        super.init()
        self.tableData = tableData
    }
}

// Internal methods
extension SettingsDataSource {
    internal func setupCell(_ cell: UITableViewCell, _ data: SettingsCellData<Any>) {
        cell.textLabel?.font = AppFont.normalFont
        cell.detailTextLabel?.font = AppFont.normalFont
        switch data.type {
            case .button:
                setupButtonCell(cell, data)
            case .info:
                setupInfoCell(cell, data)
            case .slider:
                setupSliderCell(cell, data)
            case .switcher:
                setupSwitcherCell(cell, data)
        }
    }
}

// Private methods
extension SettingsDataSource {
    private func setupInfoCell(_ cell: UITableViewCell, _ data: SettingsCellData<Any>) {
        cell.textLabel?.text = data.title
        cell.textLabel?.textColor = data.isEnabled ? UIColor.black : UIColor.lightGray
        cell.detailTextLabel?.text = data.value as? String
        cell.detailTextLabel?.textColor = data.isEnabled ? UIColor.gray : UIColor.lightGray
        cell.selectionStyle = .none
        cell.accessoryType = .none
    }

    private func setupButtonCell(_ cell: UITableViewCell, _ data: SettingsCellData<Any>) {
        cell.textLabel?.text = data.title
        cell.textLabel?.textColor = data.isEnabled ? UIColor.blue : UIColor.lightGray
        cell.isUserInteractionEnabled = data.isEnabled
        cell.accessoryType = .none
    }

    private func setupSliderCell(_ cell: UITableViewCell, _ data: SettingsCellData<Any>) {
        if cell.accessoryView == nil {
            let slider = TableCellSlider()
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
            slider.idxPath = data.indexPath
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

    private func setupSwitcherCell(_ cell: UITableViewCell, _ data: SettingsCellData<Any>) {
        if cell.accessoryView == nil {
            let switcher = TableCellSwitch()
            switcher.addTarget(self, action: #selector(onSwitchTriggered(_:)), for: .valueChanged)
            switcher.idxPath = data.indexPath
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
        return tableData.sectionsCount()
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.cellsCount(in: section)
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableData.storeIndexPath(inEntryAt: indexPath)
        let data: SettingsCellData = tableData.entry(at: indexPath)
        let cell = UITableViewCell(style: .value1, reuseIdentifier: data.type.reuseIdentifier)
        cell.textLabel?.font = AppFont.normalFont
        cell.detailTextLabel?.font = AppFont.normalFont
        cell.backgroundColor = .clear
        switch data.type {
            case .button:
                setupButtonCell(cell, data)
            case .info:
                setupInfoCell(cell, data)
            case .slider:
                setupSliderCell(cell, data)
            case .switcher:
                setupSwitcherCell(cell, data)
        }
        return cell
    }
}

// Handle control events
extension SettingsDataSource {
    @objc func onSwitchTriggered(_ sender: TableCellSwitch) {
        delegate?.switchTriggered(at: sender.idxPath, sender.isOn)
    }

    @objc func onSliderMoved(_ sender: TableCellSlider) {
        delegate?.sliderMoved(at: sender.idxPath, with: sender.value)
    }
}

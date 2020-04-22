//
//  SettingsDataSource.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 06.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import os.log

import UIKit

protocol DataSourceDelegate : AnyObject {
    func switchTriggered(at indexPath: IndexPath, _ isOn: Bool)
    func sliderMoved(at indexPath: IndexPath, with value: Float)
}

class SettingsDataSource : NSObject {
    private var tableData: TableData!
    weak var delegate: DataSourceDelegate?

    init(_ tableData: inout TableData) {
        super.init()
        self.tableData = tableData
    }
}

// Internal methods
extension SettingsDataSource {
    internal func setupCell(_ cell: UITableViewCell, _ data: TableCellData<Any>) {
        cell.isUserInteractionEnabled = data.isEnabled
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
    private func setupInfoCell(_ cell: UITableViewCell, _ data: TableCellData<Any>) {
        cell.textLabel?.text = data.title
        cell.textLabel?.textColor = cell.isUserInteractionEnabled ? UIColor.black : UIColor.lightGray
        cell.detailTextLabel?.text = data.value as? String
        cell.detailTextLabel?.textColor = cell.isUserInteractionEnabled ? UIColor.gray : UIColor.lightGray
        cell.selectionStyle = .none
        cell.accessoryType = .none
    }

    private func setupButtonCell(_ cell: UITableViewCell, _ data: TableCellData<Any>) {
        cell.textLabel?.text = data.title
        cell.textLabel?.textColor = cell.isUserInteractionEnabled ? UIColor.blue : UIColor.lightGray
        cell.accessoryType = .none
    }

    private func setupSliderCell(_ cell: UITableViewCell, _ data: TableCellData<Any>) {
        if cell.accessoryView == nil {
            let slider = TableCellSlider()
            switch data.id {
                case .altitude:
                    slider.minimumValue = 20
                    slider.maximumValue = 200
                    slider.addTarget(self, action: #selector(onSliderMoved(_:)), for: .valueChanged)
                case .distance:
                    slider.minimumValue = 10
                    slider.maximumValue = 50
                    slider.addTarget(self, action: #selector(onSliderMoved(_:)), for: .valueChanged)
                default:
                    break
            }
            slider.idxPath = data.indexPath
            slider.value = data.value as? Float ?? 0.0
            cell.accessoryView = slider
        }
        cell.textLabel?.text = data.title
        cell.textLabel?.textColor = cell.isUserInteractionEnabled ? UIColor.black : UIColor.lightGray
        cell.detailTextLabel?.text = String(format: "%.0f m", (cell.accessoryView as! UISlider).value)
        cell.detailTextLabel?.textColor = cell.isUserInteractionEnabled ? UIColor.gray : UIColor.lightGray
        cell.selectionStyle = .none
    }

    private func setupSwitcherCell(_ cell: UITableViewCell, _ data: TableCellData<Any>) {
        if cell.accessoryView == nil {
            let switcher = TableCellSwitch()
            switch data.id {
                case .simulator:
                    switcher.addTarget(self, action: #selector(onSwitchTriggered(_:)), for: .valueChanged)
                case .edit:
                    switcher.addTarget(self, action: #selector(onSwitchTriggered(_:)), for: .valueChanged)
                default:
                    break
            }
            switcher.idxPath = data.indexPath
            switcher.isOn = data.value as? Bool ?? false
            cell.accessoryView = switcher
        }
        cell.textLabel?.text = data.title
        cell.textLabel?.textColor = cell.isUserInteractionEnabled ? UIColor.black : UIColor.lightGray
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
        tableData.storeEntryIndex(forEntryAt: indexPath)
        let data: TableCellData = tableData.entry(at: indexPath)
        let cell = UITableViewCell(style: .value1, reuseIdentifier: data.type.reuseIdentifier)
        cell.isUserInteractionEnabled = data.isEnabled
        cell.contentView.backgroundColor = AppColor.Overlay.semiTransparentWhite
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

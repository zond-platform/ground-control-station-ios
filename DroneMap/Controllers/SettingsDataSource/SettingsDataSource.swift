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

// Handle table view data source updates
extension SettingsDataSource : UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.sections.count
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.sections[section].rows.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        let data: SettingsRowData = tableData.rowData(at: indexPath)
        switch data.type {
            case .button:
                cell = tableView.dequeueReusableCell(withIdentifier: data.type.reuseIdentifier, for: indexPath) as! TableViewButtonCell
            case .info:
                cell = tableView.dequeueReusableCell(withIdentifier: data.type.reuseIdentifier, for: indexPath) as! TableViewInfoCell
            case .slider:
                cell = tableView.dequeueReusableCell(withIdentifier: data.type.reuseIdentifier, for: indexPath) as! TableViewSliderCell
            case .switcher:
                cell = tableView.dequeueReusableCell(withIdentifier: data.type.reuseIdentifier, for: indexPath) as! TableViewSwitchCell
        }

        data.updateDisplayedData = {
            switch data.type {
                case .button:
                    (cell! as! TableViewButtonCell).setup(data.id.title, data.isEnabled)
                case .info:
                    (cell! as! TableViewInfoCell).setup(data.id.title, data.value as! String, data.isEnabled)
                case .slider:
                    (cell! as! TableViewSliderCell).setup(data)
                    (cell! as! TableViewSliderCell).sliderMoved = { idPath, value in
                        self.delegate?.sliderMoved(at: idPath, to: value)
                    }
                case .switcher:
                    (cell! as! TableViewSwitchCell).setup(data)
                    (cell! as! TableViewSwitchCell).switchTriggered = { idPath, isOn in
                        self.delegate?.switchTriggered(at: idPath, isOn)
                    }
            }
        }
        data.updateDisplayedData?()

        return cell!
    }
}

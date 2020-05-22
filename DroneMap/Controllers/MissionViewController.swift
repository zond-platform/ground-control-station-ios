//
//  MissionViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/6/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK
import UIKit

fileprivate var missionData = TableData([
    SectionData(
        id: .editor,
        rows: [
            RowData(id: .gridDistance,  type: .slider, value: 20.0, isEnabled: true),
            RowData(id: .shootDistance, type: .slider, value: 30.0, isEnabled: true),
            RowData(id: .altitude,      type: .slider, value: 50.0, isEnabled: true),
            RowData(id: .flightSpeed,   type: .slider, value: 10.0, isEnabled: true),
        ]),
    SectionData(
        id: .command,
        rows: [
            RowData(id: .command,       type: .command,    value: MissionStateId.finished, isEnabled: false)
        ]),
])

class MissionViewController : UIViewController {
    private var missionView: MissionView!
    private var tableData: TableData = missionData

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        missionView = MissionView(tableData.contentHeight)
        missionView.tableView.dataSource = self
        missionView.tableView.delegate = self
        missionView.tableView.register(TableSection.self, forHeaderFooterViewReuseIdentifier: SectionType.spacer.reuseIdentifier)
        missionView.tableView.register(TableCommandCell.self, forCellReuseIdentifier: RowType.command.reuseIdentifier)
        missionView.tableView.register(TableSliderCell.self, forCellReuseIdentifier: RowType.slider.reuseIdentifier)
        registerListeners()
        view = missionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Private methods
extension MissionViewController {
    private func registerListeners() {
        missionView.buttonSelected = { isSelected in
            self.missionView.showMissionEditor(isSelected)
            Environment.mapViewController.enableMissionEditing(isSelected)
        }
        Environment.commandService.commandResponded = { id, success in
            if success {
                switch id {
                    case .upload:
                        self.editting(enable: false)
                        self.tableData.updateRow(at: IdPath(.command, .command), with: MissionStateId.uploaded)
                    case .start:
                        self.tableData.updateRow(at: IdPath(.command, .command), with: MissionStateId.running)
                    case .pause:
                        self.tableData.updateRow(at: IdPath(.command, .command), with: MissionStateId.paused)
                    case .resume:
                        self.tableData.updateRow(at: IdPath(.command, .command), with: MissionStateId.running)
                    case .stop:
                        self.tableData.updateRow(at: IdPath(.command, .command), with: MissionStateId.finished)
                }
            }
        }
    }

    private func editting(enable: Bool) {
        self.tableData.enableRow(at: IdPath(.editor, .gridDistance), enable)
        self.tableData.enableRow(at: IdPath(.editor, .shootDistance), enable)
        self.tableData.enableRow(at: IdPath(.editor, .altitude), enable)
        self.tableData.enableRow(at: IdPath(.editor, .flightSpeed), enable)
    }

    private func sliderMoved(at idPath: IdPath, to value: Float) {
        tableData.updateRow(at: idPath, with: value)
        switch idPath{
            case IdPath(.editor, .gridDistance):
                Environment.mapViewController.gridDistance = CGFloat(value)
            case IdPath(.editor, .altitude):
                Environment.commandService.missionParameters.altitude = Float(value)
            case IdPath(.editor, .shootDistance):
                Environment.commandService.missionParameters.shootDistance = Float(value)
            case IdPath(.editor, .flightSpeed):
                Environment.commandService.missionParameters.flightSpeed = Float(value)
            default:
                break
        }
    }

    private func buttonPressed(with id: CommandButtonId) {
        switch id {
            case .upload:
                let coordinates = Environment.mapViewController.missionCoordinates()
                if Environment.commandService.setMissionCoordinates(coordinates) {
                    Environment.commandService.executeMissionCommand(.upload)
                }
            case .start:
                Environment.commandService.executeMissionCommand(.start)
            case .edit:
                self.tableData.updateRow(at: IdPath(.command, .command), with: MissionStateId.finished)
                self.editting(enable: true)
            case .pause:
                Environment.commandService.executeMissionCommand(.pause)
            case .resume:
                Environment.commandService.executeMissionCommand(.resume)
            case .stop:
                Environment.commandService.executeMissionCommand(.stop)
        }
    }

    private func commandCell(for rowData: RowData<Any>, at indexPath: IndexPath, in tableView: UITableView) -> TableCommandCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rowData.type.reuseIdentifier, for: indexPath) as! TableCommandCell
        cell.buttonPressed = { id in
            self.buttonPressed(with: id)
        }
        rowData.updated = {
            cell.updateData(rowData)
        }
        return cell
    }

    private func sliderCell(for rowData: RowData<Any>, at indexPath: IndexPath, in tableView: UITableView) -> TableSliderCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rowData.type.reuseIdentifier, for: indexPath) as! TableSliderCell
        cell.sliderMoved = { id , value in
            self.sliderMoved(at: id, to: value)
        }
        rowData.updated = {
            cell.updateData(rowData)
        }
        return cell
    }
}

// Table view data source
extension MissionViewController : UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.sections.count
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.sections[section].rows.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let rowData = tableData.rowData(at: indexPath)
        switch rowData.type {
            case .command:
                cell = commandCell(for: rowData, at: indexPath, in: tableView)
            case .slider:
                cell = sliderCell(for: rowData, at: indexPath, in: tableView)
        }
        rowData.updated?()
        return cell
    }
}

// Table view apperance
extension MissionViewController : UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return tableData.rowHeight
    }

    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableData.sections[section].id.headerHeight
    }

    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableData.sections[section].id.footerHeight
    }

    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = missionView.tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionType.spacer.reuseIdentifier) as! TableSection
        return view
    }

    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return missionView.tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionType.spacer.reuseIdentifier) as! TableSection
    }
}

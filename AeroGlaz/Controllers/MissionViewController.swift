//
//  MissionViewController.swift
//  Aeroglaz
//
//  Created by Evgeny Agamirzov on 4/6/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK
import UIKit

enum MissionState {
    case uploaded
    case running
    case paused
    case editing
}

fileprivate let allowedTransitions: KeyValuePairs<MissionState?,MissionState?> = [
    nil             : .editing,
    .editing        : nil,
    .editing        : .uploaded,
    .uploaded       : .editing,
    .uploaded       : .running,
    .running        : .editing,
    .running        : .paused,
    .paused         : .editing,
    .paused         : .running
]

fileprivate var missionData = TableData([
    SectionData(
        id: .command,
        rows: [
            RowData(id: .command,       type: .command, value: MissionState.editing, isEnabled: false)
    ]),
    SectionData(
        id: .editor,
        rows: [
            RowData(id: .gridDistance,  type: .slider,  value: Float(10.0),          isEnabled: true),
            RowData(id: .shootDistance, type: .slider,  value: Float(10.0),          isEnabled: true),
            RowData(id: .altitude,      type: .slider,  value: Float(50.0),          isEnabled: true),
            RowData(id: .flightSpeed,   type: .slider,  value: Float(10.0),          isEnabled: true)
        ]),
])

class MissionViewController : UIViewController {
    // Stored properties
    private var missionView: MissionView!
    private var tableData: TableData = missionData
    private var previousMissionState: MissionState?

    // Observer properties
    private var missionState: MissionState? {
        didSet {
            if allowedTransitions.contains(where: { $0 == oldValue && $1 == missionState }) {
                for listener in stateListeners {
                    listener?(missionState)
                }
            }
        }
    }

    // Notyfier properties
    var stateListeners: [((_ state: MissionState?) -> Void)?] = []

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
        missionView.missionButtonPressed = {
            if self.missionState == nil {
                self.missionState = MissionState.editing
            } else if self.missionState == .editing {
                self.missionState = nil
            }
        }
        Environment.commandService.commandResponded = { id, success in
            if success {
                switch id {
                    case .upload:
                        self.missionState = MissionState.uploaded
                    case .start:
                        self.missionState = MissionState.running
                    case .pause:
                        self.missionState = MissionState.paused
                    case .resume:
                        self.missionState = MissionState.running
                    case .stop:
                        self.missionState = MissionState.editing
                }
            } else {
                self.missionState = MissionState.editing
            }
        }
        Environment.commandService.missionFinished = { success in
            self.missionState = MissionState.editing
        }
        Environment.connectionService.listeners.append({ model in
            if model == nil {
                self.tableData.enableRow(at: IdPath(.command, .command), false)
                if self.missionState == .uploaded
                    || self.missionState == .running
                    || self.missionState == .paused {
                    self.missionState = MissionState.editing
                }
            } else {
                self.tableData.enableRow(at: IdPath(.command, .command), true)
                self.tableData.updateRow(at: IdPath(.command, .command), with: MissionState.editing)
            }
        })
        stateListeners.append({ state in
            self.missionView.expand(for: state)
            if state != nil {
                self.tableData.updateRow(at: IdPath(.command, .command), with: state!)
            }
        })
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
                self.missionState = MissionState.editing
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

        // Slider default values in the data source should be delivered to the
        // respective components upon creation, thus simulate slider "move" to the
        // initial value which will notify a subscriber of the respective parameter.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.sliderMoved(at: IdPath(.editor, rowData.id), to: rowData.value as! Float)
        }

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
        return missionView.tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionType.spacer.reuseIdentifier) as! TableSection
    }

    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return missionView.tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionType.spacer.reuseIdentifier) as! TableSection
    }
}

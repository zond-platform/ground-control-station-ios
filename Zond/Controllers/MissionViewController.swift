//
//  MissionViewController.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 4/6/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import os.log

import DJISDK
import MobileCoreServices
import UIKit

struct Misson : Codable {
    struct Feature : Codable {
        struct Properties : Codable {
            let distance: Float
            let angle: Float
            let shoot: Float
            let altitude: Float
            let speed: Float
        }

        struct Geometry : Codable {
            let type: String
            let coordinates: [[[Double]]]
        }

        let properties: Properties
        let geometry: Geometry
    }

    let features: [Feature]
}

fileprivate var missionData = TableData([
    SectionData(
        id: .actions,
        rows: [
            RowData(id: .actions,       type: .actions, value: MissionState.editing, isEnabled: false)
        ]),
    SectionData(
        id: .params,
        rows: [
            RowData(id: .gridDistance,  type: .slider,  value: Float(10.0),          isEnabled: true),
            RowData(id: .gridAngle,     type: .slider,  value: Float(0.0),           isEnabled: true),
            RowData(id: .shootDistance, type: .slider,  value: Float(10.0),          isEnabled: true),
            RowData(id: .altitude,      type: .slider,  value: Float(50.0),          isEnabled: true),
            RowData(id: .flightSpeed,   type: .slider,  value: Float(10.0),          isEnabled: true)
        ])
])

class MissionViewController : UIViewController {
    // Stored properties
    private var missionView: MissionView!
    private var tableData: TableData = missionData

    // Notyfier properties
    var logConsole: ((_ message: String, _ type: OSLogType) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        missionView = MissionView()
        missionView.dataSource = self
        missionView.delegate = self
        missionView.register(TableSection.self, forHeaderFooterViewReuseIdentifier: SectionType.spacer.reuseIdentifier)
        missionView.register(TableButtonsCell.self, forCellReuseIdentifier: RowType.actions.reuseIdentifier)
        missionView.register(TableSliderCell.self, forCellReuseIdentifier: RowType.slider.reuseIdentifier)
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
        Environment.commandService.commandResponseListeners.append({ id, success in
            if success && id == .upload {
                Environment.missionStateManager.state = .uploaded
            }
        })
        Environment.connectionService.listeners.append({ model in
            self.tableData.enableRow(at: IdPath(.actions, .actions), model == nil ? false : true)
        })
        Environment.missionStateManager.stateListeners.append({ state in
            let isEditingState = state != nil && state! == .editing
            Environment.statusViewController.triggerMenuButtonSelection(isEditingState)
            self.missionView.showFromSide(isEditingState)
        })
    }

    private func sliderMoved(at idPath: IdPath, to value: Float) {
        tableData.updateRow(at: idPath, with: value)
        switch idPath{
            case IdPath(.params, .gridDistance):
                Environment.mapViewController.missionPolygon?.gridDistance = CGFloat(value)
                Environment.commandService.missionParameters.turnRadius = (Float(value) / 2) - 10e-6
            case IdPath(.params, .gridAngle):
                Environment.mapViewController.missionPolygon?.gridAngle = CGFloat(value)
            case IdPath(.params, .altitude):
                Environment.commandService.missionParameters.altitude = Float(value)
            case IdPath(.params, .shootDistance):
                Environment.commandService.missionParameters.shootDistance = Float(value)
            case IdPath(.params, .flightSpeed):
                Environment.commandService.missionParameters.flightSpeed = Float(value)
            default:
                break
        }
    }

    private func buttonPressed(with id: TableButtonId) {
        switch id {
            case .importJson:
                let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeJSON)], in: .import)
                documentPicker.delegate = self
                documentPicker.shouldShowFileExtensions = true
                documentPicker.allowsMultipleSelection = false
                Environment.rootViewController.present(documentPicker, animated: true, completion: nil)
            case .upload:
                let coordinates = Environment.mapViewController.missionCoordinates()
                if Environment.commandService.setMissionCoordinates(coordinates) {
                    Environment.commandService.executeMissionCommand(.upload)
                }
        }
    }

    private func actionsCell(for rowData: RowData<Any>, at indexPath: IndexPath, in tableView: UITableView) -> TableButtonsCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rowData.type.reuseIdentifier, for: indexPath) as! TableButtonsCell
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
            self.sliderMoved(at: IdPath(.params, rowData.id), to: rowData.value as! Float)
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
            case .actions:
                cell = actionsCell(for: rowData, at: indexPath, in: tableView)
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
        return missionView.dequeueReusableHeaderFooterView(withIdentifier: SectionType.spacer.reuseIdentifier) as! TableSection
    }

    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return missionView.dequeueReusableHeaderFooterView(withIdentifier: SectionType.spacer.reuseIdentifier) as! TableSection
    }
}

// Document picker updates
extension MissionViewController : UIDocumentPickerDelegate {
    internal func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let jsonUrl = urls.first {
            do {
                let jsonFile = try String(contentsOf: jsonUrl, encoding: .utf8)
                do {
                    let jsonData = jsonFile.data(using: .utf8)!
                    let decoder = JSONDecoder()
                    let mission = try decoder.decode(Misson.self, from: jsonData).features[0]

                    sliderMoved(at: IdPath(.params, .gridDistance), to: mission.properties.distance)
                    sliderMoved(at: IdPath(.params, .gridAngle), to: mission.properties.angle)
                    sliderMoved(at: IdPath(.params, .shootDistance), to: mission.properties.shoot)
                    sliderMoved(at: IdPath(.params, .altitude), to: mission.properties.altitude)
                    sliderMoved(at: IdPath(.params, .flightSpeed), to: mission.properties.speed)

                    if mission.geometry.type == "Polygon"  && !mission.geometry.coordinates.isEmpty {
                        // First element of the geometry is always the outer polygon
                        var rawCoordinates = mission.geometry.coordinates[0]
                        rawCoordinates.removeLast()
                        Environment.mapViewController.showMissionPolygon(rawCoordinates)
                    }
                } catch {
                    logConsole?("JSON parse error: \(error)", .error)
                }
            } catch {
                logConsole?("JSON read error: \(error)", .error)
            }
        }
    }
}

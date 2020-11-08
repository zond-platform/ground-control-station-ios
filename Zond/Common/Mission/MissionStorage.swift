//
//  MissionStorage.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 16.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import os.log

import UIKit
import UniformTypeIdentifiers

fileprivate let activeMissionFileName: String = "active-mission.json"
fileprivate let exportMissionFileName: String = "export-mission.json"

struct Mission : Codable {
    struct Feature : Codable {
        struct Properties : Codable {
            let meanderStep: Float
            let meanderAngle: Float
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

class MissionStorage : NSObject {
    // Notifyer properties
    var logConsole: ((_ message: String, _ type: OSLogType) -> Void)?
}

// Public methods
extension MissionStorage {
    func importMission() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.json], asCopy: true)
        documentPicker.delegate = self
        documentPicker.shouldShowFileExtensions = true
        documentPicker.allowsMultipleSelection = false
        Environment.rootViewController.present(documentPicker, animated: true)
    }

    func exportMission() {
        if let dir = documentsDirectory() {
            let fileUrl = dir.appendingPathComponent(exportMissionFileName)
            writeMission(at: fileUrl)
            let documentPicker = UIDocumentPickerViewController(forExporting: [fileUrl])
            documentPicker.shouldShowFileExtensions = true
            documentPicker.allowsMultipleSelection = false
            Environment.rootViewController.present(documentPicker, animated: true)
        }
    }

    func writeActiveMission() {
        if let dir = documentsDirectory() {
            let fileUrl = dir.appendingPathComponent(activeMissionFileName)
            writeMission(at: fileUrl)
        }
    }

    func restoreActiveMission() {
        if let dir = documentsDirectory() {
            let fileUrl = dir.appendingPathComponent(activeMissionFileName)
            if let mission = readMission(from: fileUrl) {
                updateMissionParameters(for: mission)
            }
        }
    }

    func removeActiveMission() {
        if let dir = documentsDirectory() {
            let fileUrl = dir.appendingPathComponent(activeMissionFileName)
            do {
                try FileManager.default.removeItem(at: fileUrl)
                logConsole?("Active mission discarded", .info)
            } catch {
                logConsole?("Remove active mission error: \(error)", .error)
            }
        }
    }

    func activeMissionPresent() -> Bool {
        if let dir = documentsDirectory() {
            let fileUrl = dir.appendingPathComponent(activeMissionFileName)
            return FileManager.default.fileExists(atPath: fileUrl.path)
        } else {
            return false
        }
    }
}

// Private methods
extension MissionStorage {
    private func documentsDirectory() -> URL? {
        do {
            return try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
        } catch {
            logConsole?("Locate documents directory error: \(error)", .error)
            return nil
        }
    }

    private func writeMission(at fileUrl: URL) {
        do {
            var coordinates = Environment.mapViewController.rawPolygonCoordinates()
            if let firstElement = coordinates.first {
                coordinates.append(firstElement)
            }
            let mission = Mission(features: [
                Mission.Feature(
                    properties: Mission.Feature.Properties(
                        meanderStep: Environment.missionParameters.meanderStep.value,
                        meanderAngle: Environment.missionParameters.meanderAngle.value,
                        altitude: Environment.missionParameters.altitude.value,
                        speed: Environment.missionParameters.speed.value
                    ),
                    geometry: Mission.Feature.Geometry(
                        type: "Polygon",
                        coordinates: [coordinates])
                )
            ])
            try? FileManager.default.removeItem(at: fileUrl)
            try JSONEncoder().encode(mission).write(to: fileUrl)
            logConsole?("Active mission recorded", .info)
        } catch {
            logConsole?("JSON encode error: \(error)", .error)
        }
    }

    private func readMission(from fileUrl: URL) -> Mission? {
        do {
            let jsonFile = try String(contentsOf: fileUrl, encoding: .utf8)
            do {
                let jsonData = jsonFile.data(using: .utf8)!
                let decoder = JSONDecoder()
                return try decoder.decode(Mission.self, from: jsonData)
            } catch {
                logConsole?("JSON decode error: \(error)", .error)
                return nil
            }
        } catch {
            logConsole?("JSON read error: \(error)", .error)
            return nil
        }
    }

    private func updateMissionParameters(for mission: Mission) {
        let mission = mission.features[0]
        Environment.missionParameters.meanderStep.value = mission.properties.meanderStep
        Environment.missionParameters.meanderAngle.value = mission.properties.meanderAngle
        Environment.missionParameters.altitude.value = mission.properties.altitude
        Environment.missionParameters.speed.value = mission.properties.speed
        if mission.geometry.type == "Polygon"  && !mission.geometry.coordinates.isEmpty {
            // First element of the geometry is always the outer polygon
            var rawCoordinates = mission.geometry.coordinates[0]
            rawCoordinates.removeLast()
            Environment.mapViewController.setRawPolygonCoordinates(rawCoordinates)
        }
    }
}

// Document picker updates
extension MissionStorage : UIDocumentPickerDelegate {
    internal func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let jsonUrl = urls.first {
            if let mission = readMission(from: jsonUrl) {
                updateMissionParameters(for: mission)
            }
        }
    }
}

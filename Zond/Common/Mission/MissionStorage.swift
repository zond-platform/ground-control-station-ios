//
//  MissionStorage.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 16.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import os.log

import MobileCoreServices
import UIKit

struct Misson : Codable {
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
    var logConsole: ((_ message: String, _ type: OSLogType) -> Void)?

    func importMission() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeJSON)], in: .import)
        documentPicker.delegate = self
        documentPicker.shouldShowFileExtensions = true
        documentPicker.allowsMultipleSelection = false
        Environment.rootViewController.present(documentPicker, animated: true, completion: nil)
    }
}

// Document picker updates
extension MissionStorage : UIDocumentPickerDelegate {
    internal func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let jsonUrl = urls.first {
            do {
                let jsonFile = try String(contentsOf: jsonUrl, encoding: .utf8)
                do {
                    let jsonData = jsonFile.data(using: .utf8)!
                    let decoder = JSONDecoder()
                    let mission = try decoder.decode(Misson.self, from: jsonData).features[0]

                    Environment.missionParameters.meanderStep.value = mission.properties.meanderStep
                    Environment.missionParameters.meanderAngle.value = mission.properties.meanderAngle
                    Environment.missionParameters.altitude.value = mission.properties.altitude
                    Environment.missionParameters.speed.value = mission.properties.speed

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

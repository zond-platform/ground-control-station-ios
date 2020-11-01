//
//  ImportExportViewController.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 17.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class ImportExportViewController : UIViewController {
    private var importExportView: ImportExportView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        importExportView = ImportExportView()
        registerListeners()
        view = importExportView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Private methods
extension ImportExportViewController {
    private func registerListeners() {
        Environment.connectionService.listeners.append({ model in
            self.importExportView.enableUploadButton(model != nil)
        })
        importExportView.importButtonPressed = {
            Environment.missionStorage.importMission()
        }
        importExportView.exportButtonPressed = {
            Environment.missionStorage.exportMission()
        }
        importExportView.uploadButtonPressed = {
            let coordinates = Environment.mapViewController.meanderCoordinates()
            if Environment.commandService.setMissionCoordinates(coordinates) {
                Environment.commandService.executeMissionCommand(.upload)
            }
        }
    }
}

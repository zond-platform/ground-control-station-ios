//
//  ImportExportButton.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 01.11.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum ImportExportButtonId {
    case importMission
    case exportMission
    case uploadMission

    var title: String {
        switch self {
            case .importMission:
                return "Import"
            case .exportMission:
                return "Export"
            case .uploadMission:
                return "Upload"
        }
    }
}

class ImportExportButton : UIButton {
    var id: ImportExportButtonId!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ id: ImportExportButtonId) {
        super.init(frame: CGRect())
        setTitle(id.title, for: .normal)
        setTitleColor(Colors.secondary, for: .normal)
        titleLabel?.font = Fonts.title
        layer.borderWidth = 1;
        layer.borderColor = Colors.secondary.cgColor;
    }
}

//
//  ImportExportView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 17.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

fileprivate let width = Dimensions.missionMenuWidth
fileprivate let height = Dimensions.tileSize + Dimensions.spacer

class ImportExportView : UIView {
    // Stored properties
    private let importButton = ImportExportButton(.importMission)
    private let exportButton = ImportExportButton(.exportMission)
    private let uploadButton = ImportExportButton(.uploadMission)
    private let stackView = UIStackView()

    // Notifyer properties
    var importButtonPressed: (() -> Void)?
    var exportButtonPressed: (() -> Void)?
    var uploadButtonPressed: (() -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: Dimensions.spacer,
            bottom: Dimensions.spacer,
            right: Dimensions.spacer
        )

        importButton.addTarget(self, action: #selector(onImportButtonPressed(_:)), for: .touchUpInside)
        exportButton.addTarget(self, action: #selector(onExportButtonPressed(_:)), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(onUploadButtonPressed(_:)), for: .touchUpInside)

        stackView.addArrangedSubview(importButton)
        stackView.setCustomSpacing(Dimensions.spacer, after: importButton)
        stackView.addArrangedSubview(exportButton)
        stackView.setCustomSpacing(Dimensions.spacer, after: exportButton)
        stackView.addArrangedSubview(uploadButton)

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height),
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
}

// Public methods
extension ImportExportView {
    func enableUploadButton(_ enable: Bool) {
        let color = enable ? Colors.secondary : Colors.inactive
        uploadButton.isEnabled = enable
        uploadButton.setTitleColor(color, for: .normal)
        uploadButton.layer.borderColor = color.cgColor;
    }
}

// Handle control events
extension ImportExportView {
    @objc func onImportButtonPressed(_ : UIButton) {
        importButtonPressed?()
    }

    @objc func onExportButtonPressed(_ : UIButton) {
        exportButtonPressed?()
    }

    @objc func onUploadButtonPressed(_ : UIButton) {
        uploadButtonPressed?()
    }
}

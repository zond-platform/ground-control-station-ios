//
//  ImportExportView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 17.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

fileprivate let width = Dimensions.missionMenuWidth - Dimensions.roundedAreaOffsetOr(0)

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

        importButton.addTarget(self, action: #selector(onImportButtonPressed(_:)), for: .touchUpInside)
        exportButton.addTarget(self, action: #selector(onExportButtonPressed(_:)), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(onUploadButtonPressed(_:)), for: .touchUpInside)

        stackView.addArrangedSubview(importButton)
        stackView.setCustomSpacing(Dimensions.spacer, after: importButton)
        stackView.addArrangedSubview(exportButton)
        stackView.setCustomSpacing(Dimensions.spacer, after: exportButton)
        stackView.addArrangedSubview(uploadButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.spacer),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.doubleSpacer),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
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

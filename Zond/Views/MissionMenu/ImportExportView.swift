//
//  ImportExportView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 17.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

fileprivate let buttonWidth = Dimensions.missionMenuWidth - Dimensions.spacer * CGFloat(2)

class ImportExportView : UIView {
    // Stored properties
    private let importButton = UIButton()
    private let uploadButton = UIButton()
    private let stackView = UIStackView()

    // Notifyer properties
    var importButtonPressed: (() -> Void)?
    var uploadButtonPressed: (() -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: Dimensions.spacer,
            bottom: Dimensions.spacer,
            right: Dimensions.spacer
        )

        importButton.setTitle("Import", for: .normal)
        importButton.setTitleColor(Colors.secondary, for: .normal)
        importButton.titleLabel?.font = Fonts.title
        importButton.layer.borderWidth = 1;
        importButton.layer.borderColor = Colors.secondary.cgColor;
        importButton.addTarget(self, action: #selector(onImportButtonPressed(_:)), for: .touchUpInside)

        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.setTitleColor(Colors.secondary, for: .normal)
        uploadButton.titleLabel?.font = Fonts.title
        uploadButton.layer.borderWidth = 1;
        uploadButton.layer.borderColor = Colors.secondary.cgColor;
        uploadButton.addTarget(self, action: #selector(onUploadButtonPressed(_:)), for: .touchUpInside)

        stackView.addArrangedSubview(importButton)
        stackView.setCustomSpacing(Dimensions.spacer, after: importButton)
        stackView.addArrangedSubview(uploadButton)

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Dimensions.missionMenuWidth),
            importButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            importButton.heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            uploadButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            uploadButton.heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
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

    @objc func onUploadButtonPressed(_ : UIButton) {
        uploadButtonPressed?()
    }
}

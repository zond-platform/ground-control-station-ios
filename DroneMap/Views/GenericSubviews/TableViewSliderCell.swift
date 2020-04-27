//
//  TableViewSliderCell.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 27.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class TableViewSliderCell : UITableViewCell {
    private let stackView = UIStackView()
    private let title = InsetLabel()
    private let value = InsetLabel()
    private let slider = SettingsCellSlider()
    var sliderMoved: ((_ idPath: SettingsIdPath, _ value: Float) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        accessoryType = .none
        backgroundColor = .clear

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        title.font = AppFont.smallFont
        stackView.addArrangedSubview(title)

        value.font = AppFont.smallFont
        value.textColor = AppColor.Text.detailTitle
        stackView.addArrangedSubview(value)
        
        stackView.addArrangedSubview(slider)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// Public methods
extension TableViewSliderCell {
    func setup(_ data: SettingsRowData<Any>) {
        switch data.id {
            case .altitude:
                slider.minimumValue = 20
                slider.maximumValue = 200
            case .gridDistance:
                slider.minimumValue = 10
                slider.maximumValue = 50
            case .flightSpeed:
                slider.minimumValue = 1
                slider.maximumValue = 15
            case .shootDistance:
                slider.minimumValue = 10
                slider.maximumValue = 50
            default:
                break
        }
        slider.addTarget(self, action: #selector(sliderMoved(_:)), for: .valueChanged)
        slider.idPath = data.idPath

        let unit = data.id == .flightSpeed ? "m/s" : "m"
        self.slider.isUserInteractionEnabled = data.isEnabled
        self.slider.value = data.value as? Float ?? 0.0

        self.title.text = data.title
        self.value.text = String(format: "%.0f ", self.slider.value) + unit
        self.title.textColor = data.isEnabled ? AppColor.Text.mainTitle : AppColor.Text.inactiveTitle
        self.value.textColor = data.isEnabled ? AppColor.Text.detailTitle : AppColor.Text.inactiveTitle
    }
}

// Handle control events
extension TableViewSliderCell {
    @objc func sliderMoved(_ sender: SettingsCellSlider) {
        if let idPath = sender.idPath {
            sliderMoved?(idPath, sender.value)
        }
    }
}

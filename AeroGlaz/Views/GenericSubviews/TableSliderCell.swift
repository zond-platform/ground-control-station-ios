//
//  TableSliderCell.swift
//  Aeroglaz
//
//  Created by Evgeny Agamirzov on 27.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class TableSliderCell : UITableViewCell {
    // Stored properties
    private let stackView = UIStackView()
    private let title = InsetLabel()
    private let value = InsetLabel()
    private let slider = TableSlider()

    // Notifyer properties
    var sliderMoved: ((_ idPath: IdPath, _ value: Float) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        accessoryType = .none
        backgroundColor = .clear

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        title.font = Fonts.titleFont
        NSLayoutConstraint.activate([
            title.widthAnchor.constraint(equalToConstant: MissionView.width * CGFloat(0.4))
        ])
        stackView.addArrangedSubview(title)

        NSLayoutConstraint.activate([
            slider.widthAnchor.constraint(equalToConstant: MissionView.width * CGFloat(0.35))
        ])
        stackView.addArrangedSubview(slider)

        value.font = Fonts.titleFont
        value.textColor = Colors.Text.detailTitle
        stackView.addArrangedSubview(value)

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
extension TableSliderCell {
    func updateData(_ data: RowData<Any>) {
        switch data.id {
            case .altitude:
                slider.minimumValue = 20
                slider.maximumValue = 200
            case .gridDistance:
                slider.minimumValue = 5
                slider.maximumValue = 50
            case .flightSpeed:
                slider.minimumValue = 1
                slider.maximumValue = 15
            case .shootDistance:
                slider.minimumValue = 5
                slider.maximumValue = 50
            default:
                break
        }

        slider.addTarget(self, action: #selector(sliderMoved(_:)), for: .valueChanged)
        slider.idPath = data.idPath

        let unit = data.id == .flightSpeed ? "m/s" : "m"
        self.slider.value = data.value as? Float ?? 0.0
        self.slider.isUserInteractionEnabled = data.isEnabled

        self.title.text = data.title
        self.value.text = String(format: "%.0f ", self.slider.value) + unit

        self.title.textColor = data.isEnabled ? Colors.Text.mainTitle   : Colors.Text.inactiveTitle
        self.value.textColor = data.isEnabled ? Colors.Text.detailTitle : Colors.Text.inactiveTitle
    }
}

// Handle control events
extension TableSliderCell {
    @objc func sliderMoved(_ sender: TableSlider) {
        if let idPath = sender.idPath {
            sliderMoved?(idPath, sender.value)
        }
    }
}

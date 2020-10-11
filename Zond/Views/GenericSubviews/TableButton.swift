//
//  TableButton.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 06.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class TableButton : UIButton {
    var id: TableButtonId?
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? Colors.secondary : Colors.inactive
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ id: TableButtonId) {
        super.init(frame: CGRect())
        self.id = id
        setTitle(id.title, for: .normal)
        titleLabel!.font = Fonts.title
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = Colors.secondary
    }
}

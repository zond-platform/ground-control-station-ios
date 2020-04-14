//
//  SettingsSection.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 08.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

class SettingsSection {
    var id: SectionId
    var title: String
    var entries: [SettingsCell<Any>]

    init(id: SectionId, entries: [SettingsCell<Any>]) {
        self.id = id
        self.title = id.title
        self.entries = entries
    }
}

//
//  ServiceProtocol.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/19/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

protocol ServiceProtocol {
    var env: Environment {set get}
    
    func start()
    func stop()
}

extension ServiceProtocol {
    func start() {}
    func stop() {}
}

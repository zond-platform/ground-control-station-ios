//
//  ProductService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/19/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

protocol ProductServiceDelegate : AnyObject {
    func modelChanged(_ model: String?)
}

class ProductService : ServiceBase {
    var delegates: [ProductServiceDelegate?] = []
    
    override init() {
        super.init()
        super.setKeyActionMap([
            DJIProductKey(param: DJIProductParamModelName):self.onModelNameChanged
        ])
    }
}

// Public methods
extension ProductService {
    func addDelegate(_ delegate: ProductServiceDelegate) {
        delegates.append(delegate)
    }
}

// Private methods
extension ProductService {
    private func onModelNameChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        for delegate in delegates {
            delegate?.modelChanged(newValue?.stringValue)
        }
    }
}

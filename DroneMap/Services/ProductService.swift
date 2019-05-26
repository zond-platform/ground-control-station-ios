//
//  ProductService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/19/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

protocol ProductServiceDelegate : AnyObject {
    func modelChanged(_ model: String)
}

/*************************************************************************************************/
class ProductService : ServiceBase {
    var delegates: [ProductServiceDelegate?] = []
    
    override init(_ env: Environment) {
        super.init(env)
        super.setKeyActionMap([
            DJIProductKey(param: DJIProductParamModelName):self.onModelNameChanged
        ])
    }
}

/*************************************************************************************************/
extension ProductService {
    func onModelNameChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        let model = newValue?.stringValue ?? "none"
        notifyModelChanged(model)
    }
}

/*************************************************************************************************/
extension ProductService {
    func addDelegate(_ delegate: ProductServiceDelegate) {
        delegates.append(delegate)
    }
    
    func notifyModelChanged(_ model: String) {
        for delegate in delegates {
            delegate?.modelChanged(model)
        }
    }
}

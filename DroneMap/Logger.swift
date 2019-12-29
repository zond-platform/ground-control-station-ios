//
//  Logger.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/8/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import os.log

enum LogContext {
    case connection
    case simulator
    case battery
    case product
    case command
}

protocol LoggerDelegate : AnyObject {
    func logConsole(_ message: String, _ context: String, _ level: OSLogType)
}

class Logger {
    weak var delegate: LoggerDelegate?
    private let contextMap: [LogContext:String] = [
        .connection:"CONN",
        .simulator: "SIMU",
        .battery:   "BATT",
        .product:   "PROD",
        .command:   "COMM"
    ]
}
    
// Public methods
extension Logger {
    func logInfo(_ message: String, _ context: LogContext, sendToConsole: Bool = true) {
        logSystem(message, contextMap[context]!, .info, sendToConsole)
    }
    
    func logDebug(_ message: String, _ context: LogContext, sendToConsole: Bool = true) {
        logSystem(message, contextMap[context]!, .debug, sendToConsole)
    }
    
    func logError(_ message: String, _ context: LogContext, sendToConsole: Bool = true) {
        logSystem(message, contextMap[context]!, .error, sendToConsole)
    }
}

// Private methods
extension Logger {
    private func logSystem(_ message: String, _ context: String, _ level: OSLogType, _ sendToConsole: Bool) {
        os_log("%@", type: level, message)
        if sendToConsole {
            self.delegate?.logConsole(message, context, level)
        }
    }
}

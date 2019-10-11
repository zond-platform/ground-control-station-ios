//
//  ConsoleView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/6/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit
import os.log

/*************************************************************************************************/
class ConsoleViewController : UIViewController {
    typealias LogEntry = (String, String, OSLogType)

    private let cellId: String = "Cell"
    private let maxScrollbackSize: Int = 100
    private var logScrollback: NSMutableArray = []
    
    var consoleView: TableView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ env: Environment) {
        super.init(nibName: nil, bundle: nil)
        
        env.logger.delegate = self
        
        consoleView = TableView(.console)
        consoleView.register(TableViewCell.self, forCellReuseIdentifier: cellId)
        consoleView.dataSource = self
        consoleView.delegate = self
        view = consoleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

/*************************************************************************************************/
extension ConsoleViewController {
    private func trimScrollback() {
        if logScrollback.count > maxScrollbackSize {
            logScrollback.removeObject(at: 0)
            consoleView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }
    
    private func appendScrollback() {
        let backIndexPath = IndexPath(row: logScrollback.count - 1, section: 0)
        consoleView?.insertRows(at: [backIndexPath], with: .none)
        DispatchQueue.main.async {
            self.consoleView?.scrollToRow(at: backIndexPath, at: .bottom, animated: true)
        }
    }

    private func logMessage() {
        consoleView?.beginUpdates()
        trimScrollback()
        appendScrollback()
        consoleView?.endUpdates()
    }
}

/*************************************************************************************************/
extension ConsoleViewController : LoggerDelegate {
    func logConsole(_ message: String, _ context: String, _ level: OSLogType) {
        let logEntry: LogEntry = (message, context, level)
        logScrollback.add(logEntry)
        logMessage()
    }
}

/*************************************************************************************************/
extension ConsoleViewController : UITableViewDelegate {}

/*************************************************************************************************/
extension ConsoleViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logScrollback.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableViewCell
        let logEntry: LogEntry = logScrollback[indexPath.row] as! LogEntry
        cell.messageLabel.text = "\(logEntry.0)"
        cell.contextLabel.text = "\(logEntry.1)"
        switch logEntry.2 {
            case .error:
                cell.setTextColor(UIColor.red)
            case .debug:
                cell.setTextColor(UIColor.yellow)
            default:
                cell.setTextColor(UIColor.green)
        }
        return cell
    }
}

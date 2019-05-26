//
//  StatusViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

/*************************************************************************************************/
class StatusViewController : UIViewController {
    private let cellId: String = "Cell"
    private var entries: [Int:(Context,String)] = [
        0:(.product, "-"),
        1:(.mode, "-"),
        2:(.gps, "-"),
        3:(.satellites, "-"),
        4:(.battery, "-"),
        5:(.altitude, "-")
    ]
    
    var statusView: TableView?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(_ env: Environment) {
        super.init(nibName: nil, bundle: nil)
        
        env.productService().addDelegate(self)
        env.batteryService().addDelegate(self)
        env.locationService().addDelegate(self)
        
        statusView = TableView(.status)
        statusView!.register(TableViewCell.self, forCellReuseIdentifier: cellId)
        statusView!.dataSource = self
        statusView!.delegate = self
        view = statusView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateValue(_ context: Context, _ value: String) {
        for index in 0...entries.count {
            if entries[index]?.0 == context {
                entries[index]?.1 = value
                statusView?.reloadData()
            }
        }
    }
}

/*************************************************************************************************/
extension StatusViewController : UITableViewDelegate {}

/*************************************************************************************************/
extension StatusViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableViewCell
        switch entries[indexPath.row]!.0 {
            case .product:
                cell.contextLabel.text = "PRD"
            case .gps:
                cell.contextLabel.text = "GPS"
            case .battery:
                cell.contextLabel.text = "BAT"
            case .satellites:
                cell.contextLabel.text = "SAT"
            case .altitude:
                cell.contextLabel.text = "ALT"
            case .mode:
                cell.contextLabel.text = "MOD"
            default:
                cell.contextLabel.text = ""
        }
        cell.messageLabel.text = entries[indexPath.row]!.1
        cell.setTextColor(.white)
        return cell
    }
}

/*************************************************************************************************/
extension StatusViewController : ProductServiceDelegate {
    func modelChanged(_ model: String) {
        updateValue(.product, model)
    }
}

/*************************************************************************************************/
extension StatusViewController : BatteryServiceDelegate {
    func batteryChargeChanged(_ charge: UInt) {
        updateValue(.battery, String(charge) + "%")
    }
}

/*************************************************************************************************/
extension StatusViewController : LocationServiceDelegate {
    func signalStatusChanged(_ status: String) {
        updateValue(.gps, status)
    }
    
    func satelliteCountChanged(_ count: UInt) {
        updateValue(.satellites, String(count))
    }
    
    func altitudeChanged(_ altitude: Double) {
        updateValue(.altitude, String(altitude))
    }
    
    func flightModeChanged(_ mode: String) {
        updateValue(.mode, mode)
    }
}

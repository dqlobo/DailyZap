//
//  SettingsViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 12/3/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit
import PopupDialog

class SettingsViewController: BaseViewController {
    let settingsCellReuseID = "SettingsCellReuseID"
    let notificationsCellReuseID = "SettingsNotificationsReuseID"
    let settingsFooterReuseID = "SettingsFooterReuseID"

    @IBOutlet weak var tableView: UITableView!
    lazy var presenter = SettingsPresentationController(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.zapBlue
        self.setupTableView()
    }
    
    func setupTableView() {
        let img = UIImageView(image: UIImage(named: "splash"))
        img.contentMode = .scaleAspectFit
        self.tableView.tableHeaderView = img
        self.tableView.separatorColor = UIColor.clear
        let cellNib = UINib(nibName:"SettingsTableViewCell", bundle:Bundle.main)
        self.tableView.register(cellNib, forCellReuseIdentifier: self.settingsCellReuseID)
        let footerNib = UINib(nibName: "ButtonFooter", bundle: Bundle.main)
        self.tableView.register(footerNib, forHeaderFooterViewReuseIdentifier: self.settingsFooterReuseID)
        let notifNib = UINib(nibName: "NotificationSettingsTableViewCell", bundle: .main)
        tableView.register(notifNib, forCellReuseIdentifier: notificationsCellReuseID)
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.sectionFooterHeight = 100
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate, NotificationInjector {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: SettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: settingsCellReuseID, for: indexPath) as! SettingsTableViewCell
            cell.titleLabel.text = "Zap"
            cell.detailLabel.text = "/zap/ (verb) to send a message that refreshes an old connection"
            return cell
        } else if indexPath.row == 1 {
            let cell: NotificationSettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: notificationsCellReuseID, for: indexPath) as! NotificationSettingsTableViewCell
            cell.delegate = self
            cell.setCollapsed(!notificationManager.enabled)
            cell.enabled = notificationManager.enabled
            cell.timing = notificationManager.timing
            cell.frequency = notificationManager.frequency
            return cell
        }
        fatalError("Check your datasource")
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.settingsFooterReuseID)
        if let footer = view as? ButtonFooter {

            footer.btn.type = ButtonType.lightFilled.rawValue
            footer.btn.setTitle("BACK", for: .normal)
            footer.btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
            return footer
        }
        return nil
    }
    
}

extension SettingsViewController: NotificationSettingsDelegate {
    func didToggleNotifications(_ isOn: Bool, cell: NotificationSettingsTableViewCell) {
        notificationManager.setEnabled(isOn) { [weak self] result in
            if case let .success(flag) = result {
                cell.enabled = flag
                self?.tableView.reloadData()
            } else {
                cell.enabled = false
                self?.presenter.openAppSettings()
            }
        }
    }
    
    func didSetTime(_ time: NotificationTiming, cell: NotificationSettingsTableViewCell) {
        notificationManager.setTiming(time)
    }
    func didSetFrequency(_ freq: NotificationFrequency, cell: NotificationSettingsTableViewCell) {
        notificationManager.setFrequency(freq)
    }
}

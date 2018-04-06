//
//  SettingsViewController.swift
//  DailyZap
//
//  Created by David LoBosco on 12/3/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import UIKit

fileprivate enum SettingsRow: Int {
    case definition
    case notifications
    
    case rowCount
}

class SettingsViewController: BaseViewController {
    let settingsCellReuseID = "SettingsCellReuseID"
    let settingsFooterReuseID = "SettingsFooterReuseID"
    
    @IBOutlet weak var tableView: UITableView!
    
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
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.rowHeight = 120
        self.tableView.sectionFooterHeight = 100
        self.tableView.bounces = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsRow.rowCount.rawValue
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.settingsCellReuseID, for: indexPath) as! SettingsTableViewCell
        if indexPath.row == 0 {
            cell.titleLabel.text = "Zap"
            cell.detailLabel.text = "/zap/ (verb) to send a message that refreshes an old connection"
        } else {
            cell.titleLabel.text = "Notifications"
            cell.detailLabel.text = "Turn on notifications for reminders to supercharge your network"
        }
        return cell
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

extension SettingsViewController: UITableViewDelegate {
    
}

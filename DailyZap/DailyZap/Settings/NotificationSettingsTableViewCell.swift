//
//  NotificationSettingsTableViewCell.swift
//  DailyZap
//
//  Created by David LoBosco on 4/11/18.
//  Copyright © 2018 dqlobo. All rights reserved.
//

import UIKit

protocol NotificationSettingsDelegate: NSObjectProtocol {
//    func canToggleNotifications(completion: @escaping (Bool) -> Void)
    func didToggleNotifications(_ isOn: Bool, cell: NotificationSettingsTableViewCell)
    func didSetFrequency(_ freq: NotificationFrequency, cell: NotificationSettingsTableViewCell)
    func didSetTime(_ time: NotificationTiming, cell: NotificationSettingsTableViewCell)
}

class NotificationSettingsTableViewCell: UITableViewCell {

    var enabled: Bool = true {
        didSet {
            setCollapsed(!enabled)
            selectBtn(enabled, btn: onBtn)
            selectBtn(!enabled, btn: offBtn)
        }
    }
    
    var frequency: NotificationFrequency = .daily {
        didSet {
            selectBtn(frequency == .daily, btn: dailyBtn)
            selectBtn(frequency == .weekly, btn: weeklyBtn)
        }
    }
    var timing: NotificationTiming = .midday {
        didSet {
            selectBtn(timing == .morning, btn: morningBtn)
            selectBtn(timing == .midday, btn: middayBtn)
            selectBtn(timing == .evening, btn: eveningBtn)
        }
    }
    
    @IBOutlet private weak var onBtn: Button!
    @IBOutlet private weak var offBtn: Button!
    
    @IBOutlet private weak var dailyBtn: Button!
    @IBOutlet private weak var weeklyBtn: Button!
    
    @IBOutlet private weak var morningBtn: Button!
    @IBOutlet private weak var middayBtn: Button!
    @IBOutlet private weak var eveningBtn: Button!
    
    @IBOutlet weak var detailSettingsHeight: NSLayoutConstraint!
    private let detailSettingsExpandedHeight: CGFloat = 100

    weak var delegate: NotificationSettingsDelegate?
    
    @IBOutlet weak var notificationLabel: Label!
    @IBOutlet weak var notifDescriptionLabel: Label!
    @IBOutlet weak var freqLabel: Label!
    @IBOutlet weak var timeLabel: Label!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        notificationLabel.textColor = .white
        notifDescriptionLabel.textColor = .white
        freqLabel.textColor = .white
        timeLabel.textColor = .white
    }
    
    func setCollapsed(_ flag: Bool) {
        detailSettingsHeight.constant = flag ? 0 : detailSettingsExpandedHeight
        layoutIfNeeded()
    }
    
    @IBAction func toggleNotifications(_ sender: UIButton) {
        delegate?.didToggleNotifications(sender == onBtn, cell: self)
    }
    
    @IBAction func toggleFrequency(_ sender: UIButton) {
        frequency = sender == dailyBtn ? .daily : .weekly
        delegate?.didSetFrequency(frequency, cell: self)

    }
    
    @IBAction func toggleTime(_ sender: UIButton) {
        if sender == morningBtn {
            timing = .morning
        } else {
            timing = sender == middayBtn ? .midday : .evening
        }
        delegate?.didSetTime(timing, cell: self)

    }
    
    private func selectBtn(_ selected: Bool, btn: Button) {
        let type = selected ? ButtonType.lightEmpty : ButtonType.deselected
        btn.styleForType(typ: type.rawValue)
    }
}

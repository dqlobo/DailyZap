//
//  FeedPresentationController.swift
//  DailyZap
//
//  Created by David LoBosco on 12/21/17.
//  Copyright © 2017 dqlobo. All rights reserved.
//

import Foundation
import ContactsUI
import MessageUI
import PopupDialog
import CallKit

class FeedPresentationController: BasePresentationController<FeedViewController>, AppleContactsInjector,
                                    SoundInjector, CXCallObserverDelegate {

    lazy var callObserver = CXCallObserver()
    var currentCalledContact: Contact?
    var messageCallbackHandler: MessageComposeCallbackHandler?

    override init(viewController: FeedViewController) {
        super.init(viewController: viewController)
        callObserver.setDelegate(self, queue: nil)
    }
    
    // MARK: - Basic Interactions
    
    func tappedAddContact() -> Void {
        let contactPicker = ContactPickerViewController()
        contactPicker.addContactCallback = { [weak self] contactOrNil in
            self?.vc.dismiss(animated: true) {
               
                if let contact = contactOrNil,
                    self?.vc.dataController?.feedManager.addToFeed(contact: contact) ?? false {
                    self?.reloadFeed(sections: [1])
                } else {
                    self?.showOkayPopup(title: "Failed to queue contact".lowercased(), message: "Please try again later.")
                }
            }
        }
        let nav = UINavigationController(rootViewController: contactPicker)
        nav.navigationBar.isTranslucent = false
        vc.present(nav, animated: true)
    }
    
    func tappedOpenSettings() -> Void {
        let settings = SettingsViewController()
        settings.modalTransitionStyle = .flipHorizontal
        vc.present(settings, animated: true, completion: nil)
    }
    
    func tappedContactInfo(contact: Contact) {
        showDetailPopup(for: contact)
    }
    
    func tappedZapForContact(contact: Contact) {
        showDetailPopup(for: contact)
    }
    
    // MARK: - CXCallObserverDelegate
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if let c = currentCalledContact,
            call.hasEnded {
            rewardForZapping(contact: c, pts: 50, extraWait: 0.5)
            currentCalledContact = nil
        }
    }
}

// MARK: - Leaving App Events
extension FeedPresentationController {
    func sendText(contact: Contact) {
        guard MFMessageComposeViewController.canSendText() else {
            showFailPopup(action: "send text")
            return
        }
        
        let message = MFMessageComposeViewController()
        message.body = "⚡️ Hey, long time no see! How's it going? (Sent with the DailyZap app)"
        message.recipients = [contact.primaryPhone]
        messageCallbackHandler = MessageComposeCallbackHandler(contact: contact) { [weak self] result in
            self?.vc.dismiss(animated: true, completion: nil)
            if case let .success(contact) = result {
                self?.rewardForZapping(contact: contact, pts: 20)
            }
            self?.messageCallbackHandler = nil
        }
        message.messageComposeDelegate = messageCallbackHandler
        
        vc.present(message, animated: true, completion: nil)
    }
    
    func makeCall(contact: Contact) {// \(contact.primaryPhone) TODO
        guard let url = URL(string: "tel://3019293385") else { return }
        guard UIApplication.shared.canOpenURL(url) else {
            showFailPopup(action: "open phone")
            return
        }
        UIApplication.shared.open(url, options: [:]) { [weak self] success in
            self?.currentCalledContact = contact
        }
    }
}

// MARK: - Reward Presentation
extension FeedPresentationController {
    func didCompleteZap(minPoints: Int = 10) {
        let animation = LightningBoltView()
        animation.backgroundColor = .zapYellow
        vc.view.addSubview(animation)
        animation.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = animation.heightAnchor.constraint(equalToConstant: 0)
        topConstraint.priority = .defaultLow
        let top = vc.navigationController?.navigationBar.bottomAnchor ?? vc.view.topAnchor
        NSLayoutConstraint.activate([
            animation.bottomAnchor.constraint(equalTo: vc.footer.topAnchor),
            animation.widthAnchor.constraint(equalTo: vc.view.widthAnchor),
            animation.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            animation.topAnchor.constraint(equalTo: top)
            ])
        vc.view.layoutIfNeeded()
        
        soundManager.playBoltSound()
        animation.flash(duration: 0.5) {
            self.soundManager.playSuccessSound()
            UIView.animate(withDuration: 0.2, animations: {
                animation.alpha = 0
            }, completion: { _ in
                animation.removeFromSuperview()
                self.vc.footer.addPoints(minPoints + Int.random(upTo: 10),
                                         animated: true)
                self.soundManager.playPointsSound()
            })
        }
    }
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay,
                                      execute: closure)

    }
    
    func rewardForZapping(contact: Contact, pts: Int = 10, extraWait: TimeInterval = 0) {
        let time: TimeInterval = 2 / (TimeInterval(Int.random(upTo: 4) + 2)) + extraWait
        delay(time) { [weak self] in
            self?.didCompleteZap(minPoints: pts)
            let sections = contact.isDue ? [0] : [1]
            self?.vc.dataController?.feedManager.didZap(contact: contact)
            self?.reloadFeed(sections: sections)
        }
    }
    
}

// MARK: - Custom Popups
extension FeedPresentationController {
   
    func decorateZapDefault(for contact: Contact, in popup: PopupDialog) {
        let call = DefaultButton(title: "☎️  Call") { [weak self] in
            self?.makeCall(contact: contact)
        }
        let text = DefaultButton(title: "📩  Text") { [weak self] in
            self?.sendText(contact: contact)
        }
        
        let remove = DestructiveButton(title: "✖️  Remove this Zap") { [weak self] in
            self?.showConfirmDelete(for: contact)
        }
        popup.addButtons([call, text, remove])
    }
    
    func reloadFeed(sections: [Int] = [0,1]) {
        vc.tableView.reloadSections(IndexSet(sections), with: .fade)

    }
    func decorateZapRemove(for contact: Contact, in popup: PopupDialog, recommendsRemoval: Bool = true) {
        let blacklist = DestructiveButton(title: "🏴  Never suggest this contact again") { [weak self] in
            let sections = contact.isDue ? [0] : [1]
            self?.vc.dataController?.feedManager.addToBlackList(contact: contact)
            self?.reloadFeed(sections: sections)
            
        }
        
        let rmTitle = "🗓  Remove \(contact.firstName) just this once"
        let rmAction: PopupDialogButton.PopupDialogButtonAction = { [weak self] in
            let sections = contact.isDue ? [0] : [1]
            self?.vc.dataController?.feedManager.removeFromFeed(contact: contact)
            self?.reloadFeed(sections: sections)
        }
        let rm = recommendsRemoval ?
            DefaultButton(title: rmTitle, action: rmAction) :
            DestructiveButton(title: rmTitle, action: rmAction)
        
        let compTitle = "☑️  Mark as completed"
        let compAction: PopupDialogButton.PopupDialogButtonAction = {  [weak self] in self?.rewardForZapping(contact: contact,
                                                                                                             pts: 5,
                                                                                                             extraWait: -0.5) }
        let comp = recommendsRemoval ?
            DestructiveButton(title: compTitle, action: compAction) :
            DefaultButton(title: compTitle, action: compAction)
        
        if recommendsRemoval {
            popup.addButtons([rm, blacklist, comp])
        } else {
            popup.addButtons([comp, rm, blacklist])
        }
        
    }
    
    func showOkayPopup(title: String, message: String) {
        let popup = PopupDialog(title: title, message: message)
        popup.addButton(DefaultButton(title: "Okay") {})
        showPopup(popup, showsCancel: false)
    }
    
    func showFailPopup(action: String) {
       showOkayPopup(title: "Unable to \(action)".lowercased(), message: "Check your phone settings and cell service and try again.")
    }
    
    func showDetailPopup(`for` contact: Contact) {
        let popup = PopupDialog(title: "Zap \(contact.firstName) now!".lowercased(), message: "Choose an option:", buttonAlignment: .vertical, transitionStyle: .bounceUp, completion: nil)
      
        if contact.hasPhone {
            decorateZapDefault(for: contact, in: popup)
        } else {
            decorateZapRemove(for: contact, in: popup, recommendsRemoval: false)
        }
        
        showPopup(popup)
    }
    
    func showConfirmDelete(`for` contact: Contact) {
        let popup = PopupDialog(title: "Remove this Zap?".lowercased(),
                                message: "You can always queue \(contact.firstName) later",
            buttonAlignment: .vertical,
            transitionStyle: .bounceUp,
            completion: nil)
        decorateZapRemove(for: contact, in: popup)
        showPopup(popup)
    }
}

class MessageComposeCallbackHandler: NSObject, MFMessageComposeViewControllerDelegate {
    let contact: Contact
    var callback: ((Result<Contact>) -> Void)?
    init(contact: Contact, callback: ((Result<Contact>) -> Void)?) {
        self.contact = contact
        self.callback = callback
        super.init()
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if result == .sent {
            callback?(.success(contact))
        } else {
            callback?(.failure(ResultError()))
        }

    }
}

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


class FeedPresentationController: AppleContactsInjector {
    let viewController: FeedViewController
    var activeDelegates: NSMutableSet = NSMutableSet()
    
    init(viewController: FeedViewController) {
        self.viewController = viewController
        activeDelegates = []
    }
    
    @objc func dismiss() -> Void {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func tappedAddContact(callback: ContactSuccessCallback? = nil) -> Void {
        
        let contactPicker = ContactPickerViewController()
        contactPicker.addContactCallback = { contactOrNil in
            guard let cb = callback else { return }
            if let contact = contactOrNil {
                cb(contact, true)
            }
            self.dismiss()
        }
        let nav = UINavigationController(rootViewController: contactPicker)
        nav.navigationBar.isTranslucent = false
        viewController.present(nav, animated: true)
    }
    
    func tappedContactInfo(contact: Contact) {
        if let cn = self.appleContactManager.getContactWithID(contactID: contact.contactID, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()]) {
            let contactInfo = CNContactViewController(for: cn)
            contactInfo.allowsEditing = false
            contactInfo.shouldShowLinkedContacts = true
            contactInfo.message = String(format:"⚡️ Zap %@ now with a call or text!", contact.firstName)
            contactInfo.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismiss))
            let handler = ContactInfoCallbackHandler()
            contactInfo.delegate = handler
            activeDelegates.add(handler)
            handler.callback = { [weak self] in
                self?.dismiss()
                self?.activeDelegates.remove(handler)
            }
            let nav =  UINavigationController(rootViewController: contactInfo)
            viewController.present(nav, animated: true)
        }
    }
    
    func tappedZapForContact(contact: Contact, _ callback: ContactSuccessCallback? = nil) {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let message = MFMessageComposeViewController()
        message.body = "⚡️ Hey, long time no see! How's it going? (Sent with the DailyZap app)"
        message.recipients = [contact.primaryPhone]
        let handler = MessageComposeCallbackHandler(contact: contact)
        message.messageComposeDelegate = handler
        activeDelegates.add(handler)
        handler.callback = { contact, success in
            self.dismiss()
            if let cb = callback {
                cb(contact, success)
            }
            self.activeDelegates.remove(handler)
        }
        viewController.present(message, animated: true, completion: nil)
    }
    
    func tappedOpenSettings() -> Void {
//        let settings = SettingsViewController()
//        settings.modalTransitionStyle = .flipHorizontal
//        self.viewController.present(settings, animated: true, completion: nil)
        didCompleteZap()
    }
    
    func didCompleteZap() {
        let animation = LightningBoltView()
        animation.backgroundColor = .zapYellow
        viewController.view.addSubview(animation)
        animation.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = animation.heightAnchor.constraint(equalToConstant: 0)
        topConstraint.priority = .defaultLow
        let top = viewController.navigationController?.navigationBar.bottomAnchor ?? viewController.view.topAnchor
        NSLayoutConstraint.activate([
            animation.bottomAnchor.constraint(equalTo: viewController.footer.topAnchor),
            animation.widthAnchor.constraint(equalTo: viewController.view.widthAnchor),
            animation.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            animation.topAnchor.constraint(equalTo: top)
        ])
        viewController.view.layoutIfNeeded()
        
        // animate up drag
        
        animation.flash(duration: 0.5) {
            UIView.animate(withDuration: 0.2, animations: {
                animation.alpha = 0
            }, completion: { _ in
                animation.removeFromSuperview()
            })
        }
    }
}


typealias ContactSuccessCallback = (Contact, Bool) -> Void
class ContactInfoCallbackHandler: NSObject, CNContactViewControllerDelegate {
    var callback: (() -> Void)?
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        if let cb = self.callback {
            cb()
        }
    }
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        return true
    }
}

class ContactPickerCallbackHandler: NSObject, CNContactPickerDelegate {
    var callback: ContactSuccessCallback?
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        if let cb = self.callback {
            let ct = Contact(contactID: contact.identifier)
            cb(ct, true)
        }
    }
}

class MessageComposeCallbackHandler: NSObject, MFMessageComposeViewControllerDelegate {
    let contact: Contact
    var callback: ContactSuccessCallback?
    init(contact: Contact) {
        self.contact = contact
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if let cb = callback {
            cb(contact, result == .sent)
        }
    }
}

//
//  KeyboardSizeListener.swift
//  Quiz Challenge
//
//  Created by Joao Vitor P. on 2/15/20.
//  Copyright © 2020 ArcTouch. All rights reserved.
//

import UIKit

class KeyboardSizeListener : NSObject {
    weak var controller: UIViewController!
    let selector: Selector

    var keyboardHeight: CGFloat = 0

    init(_ controller: UIViewController, selector: Selector) {
        self.controller = controller
        self.selector = selector
        super.init()

        self.listenToKeyboardEvents()
    }

    func listenToKeyboardEvents() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onKeyboardChangeNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(onKeyboardChangeNotification), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    func stopListeningToKeyboardEvents() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func onKeyboardChangeNotification(notification: Notification) {
        guard let view = controller?.view else {
            stopListeningToKeyboardEvents()
            return
        }

        guard
            let frameData = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
            let keyboardScreenEndFrame = (frameData as? NSValue)?.cgRectValue
        else {
            return
        }

        if notification.name == UIResponder.keyboardWillHideNotification {
            self.keyboardHeight = 0
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.controller?.perform(self.selector, with: self.keyboardHeight)
                }
            }
        }
        else {
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
            self.keyboardHeight = keyboardViewEndFrame.height - view.safeAreaInsets.bottom

            self.controller?.perform(self.selector, with: self.keyboardHeight)
        }
    }
}

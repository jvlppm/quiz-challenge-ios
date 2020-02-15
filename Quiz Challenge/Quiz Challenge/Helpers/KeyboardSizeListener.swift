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

    init(_ controller: UIViewController, selector: Selector) {
        self.controller = controller
        self.selector = selector
        super.init()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onKeyboardChangeNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(onKeyboardChangeNotification), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func onKeyboardChangeNotification(notification: Notification) {
        guard let view = controller?.view else {
            NotificationCenter.default.removeObserver(self)
            return
        }

        guard
            let frameData = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
            let keyboardScreenEndFrame = (frameData as? NSValue)?.cgRectValue
        else {
            return
        }

        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let keyboardHeight = keyboardViewEndFrame.height - view.safeAreaInsets.bottom

        controller.perform(selector, with: keyboardHeight)
    }
}

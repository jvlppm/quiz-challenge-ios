//
//  ViewController.swift
//  Quiz Challenge
//
//  Created by Joao Vitor P. on 2/14/20.
//  Copyright © 2020 ArcTouch. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var bottomPanelPositionConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onKeyboardChangeNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(onKeyboardChangeNotification), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func onKeyboardChangeNotification(notification: Notification) {
        guard
            let frameData = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
            let keyboardScreenEndFrame = (frameData as? NSValue)?.cgRectValue
        else {
            return
        }

        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let keyboardHeight = keyboardViewEndFrame.height - view.safeAreaInsets.bottom

        self.onKeyboardUpdate(height: keyboardHeight)
    }

    func onKeyboardUpdate(height: CGFloat) {
        bottomPanelPositionConstraint.constant = height
        view.layoutIfNeeded()
    }
}


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
    var keyboardSizeListener: KeyboardSizeListener!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        keyboardSizeListener = KeyboardSizeListener(self, selector: #selector(onKeyboardUpdate))
    }

    @objc func onKeyboardUpdate(height: CGFloat) {

        bottomPanelPositionConstraint.constant = height
        view.layoutIfNeeded()
    }
}


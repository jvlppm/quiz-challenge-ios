//
//  LoadingView.swift
//  Quiz Challenge
//
//  Created by Joao Vitor P. on 2/15/20.
//  Copyright © 2020 ArcTouch. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class LoadingControl : UIView {
    let nibName = "LoadingControl"

    @IBOutlet var view: LoadingControlView!

    public static func create(for view: UIView) -> LoadingControl {
        let control = LoadingControl(frame: view.bounds)
        view.addSubview(control)
        control.layoutMargins = view.layoutMargins
        control.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return control
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initNib()
    }

    func initNib() {
        let bundle = Bundle(for: LoadingControl.self)
        bundle.loadNibNamed(String(describing: LoadingControl.self), owner: self, options: nil)
        addSubview(view)
        view.layoutMargins = layoutMargins
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    public func startLoading(completion: ((Bool) -> Void)? = nil) {
        self.isUserInteractionEnabled = true
        view.indicator.startAnimating()
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeCubicPaced, animations: {
            // Background
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                self.view.background.alpha = 1
            }
            // Panel Size
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.view.panel.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }, completion: completion)
    }

    public func endLoading(completion: ((Bool) -> Void)? = nil) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeCubicPaced, animations: {
            // Background
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                self.view.background.alpha = 0
            }
            // Panel Size
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.view.panel.transform = CGAffineTransform(scaleX: 0, y: 0)
            }
        }, completion: { result in
            self.isUserInteractionEnabled = false
            self.view.indicator.stopAnimating()
            completion?(result)
        })
    }
}

class LoadingControlView : UIView {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var panel: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
}

//
//  LoadingView.swift
//  Quiz Challenge
//
//  Created by Joao Vitor P. on 2/15/20.
//  Copyright © 2020 ArcTouch. All rights reserved.
//

import Foundation
import UIKit

protocol LoadingControlDelegate {
    func onLoading(active: Bool)
}

@IBDesignable
class LoadingControl : UIView {
    let nibName = "LoadingControl"
    static var AnimationDuration: TimeInterval = 0.3

    @IBOutlet var view: LoadingControlView!

    public var delegate: LoadingControlDelegate?

    public static func create(for view: UIView, isActive: Bool = false, delegate: LoadingControlDelegate? = nil) -> LoadingControl {
        let control = LoadingControl(frame: view.bounds)
        control.delegate = delegate
        control.isActive = isActive
        view.addSubview(control)
        control.layoutMargins = view.layoutMargins
        control.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        delegate?.onLoading(active: isActive)
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

    public var isActive: Bool = true {
        didSet {
            guard isActive != oldValue else { return }
            let initialized = superview != nil
            if isActive {
                startLoading(animated: initialized)
            }
            else {
                endLoading(animated: initialized)
            }
        }
    }

    func startLoading(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        self.isUserInteractionEnabled = true
        view.indicator.startAnimating()
        delegate?.onLoading(active: true)

        let duration: TimeInterval = animated ? LoadingControl.AnimationDuration : 0

        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubicPaced, animations: {
            // Background Alpha
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                self.view.background.alpha = 1
            }
            // Panel Size
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.view.panel.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            // Panel Alpha
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
                self.view.panel.alpha = 1
            }
        }, completion: completion)
    }

    func endLoading(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        let duration: TimeInterval = animated ? LoadingControl.AnimationDuration : 0

        view.background.layer.removeAllAnimations()
        view.panel.layer.removeAllAnimations()

        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubicPaced, animations: {
            // Background Alpha
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                self.view.background.alpha = 0
            }
            // Panel Size
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.view.panel.transform = CGAffineTransform(scaleX: 0, y: 0)
            }
            // Panel Alpha
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                self.view.panel.alpha = 0
            }
        }, completion: { result in
            guard !self.isActive else {
                completion?(false)
                return
            }
            self.isUserInteractionEnabled = false
            self.view.indicator.stopAnimating()
            completion?(result)
            self.delegate?.onLoading(active: false)
        })
    }
}

class LoadingControlView : UIView {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var panel: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
}

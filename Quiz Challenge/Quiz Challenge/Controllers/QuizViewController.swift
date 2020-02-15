//
//  ViewController.swift
//  Quiz Challenge
//
//  Created by Joao Vitor P. on 2/14/20.
//  Copyright © 2020 ArcTouch. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var bottomPanelPositionConstraint: NSLayoutConstraint!
    var keyboardSizeListener: KeyboardSizeListener!
    var loadingControl: LoadingControl!

    var gameModel = GameModel()

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answerEntry: UITextField!
    @IBOutlet weak var answersCount: UILabel!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadingControl = LoadingControl.create(for: view)
        keyboardSizeListener = KeyboardSizeListener(self, selector: #selector(onKeyboardUpdate))
        loadGameData()
    }

    func loadGameData() {
        ApiClient.shared.send(RequestGameData()) {
            result in
            guard let data = try? result.get() else {
                // Retry after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.loadGameData()
                }
                return
            }

            self.gameModel.data = data
            self.refresh()
            self.loadingControl.endLoading()
        }
    }

    @IBAction func start(_ sender: Any) {
        gameModel.start()
        refresh()
        answerEntry.becomeFirstResponder()
    }

    @IBAction func reset(_ sender: Any) {
        gameModel.reset()
        answerEntry.text = ""
        refresh()
    }

    func refresh() {
        self.question.text = gameModel.question
        self.reloadAnswersCount()
        self.reloadTimerCount()

        self.answerEntry.isEnabled = gameModel.state == .running
        self.startButton.isHidden = gameModel.state != .stopped
        self.resetButton.isHidden = gameModel.state == .stopped
    }

    func reloadAnswersCount() {
        let current = gameModel.playerAnswers.count
        let total = gameModel.possibleAnswers.count
        self.answersCount.text = String(format: "%02d/%02d", current, total)
    }

    func reloadTimerCount() {
        let time = NSInteger(gameModel.remainingTime)
        let seconds = time % 60
        let minutes = time / 60
        self.timeRemaining.text = String(format: "%02d:%02d", minutes, seconds)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let sourceText = textField.text!
        let inputText = sourceText.replacingCharacters(in: Range(range, in: sourceText)!, with: string)

        let response = gameModel.check(answer: inputText)
        if response != .correct {
            return true
        }

        reloadAnswersCount()

        answerEntry.text = ""
        return false
    }

    @objc func onKeyboardUpdate(height: CGFloat) {

        bottomPanelPositionConstraint.constant = height
        view.layoutIfNeeded()

        //yourTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        //yourTextView.scrollIndicatorInsets = yourTextView.contentInset
    }
}


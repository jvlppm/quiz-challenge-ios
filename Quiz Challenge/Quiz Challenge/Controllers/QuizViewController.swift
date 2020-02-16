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
    var loadingControl: LoadingControl!

    var gameModel = GameModel()

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var answerEntry: UITextField!
    @IBOutlet weak var answerEntryContainer: UIView!
    @IBOutlet weak var answersCount: UILabel!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var bottomPanel: UIView!

    var loadingTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomPanel.frame.height, right: 0)
        table.scrollIndicatorInsets = table.contentInset

        loadingControl = LoadingControl.create(for: view, isActive: true, delegate: self)
        keyboardSizeListener = KeyboardSizeListener(self, selector: #selector(onKeyboardUpdate))

        gameModel.delegate = self
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
            self.loadingControl.isActive = false
        }
    }

    @IBAction func start(_ sender: Any) {
        self.gameModel.start()
    }

    @IBAction func reset(_ sender: Any) {
        self.gameModel.reset()
    }

    func refresh() {
        self.question.text = gameModel.question
        self.reloadAnswersCount()
        self.reloadTimerCount()

        self.answerEntry.isEnabled = gameModel.state == .running
        self.startButton.isHidden = gameModel.state != .stopped
        self.resetButton.isHidden = gameModel.state == .stopped

        let showAnswers = !loadingControl.isActive && gameModel.state != .stopped
        self.table.alpha = showAnswers ? 1 : 0

        self.table.reloadData()
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

    @objc func onKeyboardUpdate(height: CGFloat) {
        bottomPanelPositionConstraint.constant = height
        view.layoutIfNeeded()
    }
}

extension QuizViewController : GameModelDelegate {
    func onStart(game: GameModel) {

        UIView.animate(withDuration: 0.3) {
            self.refresh()
        }
        answerEntry.becomeFirstResponder()

        loadingTimer = Timer.scheduledTimer(timeInterval: 1,
            target: self,
            selector: #selector(tickGameTimer),
            userInfo: nil,
            repeats: true)
    }

    @objc func tickGameTimer() {
        gameModel.elapse(time: 1)
        reloadTimerCount()
    }

    func onStop(game: GameModel) {
        UIView.animate(withDuration: 0.3) {
            self.refresh()
        }

        loadingTimer?.invalidate()

        guard game.state == .finished else {
            return
        }

        answerEntry.text = ""

        if game.playerWon {
            showPlayerWon()
        }
        else {
            showPlayerLost()
        }
    }

    func showPlayerWon() {
        let alert = UIAlertController(
            title: "Congratulations",
            message: "Good job! You found all the answers on time. Keep up the great work.",
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: self.onRestart))

        self.present(alert, animated: true)
    }

    func showPlayerLost() {
        let alert = UIAlertController(
            title: "Time finished",
            message: "Sorry, time is up! You got \(gameModel.playerAnswers.count) out of \(gameModel.possibleAnswers.count) answers.",
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: self.onRestart))

        self.present(alert, animated: true)
    }

    func onRestart(action: UIAlertAction) {
        self.gameModel.reset()
        self.gameModel.start()
    }
}

extension QuizViewController : LoadingControlDelegate {
    func onLoading(active isLoading: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.question.alpha = isLoading ? 0 : 1
            self.answerEntryContainer.alpha = isLoading ? 0 : 1

            let showAnswers = !isLoading && self.gameModel.state != .stopped
            self.table.alpha = showAnswers ? 1 : 0
        }
    }
}

extension QuizViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let sourceText = textField.text!
        let inputText = sourceText.replacingCharacters(in: Range(range, in: sourceText)!, with: string)

        table.beginUpdates()
        defer { table.endUpdates() }

        let lastRow = IndexPath(row: gameModel.lastAnswers.count, section: 0)

        let response = gameModel.check(answer: inputText)
        if response != .correct {
            table.endUpdates()
            return true
        }

        reloadAnswersCount()
        answerEntry.text = ""
        table.insertRows(at: [lastRow], with: .fade)
        table.scrollToRow(at: lastRow, at: .bottom, animated: true)
        return false
    }
}

extension QuizViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameModel.lastAnswers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "response", for: indexPath)
        if let cell = cell as? ResponseTableViewCell {
            let item = gameModel.lastAnswers[indexPath.row]
            cell.configure(answer: item)
        }
        return cell
    }
}

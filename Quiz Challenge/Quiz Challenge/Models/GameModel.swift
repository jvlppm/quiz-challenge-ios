//
//  GameModel.swift
//  Quiz Challenge
//
//  Created by Joao Vitor P. on 2/15/20.
//  Copyright © 2020 ArcTouch. All rights reserved.
//

import Foundation

enum GameState {
    case stopped, running, finished
}

enum AnswerStatus {
    case unknown, repeated, correct
}

protocol GameModelDelegate {
    func onStart(game: GameModel)
    func onStop(game: GameModel)
}

class GameModel {
    static let GameDuration: TimeInterval = 5 * 60

    public var data: GameData? {
        didSet {
            question = data?.question ?? ""
            let answers = data?.answer ?? []
            let answersNormalized = answers.map({ $0.lowercased() })
            possibleAnswers = Set<String>(answersNormalized)
            self.reset()
        }
    }

    public var delegate: GameModelDelegate?

    private(set) var question = ""
    private(set) var possibleAnswers = Set<String>()

    private(set) var state = GameState.stopped
    private(set) var remainingTime = GameModel.GameDuration

    private(set) var playerAnswers = Set<String>()
    private(set) var lastAnswers = [String]()

    var playerWon: Bool {
        return playerAnswers.count >= possibleAnswers.count
    }

    public func start() {
        self.state = .running
        delegate?.onStart(game: self)
    }

    public func reset() {
        self.state = .stopped
        self.remainingTime = GameModel.GameDuration
        self.playerAnswers.removeAll()
        self.lastAnswers = []
        delegate?.onStop(game: self)
    }

    public func elapse(time: TimeInterval) {
        if state != .running {
            return
        }

        self.remainingTime -= time
        self.remainingTime = max(0, remainingTime)

        if self.remainingTime <= 0 {
            finish()
        }
    }

    public func check(answer: String) -> AnswerStatus {
        if state != .running {
            return .unknown
        }

        let checkAnswer = answer.lowercased()

        guard possibleAnswers.contains(checkAnswer) else {
            return .unknown
        }

        guard playerAnswers.insert(checkAnswer).inserted else {
            return .repeated
        }

        lastAnswers.append(answer)

        if playerAnswers.count >= possibleAnswers.count {
            finish()
        }

        return .correct
    }

    private func finish() {
        state = .finished
        delegate?.onStop(game: self)
    }
}

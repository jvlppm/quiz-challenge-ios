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

class GameModel {
    let GameDuration: TimeInterval = 300

    public let question: String
    public let possibleAnswers: Set<String>

    private(set) var state = GameState.stopped
    private(set) var remainingTime: TimeInterval

    private(set) var playerAnswers = Set<String>()
    private(set) var lastAnswers = [String]()

    var playerWon: Bool {
        return playerAnswers.count >= possibleAnswers.count
    }

    init (data: GameData) {
        self.question = data.question
        self.possibleAnswers = Set<String>(data.answers)

        self.remainingTime = GameDuration
    }

    public func start() {
        self.state = .running
    }

    public func reset() {
        self.state = .stopped
        self.remainingTime = GameDuration
        self.playerAnswers.removeAll()
        self.lastAnswers = []
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
        guard possibleAnswers.contains(answer) else {
            return .unknown
        }

        guard playerAnswers.insert(answer).inserted else {
            return .repeated
        }

        lastAnswers.insert(answer, at: 0)

        if playerAnswers.count >= possibleAnswers.count {
            finish()
        }

        return .correct
    }

    private func finish() {
        state = .finished
    }
}

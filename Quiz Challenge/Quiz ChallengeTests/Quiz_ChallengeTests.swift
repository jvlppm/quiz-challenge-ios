//
//  Quiz_ChallengeTests.swift
//  Quiz ChallengeTests
//
//  Created by Joao Vitor P. on 2/14/20.
//  Copyright © 2020 ArcTouch. All rights reserved.
//

import XCTest
@testable import Quiz_Challenge

class Quiz_ChallengeTests: XCTestCase {

    let sampleGameData = GameData(question: "data", answer: ["1", "2"])

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func createStartedGame() -> GameModel {
        let model = GameModel()
        model.data = sampleGameData
        model.start()
        return model
    }

    func testGameStarts() {
        let game = createStartedGame()
        XCTAssert(game.state == .running)
    }

    func testGameResets() {
        let game = createStartedGame()
        _ = game.check(answer: game.possibleAnswers.first!)
        game.reset()
        XCTAssert(game.state == .stopped)
        XCTAssert(game.playerAnswers.count == 0)
        XCTAssert(game.lastAnswers.count == 0)
    }

    func testGameEndsWithTimer() {
        let game = createStartedGame()
        game.elapse(time: GameModel.GameDuration)
        XCTAssert(game.state == .finished)
        XCTAssert(!game.playerWon)
    }

    func testGameAcceptAnswers() {
        let game = createStartedGame()
        let response = game.check(answer: game.possibleAnswers.first!)
        XCTAssert(response == .correct)
    }

    func testGameEndsWithAllAnswers() {
        let game = createStartedGame()
        for answer in game.possibleAnswers {
            _ = game.check(answer: answer)
        }
        XCTAssert(game.state == .finished)
        XCTAssert(game.playerWon)
    }

    func testGameRejectDuplicateAnswers() {
        let game = createStartedGame()
        _ = game.check(answer: game.possibleAnswers.first!)
        let secondResponse = game.check(answer: game.possibleAnswers.first!)
        XCTAssert(secondResponse == .repeated)
    }

    func testGameRejectUnknownAnswers() {
        let game = createStartedGame()
        let response = game.check(answer: "__")
        XCTAssert(response == .unknown)
    }

    func testAnswersAreSaved() {
        let game = createStartedGame()
        _ = game.check(answer: game.possibleAnswers.first!)
        XCTAssert(game.lastAnswers.first == game.possibleAnswers.first)
    }
}

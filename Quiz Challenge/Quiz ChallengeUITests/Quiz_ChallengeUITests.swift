//
//  Quiz_ChallengeUITests.swift
//  Quiz ChallengeUITests
//
//  Created by Joao Vitor P. on 2/14/20.
//  Copyright © 2020 ArcTouch. All rights reserved.
//

import XCTest

class Quiz_ChallengeUITests: XCTestCase {

    var app: XCUIApplication!
    var answerField: XCUIElement!
    var startButton: XCUIElement!
    var resetButton: XCUIElement!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launch()
        answerField = app.textFields["Insert Word"]
        startButton = app.buttons["Start"]
        resetButton = app.buttons["Reset"]
        continueAfterFailure = false

        startButton.tap()

        XCUIDevice.shared.orientation = .portrait
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStartGameFocusAnswer() {
        XCTAssert(answerField.value(forKey: "hasKeyboardFocus") as? Bool ?? false)
    }

    func testAnswerAcceptedOnLastChar() {
        answerField.typeText("in")
        XCTAssert(answerField.value as? String ?? nil == "in")

        answerField.typeText("t")
        XCTAssert(answerField.value as? String == answerField.placeholderValue)
    }

    func testAnswerIsListed() {
        answerField.typeText("int")
        XCTAssert(app.tables.staticTexts["int"].exists)
    }

    func testResetClearAnswers() {
        answerField.typeText("int")
        resetButton.tap()
        XCTAssert(!app.tables.staticTexts["int"].exists)
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

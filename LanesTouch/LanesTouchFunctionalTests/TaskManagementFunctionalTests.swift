//
// MIT License
//
// Copyright (c) 2018 Marcus Ramsden
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import XCTest

class TaskManagementFunctionalTests: XCTestCase {

    var app: XCUIApplication!
    var screen: ColumnsScreen!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        screen = ColumnsScreen(app: app)
    }

    override func tearDown() {
        screen = nil
        app = nil
        super.tearDown()
    }

    func testUserCanManageTasksOnBoard() {
        // Jo wants to track tasks for her software development project using Lanes
        // so first she launches the app from the home screen
        app.launch()

        // She then creates three columns to track project status; "Todo", "Doing"
        // and "Done"
        screen.create(column: "Todo")
        screen.create(column: "Doing")
        screen.create(column: "Done")

        // She then adds the tasks "User login screen", "Conversation list screen"
        // and "Conversation screen"
        screen.create(task: "User login screen")
        screen.create(task: "Conversation list screen")
        screen.create(task: "Conversation screen")

        // Next she moves the "User login screen" task from the "Todo" column to
        // "Doing" column
    }

}

struct ColumnsScreen {

    let app: XCUIApplication

    func create(column name: String) {
        XCTContext.runActivity(named: "Create a column named \"\(name)\"") { _ in
            add(aColumnNamed: name)
            look(forColumn: name)
        }
    }

    func add(aColumnNamed name: String) {
        XCTContext.runActivity(named: "Add a column named \"\(name)\"") { _ in
            app.navigationBars.buttons["Add"].tap()
            app.buttons["Create Column"].tap()
            app.textFields.matching(NSPredicate(format: "placeholderValue == \"Enter a column name\"")).firstMatch.tap()
            app.textFields.matching(NSPredicate(format: "placeholderValue == \"Enter a column name\"")).firstMatch.typeText(name)
            app.buttons["Done"].tap()
        }
    }

    func create(task name: String) {
        XCTContext.runActivity(named: "Create a column named \"\(name)\"") { _ in
            add(aTaskNamed: name)
            look(forTask: name)
        }
    }

    func add(aTaskNamed name: String) {
        XCTContext.runActivity(named: "Add a task named \"\(name)\"") { _ in
            app.navigationBars.buttons["Add"].tap()
            app.buttons["Create Task"].tap()
            app.textFields.matching(NSPredicate(format: "placeholderValue == \"Enter a task\"")).firstMatch.tap()
            app.textFields.matching(NSPredicate(format: "placeholderValue == \"Enter a task\"")).firstMatch.typeText(name)
            app.buttons["Done"].tap()
        }
    }

    // MARK: Waiters

    static let defaultTimeout: TimeInterval = 1
    let hittable = NSPredicate(format: "hittable == 1")

    func look(forColumn name: String) {
        XCTContext.runActivity(named: "Looking for column \"\(name)\"") { _ in
            XCTAssert(wait(forText: name) == true, "Failed to find column \"\(name)\"")
        }
    }

    func look(forTask name: String) {
        XCTContext.runActivity(named: "Looking for task \"\(name)\"") { _ in
            XCTAssert(wait(forText: name) == true, "Failed to find task \"\(name)\"")
        }
    }

    func wait(forText text: String) -> Bool {
        let expectation = XCTNSPredicateExpectation(predicate: hittable, object: app.staticTexts[text])
        let waiter = XCTWaiter()
        waiter.wait(for: [expectation], timeout: ColumnsScreen.defaultTimeout)
        return waiter.fulfilledExpectations.count == 1
    }

}

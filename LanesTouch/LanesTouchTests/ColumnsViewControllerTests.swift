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

@testable import LanesTouch
import UIKit
import XCTest

class ColumnsViewControllerTests: XCTestCase {

    var window: UIWindow?
    var navigationController: UINavigationController? {
        didSet {
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }

    override func setUp() {
        super.setUp()
        window = UIWindow(frame: UIScreen.main.bounds)
    }

    override func tearDown() {
        navigationController = nil
        window = nil
        super.tearDown()
    }

    func test_showCreateOptions_shouldPresentAnActionSheet() {
        let sut = makeSut()

        sut.showCreateOptions()

        guard let presentedViewController = sut.presentedViewController as? UIAlertController else {
            return XCTFail("Expected presentedViewController to be a UIAlertController")
        }
        XCTAssert(presentedViewController.preferredStyle == .actionSheet, "Expected alert controller's preferred style to be an action sheet")
    }

    func test_showCreateOptions_shouldPresentAnActionSheetWithACreateColumnButton() {
        let sut = makeSut()

        sut.showCreateOptions()

        guard let presentedViewController = sut.presentedViewController as? UIAlertController else {
            return XCTFail("Expected presentedViewController to be a UIAlertController")
        }
        XCTAssert(presentedViewController.actions.filter({ $0.title == "Create Column" }).isEmpty == false, "Expected an action titled 'Create Column'")
    }

    func test_showCreateOptions_shouldPresentAnActionSheetWithACreateTaskButton() {
        let sut = makeSut()

        sut.showCreateOptions()

        guard let presentedViewController = sut.presentedViewController as? UIAlertController else {
            return XCTFail("Expected presentedViewController to be a UIAlertController")
        }
        XCTAssert(presentedViewController.actions.filter({ $0.title == "Create Task" }).isEmpty == false, "Expected an action titled 'Create Task'")
    }

    func test_instantiateInitialViewController_shouldCreateAUINavigationController() {
        _ = makeSut()
        XCTAssert(navigationController != nil, "Expected viewController to be a UINavigationController")
    }

    func test_showCreateColumn_shouldPushACreateColumnViewController() {
        let sut = makeSut()

        sut.showCreateColumn()

        expectation(for: NSPredicate(format: "viewControllers.@count > 1"), evaluatedWith: navigationController as Any, handler: nil)
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssert(navigationController?.visibleViewController is CreateColumnViewController, "Expected visibleViewController to be a CreateColumnViewController")
    }

    func test_showCreateTask_shouldPushACreateTaskViewController() {
        let sut = makeSut()

        sut.showCreateTask()

        expectation(for: NSPredicate(format: "viewControllers.@count > 1"), evaluatedWith: navigationController as Any, handler: nil)
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssert(navigationController?.visibleViewController is CreateTaskViewController, "Expected visibleViewController to be a CreateTaskViewController")
    }

    private func makeSut() -> ColumnsViewController {
        guard let navigationController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController() as? UINavigationController else {
            fatalError("Expected initialViewController to be a UINavigationController")
        }
        self.navigationController = navigationController

        guard let sut = navigationController.viewControllers.first as? ColumnsViewController else {
            fatalError("Expected root view controller of navigation controller to be a ColumnsViewController")
        }

        return sut
    }

}

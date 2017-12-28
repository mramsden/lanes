//
// MIT License
//
// Copyright (c) 2017 Bitsden
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

import UIKit
import XCTest

class BoardStoryboardTests: XCTestCase {
    
    func test_initialViewController_shouldBeANavigationController() {
        let sut = makeSut()
        XCTAssertTrue(sut.instantiateInitialViewController() is UINavigationController)
    }

    func test_board_shouldBeAValidViewControllerIdentifier() {
        let sut = makeSut()
        XCTAssertNotNil(sut.instantiateViewController(withIdentifier: "Board"))
    }

    func test_board_shouldHaveAColumnCell() {
        let dataSource = StubDataSource()
        guard let boardViewController = makeBoardViewController(dataSource: dataSource) else { return }
        XCTAssertNotNil(boardViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: "Column", for: IndexPath(item: 0, section: 0)))
    }

    // MARK: Helpers

    func makeSut() -> UIStoryboard {
        return UIStoryboard(name: "Board", bundle: .main)
    }

    func makeBoardViewController(dataSource: UICollectionViewDataSource) -> UICollectionViewController? {
        guard let boardViewController = makeSut().instantiateViewController(withIdentifier: "Board") as? UICollectionViewController else {
            XCTFail("Expected Board to be a UICollectionViewController")
            return nil
        }
        boardViewController.collectionView?.dataSource = dataSource
        return boardViewController
    }

    class StubDataSource: NSObject, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return UICollectionViewCell()
        }
    }

}

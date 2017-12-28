//
// MIT License
//
// Copyright (c) 2017 Marcus Ramsden
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

import Lanes
import UIKit

private let reuseIdentifier = "Column"

class BoardViewController: UICollectionViewController {

    var boardService: BoardService? = nil

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = view.bounds.size
        }
    }

    // MARK: Actions

    @IBAction func addColumn() {
        let createColumnTitle = NSLocalizedString("dialog_create_column_title", comment: "Create column dialog title")
        let createColumnActionTitle = NSLocalizedString("dialog_create_column_submit_action", comment: "Create column dialog submit")
        showTextPrompt(title: createColumnTitle, actionTitle: createColumnActionTitle) { [weak self] result in
            if case .submitted(let newName) = result {
                self?.create(column: newName)
            }
        }
    }

    func create(column name: String) {
        boardService?.create(column: name)
        boardService?.fetchColumns { columns in
            print(columns)
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

}

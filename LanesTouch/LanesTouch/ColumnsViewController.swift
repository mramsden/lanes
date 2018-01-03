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

import UIKit

class ColumnsViewController: UITableViewController {

    var columns: [String] = []

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createColumnViewController = segue.destination as? CreateColumnViewController {
            createColumnViewController.nameEntered = { name in
                self.columns.append(name)
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func showCreateOptions() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Create Column", style: .default, handler: { _ in
            self.showCreateColumn()
        }))
        actionSheet.addAction(UIAlertAction(title: "Create Task", style: .default, handler: { _ in
            self.showCreateTask()
        }))

        present(actionSheet, animated: true, completion: nil)
    }

    func showCreateColumn() {
        performSegue(withIdentifier: "CreateColumn", sender: self)
    }

    func showCreateTask() {
        performSegue(withIdentifier: "CreateTask", sender: self)
    }

    @IBAction func creationComplete(segue: UIStoryboardSegue)

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return columns.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Column", for: indexPath)

        cell.textLabel?.text = columns[indexPath.row]

        return cell
    }

}

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


import Foundation

public class BoardService {

    public typealias FetchColumnsCallback = ([String]) -> ()
    public typealias FetchTasksCallback = ([String]) -> ()

    private var columns: [String] = []
    private var tasks: [String: [String]] = [:]

    public func create(column: String) {
        var columns = self.columns
        columns.append(column)
        self.columns = columns
    }

    public func fetchColumns(completion: @escaping FetchColumnsCallback) {
        completion(columns)
    }

    public func add(task: String, to column: String) {
        guard columns.contains(column) else { return }
        var tasks: [String] = self.tasks[column] ?? []
        tasks.append(task)
        self.tasks[column] = tasks
    }

    public func fetch(tasksInColumn column: String, completion: @escaping FetchTasksCallback) {
        let tasks = self.tasks[column] ?? []
        completion(tasks)
    }

    public func move(column: String, to newIndex: Int) {
        guard let oldIndex = columns.index(of: column) else { return }
        self.columns = rearrange(self.columns, from: oldIndex, to: newIndex)
    }

    public func move(task: String, in column: String, to newIndex: Int) {
        guard var tasks = self.tasks[column], let oldIndex = tasks.index(of: task) else {
            return
        }

        _ = tasks.remove(at: oldIndex)
        tasks.insert(task, at: newIndex)
        self.tasks[column] = tasks
    }

    public func remove(column: String) {
        guard let index = self.columns.index(of: column) else { return }

        _ = columns.remove(at: index)
        tasks.removeValue(forKey: column)
    }

}

private func rearrange<T>(_ array: [T], from fromIndex: Int, to toIndex: Int) -> [T] {
    var rearranged = array
    let element = rearranged.remove(at: fromIndex)
    rearranged.insert(element, at: toIndex)
    return rearranged
}

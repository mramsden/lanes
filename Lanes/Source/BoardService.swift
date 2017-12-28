//
// Copyright © 2017 Bitsden. All rights reserved.
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

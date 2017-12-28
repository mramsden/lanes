//
// Copyright © 2017 Bitsden. All rights reserved.
//

@testable import Lanes
import XCTest

class BoardServiceTests: XCTestCase {

    func test_createColumn_shouldCreateAColumn() {
        let sut = BoardService()

        sut.create(column: "Todo")

        let fetchedColumns = fetchColumns(from: sut)
        XCTAssertEqual(fetchedColumns, ["Todo"])
    }

    func test_addTaskToColumn_shouldCreateATask() {
        let sut = makeSut(columns: "Todo")

        sut.add(task: "Write implementation", to: "Todo")

        let fetchedTasks = fetch(sut, tasksInColumn: "Todo")
        XCTAssertEqual(fetchedTasks, ["Write implementation"])
    }

    func test_addTaskToColumn_shouldBeAbleToAddMultipleTasks() {
        let sut = makeSut(columns: "Todo")

        sut.add(task: "Add test", to: "Todo")
        sut.add(task: "Write implementation", to: "Todo")

        let fetchedTasks = fetch(sut, tasksInColumn: "Todo")
        XCTAssertEqual(fetchedTasks, ["Add test", "Write implementation"])
    }

    func test_addTaskToColumn_shouldNotCreateATask_whenColumnDoesNotExist() {
        let sut = makeSut()

        sut.add(task: "Write implementation", to: "Todo")

        let fetchedTasks = fetch(sut, tasksInColumn: "Todo")
        XCTAssertEqual(fetchedTasks, [])
    }

    func test_fetchTasksInColumn_shouldReturnEmptyArray_whenColumnDoesNotExist() {
        let sut = makeSut()

        let fetchedColumns = fetch(sut, tasksInColumn: "Todo")
        XCTAssertEqual(fetchedColumns, [])
    }

    func test_moveColumnToIndex_shouldReorderColumns() {
        let sut = makeSut(columns: "Todo", "Doing", "Done")

        sut.move(column: "Todo", to: 2)

        let fetchedColumns = fetchColumns(from: sut)
        XCTAssertEqual(fetchedColumns, ["Doing", "Done", "Todo"])
    }

    func test_moveColumnToIndex_shouldWorkWithLastColumn() {
        let sut = makeSut(columns: "Todo", "Doing", "Done")

        sut.move(column: "Done", to: 0)

        let fetchedColumns = fetchColumns(from: sut)
        XCTAssertEqual(fetchedColumns, ["Done", "Todo", "Doing"])
    }

    func test_moveTaskToIndex_shouldReorderTasks() {
        let sut = makeSut(columns: "Todo")
        add(tasks: "Buy bread", "Buy milk", to: "Todo", in: sut)

        sut.move(task: "Buy milk", in: "Todo", to: 0)

        let fetchedTasks = fetch(sut, tasksInColumn: "Todo")
        XCTAssertEqual(fetchedTasks, ["Buy milk", "Buy bread"])
    }

    func test_removeColumn_shouldDeleteColumn() {
        let sut = makeSut(columns: "Todo", "Doing", "Done")

        sut.remove(column: "Todo")

        let fetchedColumns = fetchColumns(from: sut)
        XCTAssertEqual(fetchedColumns, ["Doing", "Done"])
    }

    func test_removeColumn_shouldDeleteAssociatedTasks() {
        let sut = makeSut(columns: "Todo", "Doing", "Done")
        sut.add(task: "Write implementation", to: "Todo")

        sut.remove(column: "Todo")

        let fetchedTasks = fetch(sut, tasksInColumn: "Todo")
        XCTAssertEqual(fetchedTasks, [])
    }

    // MARK: Helpers

    func makeSut(columns: String...) -> BoardService {
        let boardService = BoardService()
        columns.forEach(boardService.create(column:))
        return boardService
    }

    func add(tasks: String..., to column: String, in boardService: BoardService) {
        tasks.forEach { boardService.add(task: $0, to: column) }
    }

    func fetchColumns(from sut: BoardService) -> [String] {
        var fetchedColumns: [String] = []
        sut.fetchColumns { columns in
            fetchedColumns = columns
        }
        return fetchedColumns
    }

    func fetch(_ sut: BoardService, tasksInColumn: String) -> [String] {
        var fetchedTasks: [String] = []
        sut.fetch(tasksInColumn: "Todo") { tasks in
            fetchedTasks = tasks
        }
        return fetchedTasks
    }

}

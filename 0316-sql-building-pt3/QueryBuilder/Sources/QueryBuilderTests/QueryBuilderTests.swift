import InlineSnapshotTesting
import Testing

@testable import QueryBuilder

@Suite(.snapshots(record: .failed)) struct QueryBuilderTests {
  @Test func basics() {
    assertInlineSnapshot(
      of: Select(columns: ["id", "title"], from: "reminders"),
      as: .sql
    ) {
      """
      SELECT id, title
      FROM reminders
      """
    }
  }

  @Test func emptyColumns() {
    assertInlineSnapshot(
      of: Select(columns: [], from: "reminders"),
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      """
    }
  }

  @Test func selectWithColumns() {
    assertInlineSnapshot(
      of: Reminder.select("id", "title", "priority"),
      as: .sql
    ) {
      """
      SELECT id, title, priority
      FROM reminders
      """
    }
  }

  @Test func selectAll() {
    assertInlineSnapshot(
      of: Reminder.all(),
      as: .sql
    ) {
      """
      SELECT *
      FROM reminders
      """
    }
  }

  @Test func selectCount() {
    assertInlineSnapshot(
      of: Tag.count(),
      as: .sql
    ) {
      """
      SELECT count(*)
      FROM tags
      """
    }
  }

  @Test func selectWithKeyPaths() {
    assertInlineSnapshot(
      of: Reminder.select(\.id, \.title),
      as: .sql
    ) {
      """
      SELECT id, title
      FROM reminders
      """
    }
  }
}

struct Reminder: Table {
  // -----
  struct Columns {
    let id = "id"
    let title = "title"
    let isCompleted = "isCompleted"
    let priority = "priority"
  }
  static let columns = Columns()
  static let tableName = "reminders"
  // -----

  let id: Int
  var title = ""
  var isCompleted = false
  var priority: Int?

  var titleIsLong: Bool { title.count >= 100 }
}

struct Tag: Table {
  struct Columns {}
  static let columns = Columns()

  static let tableName = "tags"
}

import QtQuick
import QtQuick.Layouts
import qs
import qs.Ui

ColumnLayout {
  id: root

  property date today: new Date()
  property int viewYear: today.getFullYear()
  property int viewMonth: today.getMonth()

  readonly property var locale: Qt.locale()
  readonly property int firstDayOfWeek: locale.firstDayOfWeek
  readonly property int cellWidth: 64
  readonly property int cellHeight: 36

  spacing: 8

  function dateAt(index) {
    var first = new Date(viewYear, viewMonth, 1)
    var startOffset = (first.getDay() - firstDayOfWeek + 7) % 7
    return new Date(viewYear, viewMonth, 1 - startOffset + index)
  }

  function isSameDay(a, b) {
    return a.getFullYear() === b.getFullYear()
        && a.getMonth() === b.getMonth()
        && a.getDate() === b.getDate()
  }

  function shiftMonth(delta) {
    var next = new Date(viewYear, viewMonth + delta, 1)
    viewYear = next.getFullYear()
    viewMonth = next.getMonth()
  }

  RowLayout {
    Layout.fillWidth: true
    spacing: 4

    PanelButton {
      onClicked: root.shiftMonth(-1)
      Icon { size: 16; name: "chevron-left.svg" }
    }

    Text {
      Layout.fillWidth: true
      horizontalAlignment: Text.AlignHCenter
      text: locale.standaloneMonthName(root.viewMonth) + " " + root.viewYear
      color: Styles.foreground
      font.pointSize: Styles.font.lg
    }

    PanelButton {
      onClicked: root.shiftMonth(1)
      Icon { size: 16; name: "chevron-right.svg" }
    }
  }

  Row {
    Layout.alignment: Qt.AlignHCenter
    spacing: 0

    Repeater {
      model: 7
      Text {
        required property int index
        width: root.cellWidth
        height: 22
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: root.locale.dayName((root.firstDayOfWeek + index) % 7, Locale.ShortFormat)
        color: Styles.secondary
        font.pointSize: Styles.font.sm
      }
    }
  }

  Grid {
    Layout.alignment: Qt.AlignHCenter
    columns: 7
    rows: 6
    spacing: 0

    Repeater {
      model: 42

      Item {
        id: cell

        required property int index
        readonly property date date: root.dateAt(index)
        readonly property bool currentMonth: date.getMonth() === root.viewMonth
        readonly property bool isToday: root.isSameDay(date, root.today)

        width: root.cellWidth
        height: root.cellHeight

        Text {
          anchors.centerIn: parent
          text: cell.date.getDate()
          color: cell.isToday ? Styles.accent : (cell.currentMonth ? Styles.foreground : Styles.muted)
          font.pointSize: Styles.font.md
          font.weight: cell.isToday ? Font.DemiBold : Font.Normal
        }
      }
    }
  }
}

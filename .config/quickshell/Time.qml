pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
  readonly property date date: clock.date
  readonly property string time: Qt.formatDateTime(clock.date, "MMMM d hh:mm")

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}

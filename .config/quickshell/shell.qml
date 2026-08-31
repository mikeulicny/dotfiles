import Quickshell
import Quickshell.Io // for Process
import QtQuick
import qs.Modules

Scope {
  Bar {
    id: bar
  }
  Notifications {
    barHeight: bar.barHeight
  }
  VolumeOsd {}
}

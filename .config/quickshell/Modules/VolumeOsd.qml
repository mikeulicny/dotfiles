pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs
import qs.Ui
import qs.Services

Scope {
  id: root

  property bool shouldShowOsd: false
  property real osdOpacity: 0

  onShouldShowOsdChanged: osdOpacity = shouldShowOsd ? 1 : 0

  Behavior on osdOpacity {
    NumberAnimation {
      duration: 100
    }
  }

  Connections {
    target: AudioService

    function onVolumeChanged() {
      root.shouldShowOsd = true
      hideTimer.restart()
    }
  }

  Timer {
    id: hideTimer
    interval: 800
    onTriggered: root.shouldShowOsd = false
  }

  LazyLoader {
    active: root.shouldShowOsd || root.osdOpacity > 0

    PanelWindow {
      anchors.top: true
      margins.top: 200
      exclusiveZone: 0

      implicitWidth: 600
      implicitHeight: 50
      color: Styles.transparent

      mask: Region {}

      Rectangle {
        anchors.fill: parent
        radius: height / 2
        opacity: root.osdOpacity
        color: Styles.barBackground
        border.width: 1
        border.color: Styles.border

        RowLayout {
          spacing: 10
          anchors {
            fill: parent
            leftMargin: 20
            rightMargin: 20
          }

          Icon {
            size: 22
            name: AudioService.volumeIcon()
          }

          Rectangle {
            Layout.fillWidth: true
            implicitHeight: 10
            radius: height / 2
            color: Styles.border

            Rectangle {
              anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
              }
              width: parent.width * (AudioService.muted ? 0 : AudioService.volume)
              radius: parent.radius
              color: Styles.foreground
            }
          }

          Text {
            Layout.preferredWidth: 50
            horizontalAlignment: Text.AlignRight
            text: Math.floor((AudioService.muted ? 0 : AudioService.volume) * 100) + "%"
            color: Styles.foreground
            font.pointSize: Styles.font.md
          }
        }
      }
    }
  }
}

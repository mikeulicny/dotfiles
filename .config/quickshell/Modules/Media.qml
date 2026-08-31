import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs
import qs.Ui

BarWidget {
  id: root
  moduleName: "media"

  readonly property var player: {
    var players = Mpris.players.values
    return players.length > 0 ? players[players.length - 1] : null
  }

  visible: player && player.playbackState !== MprisPlaybackState.Stopped
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  onVisibleChanged: {
    if (!visible && panel.visible)
      panel.close()
  }

  function formatTime(seconds) {
    if (!isFinite(seconds) || seconds < 0)
      seconds = 0
    var total = Math.floor(seconds)
    var h = Math.floor(total / 3600)
    var m = Math.floor((total % 3600) / 60)
    var s = total % 60
    var mm = (m < 10 ? "0" : "") + m
    var ss = (s < 10 ? "0" : "") + s
    if ((root.player && root.player.length > 3600) || h > 0)
      return h + ":" + mm + ":" + ss
    return m + ":" + ss
  }

  WidgetButton {
    id: button
    bar: root.bar
    popup: panel
    anchors.centerIn: parent

    Icon {
      size: 16
      name: "audio-lines.svg"
    }

    Text {
      visible: text !== ""
      text: root.player ? root.player.trackTitle : ""
      color: Styles.foreground
      font.pointSize: Styles.font.md
    }
  }

  WidgetPanel {
    id: panel
    bar: root.bar
    anchorItem: button
    implicitWidth: 640

    FrameAnimation {
      running: panel.visible && root.player && root.player.isPlaying
      onTriggered: {
        if (root.player)
          root.player.positionChanged()
      }
    }

    RowLayout {
      spacing: 14

      Rectangle {
        Layout.preferredWidth: 120
        Layout.preferredHeight: 120
        Layout.minimumWidth: 120
        Layout.minimumHeight: 120
        radius: Styles.radiusPanel
        color: Styles.fill
        clip: true

        Image {
          anchors.fill: parent
          source: root.player ? root.player.trackArtUrl : ""
          fillMode: Image.PreserveAspectCrop
          asynchronous: true
          visible: status === Image.Ready
        }

        Icon {
          anchors.centerIn: parent
          size: 36
          name: "audio-lines.svg"
          color: Styles.muted
          visible: !root.player || !root.player.trackArtUrl
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 8

        Text {
          Layout.fillWidth: true
          visible: text !== ""
          text: root.player ? root.player.trackTitle : ""
          color: Styles.foreground
          font.pointSize: Styles.font.lg
          elide: Text.ElideRight
        }

        Text {
          Layout.fillWidth: true
          visible: text !== ""
          text: root.player ? root.player.trackArtist : ""
          color: Styles.secondary
          font.pointSize: Styles.font.sm
          elide: Text.ElideRight
        }

        Item { Layout.fillHeight: true }

        Slider {
          id: progress
          Layout.fillWidth: true
          from: 0
          to: root.player && root.player.length > 0 ? root.player.length : 1
          enabled: root.player && root.player.canSeek && root.player.positionSupported
          onMoved: {
            if (root.player && root.player.canSeek)
              root.player.position = value
          }

          Binding on value {
            value: root.player ? root.player.position : 0
            when: !progress.pressed
          }
        }

        RowLayout {
          Layout.fillWidth: true
          spacing: 8

          Text {
            text: root.formatTime(root.player ? root.player.position : 0)
            color: Styles.secondary
            font.pointSize: Styles.font.sm
          }

          Item { Layout.fillWidth: true }

          PanelButton {
            enabled: root.player && root.player.canGoPrevious
            onClicked: root.player.previous()
            Icon { size: 16; name: "backward.svg" }
          }

          PanelButton {
            enabled: root.player && root.player.canTogglePlaying
            onClicked: root.player.togglePlaying()
            Icon { size: 16; name: root.player && root.player.isPlaying ? "pause.svg" : "play.svg" }
          }

          PanelButton {
            enabled: root.player && root.player.canGoNext
            onClicked: root.player.next()
            Icon { size: 16; name: "forward.svg" }
          }

          Item { Layout.fillWidth: true }

          Text {
            text: root.formatTime(root.player ? root.player.length : 0)
            color: Styles.secondary
            font.pointSize: Styles.font.sm
          }
        }
      }
    }
  }
}

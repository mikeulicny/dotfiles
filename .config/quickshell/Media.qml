import QtQuick
import Quickshell.Services.Mpris
import "Ui"

BarWidget {
  id: root
  moduleName: "media"

  readonly property var player: {
    var players = Mpris.players.values
    for (var i = 0; i < players.length; i++) {
      if (players[i].isPlaying)
        return players[i]
    }
    return players.length > 0 ? players[players.length - 1] : null
  }

  visible: player !== null
  implicitWidth: visible ? button.implicitWidth : 0
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    bar: root.bar
    anchors.centerIn: parent

    Icon {
      size: 16
      name: "audio-lines.svg"
    }

    Text {
      text: root.player ? (root.player.trackTitle || "Unknown Title") : ""
      color: "#E6E6E6"
      font.pointSize: 12
    }
  }
}

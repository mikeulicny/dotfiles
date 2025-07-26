import QtQuick
import Quickshell.Hyprland

Row {
  id: root
  spacing: -4

  readonly property var workspace: Hyprland.focusedWorkspace

  Repeater {
    model: 5

    Rectangle {

      implicitWidth: 40
      implicitHeight: 30
      color: workspace.id === modelData + 1 ? "#20FFFFFF" : "transparent"
      radius: 6

      Text {
        anchors.centerIn: parent
        text: modelData + 1
        color: "#FFFFFF"
        font.pointSize: 14
      }

      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch('workspace ' + (modelData+1))
      }
    }
  }
}

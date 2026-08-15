import QtQuick
import Quickshell.Hyprland

BarWidget {
  id: root
  moduleName: "workspaces"
  readonly property var workspace: Hyprland.focusedWorkspace

  implicitHeight: 36

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }

    return null
  }

  function workspaceIds() {
    var ids = [1, 2, 3, 4, 5]
    var values = Hyprland.workspaces.values

    for (var i = 0; i < values.length; i++) {
      var id = values[i].id
      if (id > 0 && id <= 10 && ids.indexOf(id) === -1) ids.push(id)
    }

    ids.sort(function(left, right) { return left - right})
    return ids
  }

  Row {
    id: row
    anchors.fill: parent
    spacing: -4

    Repeater {
      model: root.workspaceIds()

      Rectangle {
        required property int modelData

        readonly property var workspace: root.workspaceById(modelData)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData

        implicitWidth: 40
        implicitHeight: 26
        anchors.verticalCenter: parent.verticalCenter

        color: focused ? "#20FFFFFF" : "transparent"
        radius: 6

        Text {
          anchors.centerIn: parent
          text: (parent.modelData === 10 ? "0" : parent.modelData)
          color: "#FFFFFF"
          font.pointSize: 12
        }

        MouseArea {
          anchors.fill: parent
          onClicked: parent.workspace.activate()
        }
      }
    }
  }
}

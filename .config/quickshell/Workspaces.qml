pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "Ui"

BarWidget {
  id: root
  moduleName: "workspaces"
  readonly property var workspace: Hyprland.focusedWorkspace

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

  RowLayout {
    id: row
    anchors.fill: parent
    spacing: -5

    Repeater {
      model: root.workspaceIds()

      WidgetButton {
        id: button
        bar: root.bar

        required property int modelData

        readonly property var workspace: root.workspaceById(modelData)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData

        z: focused ? 1 : 0
        onPressed: workspace.activate()

        Text {
          text: button.modelData
          color: button.focused ? "#F59E0B" : button.occupied ? "#FFFFFF" : "#40FFFFFF"
          font.pointSize: 12
        }
      }
    }
  }
}

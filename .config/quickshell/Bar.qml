import Quickshell

Scope {
  id: barScope
  readonly property int barHeight: 36

  Variants {
    model: Quickshell.screens;

    PanelWindow {
      required property var modelData

      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: barScope.barHeight
      color: "#AA0B0B0F"

      SystemLogo {
        id: logo
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
      }

      Workspaces {
        bar: barScope
        anchors.left: logo.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
      }

      Clock {
        anchors.centerIn: parent
      }

    }
  }
}

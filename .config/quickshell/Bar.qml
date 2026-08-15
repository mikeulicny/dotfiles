import Quickshell

Scope {

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

      implicitHeight: 36
      color: "#AA0B0B0F"

      SystemLogo {
        id: logo
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
      }

      Workspaces {
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

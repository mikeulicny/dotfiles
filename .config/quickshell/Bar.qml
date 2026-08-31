import Quickshell
import QtQuick.Layouts
import qs.Modules

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
      color: Styles.barBackground

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
      }

      Clock {
        id: clock
        bar: barScope
        anchors.centerIn: parent
      }

      Capture {
        id: capture
        anchors.left: clock.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
      }

      Media {
        bar: barScope
        anchors.right: controlModules.left
        anchors.rightMargin: 10
      }

      RowLayout {
        id: controlModules

        anchors.right: parent.right
        anchors.rightMargin: 10
        spacing: -5
        implicitHeight: barScope.barHeight
        anchors.verticalCenter: parent.verticalCenter

        System { bar: barScope }
        Audio { bar: barScope }
        Bluetooth { bar: barScope }
        Network { bar: barScope }
        Battery { bar: barScope }

      }
    }
  }
}

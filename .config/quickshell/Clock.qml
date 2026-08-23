import QtQuick
import "Ui"

BarWidget {
  id: root
  moduleName: "clock"

  WidgetButton {
    bar: root.bar
    anchors.centerIn: parent

    Text {
      text: Time.time
      color: "#E6E6E6"
      font.pointSize: 14
    }
  }
}

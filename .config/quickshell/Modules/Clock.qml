import QtQuick
import qs
import qs.Ui

BarWidget {
  id: root
  moduleName: "clock"
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    bar: root.bar
    popup: panel
    anchors.centerIn: parent

    Text {
      text: Time.time
      color: Styles.foreground
      font.pointSize: Styles.font.lg
    }
  }

  WidgetPanel {
    id: panel
    bar: root.bar
    anchorItem: button
    implicitWidth: calendar.implicitWidth + padding * 2

    // Center the panel to the clock button
    anchor.rect.x: Math.round((button.width - width) / 2)
    anchor.rect.y: 0
    anchor.rect.width: 1
    anchor.rect.height: button.height

    Calendar {
      id: calendar
      today: Time.date
    }
  }
}
